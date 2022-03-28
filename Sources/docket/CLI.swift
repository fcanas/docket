//
//  CLI.swift
//  Docket
//
//  Created by Fabián Cañas on 3/26/22.
//  Copyright © 2022 Fabián Cañas. All rights reserved.
//

import Foundation
import AppKit

enum Command: String {
    case blocking = "--blocking"
    case help = "--help"
}

extension String: Error {}

@main
struct CLI {
    static func main() throws {
        let info = ProcessInfo.processInfo
        let args = info.arguments
        
        // Find existing Docket
        // TODO
        
        guard
            args.count > 1
        else {
            printHelp()
            return
        }
        
        switch Command(rawValue: args[1]) {
        case .help:
            printHelp()
        case .blocking:
            // Blocking command. Read docket JSON from stdin.
            
            guard
                let data = try? FileHandle.standardInput.readToEnd(),
                let docket = try? JSONDecoder().decode(Docket.self, from: data)
            else {
                // Running with no stdout to prevent noise to console.
                return
            }
            
            App(docket: docket)
        case nil:
            // Invoked with path
            guard
                let data = FileManager.default.contents(atPath: args[1]),
                (try? JSONDecoder().decode(Docket.self, from: data)) != nil
            else {
                throw "Unable to parse Docket at path \(args[1])"
            }
            
            let child = Process()
            child.executableURL = URL(fileURLWithPath: args[0])
            
            // Run without stderr or stdout to prevent noise to console
            child.standardError = nil
            child.standardOutput = nil
            
            // Pass docket JSON file contents to stdin
            let pipe = Pipe()
            child.standardInput = pipe
            child.arguments = [Command.blocking.rawValue, args[1]]
            try? child.run()
            pipe.fileHandleForWriting.write(data)
        }
    }
    static func printHelp() {
        print(
"""
OVERVIEW: Shows a timeline overlay to keep you on schedule

USAGE: docket [options] [json-filepath]

Invoke docket with single argument to a json file. Docket will start a new
process to show a timeline at the top of your screen and announce each segment
as you reach it.

A Docket is a JSON object with a single "segments" key for an array of segment
objects. A segment has a "name" string-value and a "duration" number value. The
"name" is shown in a notification bezel at the beginning of a segment. Duration
is expressed in seconds.

  {
      "segments": [
          {
              "name": "Intro",
              "duration": 10
          },
          {
              "name": "Middle",
              "duration": 15
          },
          {
              "name": "Closing",
              "duration": 10
          }
      ]
  }

OPTIONS:
  --help        Show help information.
  --blocking    Reads JSON data from standard input, runs a Docket, and exits
                after the Docket completes. This option cannot be combined with
                a path to a JSON file.
"""
        )
    }
}
