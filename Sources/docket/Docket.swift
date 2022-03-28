//
//  Docket.swift
//  Docket
//
//  Created by Fabián Cañas on 3/26/22.
//  Copyright © 2022 Fabián Cañas. All rights reserved.
//

import Foundation

struct Docket: Equatable, Decodable {
    internal init(segments: [Docket.Segment]) {
        self.segments = segments
        self.totalDuration = segments.reduce(0) { partialResult, segment in
            return partialResult + segment.duration
        }
    }
    struct Segment: Equatable, Decodable {
        var name: String
        var duration: TimeInterval
    }
    var segments: [Segment] {
        didSet {
            totalDuration = segments.reduce(0) { partialResult, segment in
                return partialResult + segment.duration
            }
        }
    }
    var totalDuration: TimeInterval
    
    func segment(for targetInterval: TimeInterval) -> Docket.Segment? {
        var iter = segments.makeIterator()
        var indexTime: TimeInterval = 0
        var segmentOut: Segment? = nil
        while indexTime < targetInterval, let nextSegment = iter.next() {
            indexTime += nextSegment.duration
            segmentOut = nextSegment
        }
        return segmentOut
    }
    
    enum CodingKeys: String, CodingKey {
        case segments = "segments"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        segments = try values.decode([Segment].self, forKey: .segments)
        self.totalDuration = segments.reduce(0) { partialResult, segment in
            return partialResult + segment.duration
        }
    }
}
