//
//  App.swift
//  Docket
//
//  Created by Fabián Cañas on 3/26/22.
//  Copyright © 2022 Fabián Cañas. All rights reserved.
//

import AppKit

func App(docket: Docket) {
    
    let app = NSApplication.shared
    app.setActivationPolicy(.accessory)
    
    DispatchQueue.main.async {
        guard
            let mainScreen = NSScreen.main
        else {
            fatalError()
        }
        let height: CGFloat = 30
        let fudge: CGFloat = 3
        let window = NSWindow(contentRect: NSRect(x: -2,
                                                  y: mainScreen.frame.height - (NSStatusBar.system.thickness + height + fudge),
                                                  width: mainScreen.frame.width + 4,
                                                  height: height),
                              styleMask: [.fullSizeContentView, .borderless],
                              backing: .buffered,
                              defer: false)
        window.titlebarAppearsTransparent = true
        window.contentView?.wantsLayer = true
        window.isOpaque = false
        window.backgroundColor = .clear
        window.collectionBehavior = .canJoinAllSpaces
        window.level = .mainMenu
        window.ignoresMouseEvents = true
        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
        
        let presenterLayer = CALayer()
        presenterLayer.frame = CGRect(origin: .zero, size: window.contentView!.layer!.frame.size)
        
        // Make this mutable and you can animate changes in the docket
        let presenter = DocketPresenter(docket: docket, layer: presenterLayer)
        window.contentView?.layer?.addSublayer(presenter.layer)
        
        let cursor = CALayer()
        cursor.frame = CGRect(x: 0, y: 0, width: 3, height: height)
        cursor.backgroundColor = .black
        cursor.cornerRadius = 1
        cursor.borderColor = CGColor(gray: 0.9, alpha: 0.8)
        cursor.borderWidth = 0.5
        
        window.contentView?.layer?.addSublayer(cursor)
        let startTime = Date.now
        
        var currentSegment: Docket.Segment? = nil
        
        let t = Timer(fire: .now, interval: 1, repeats: true) { timer in
            CATransaction.begin()
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .linear))
            CATransaction.setAnimationDuration(1)
            let scale = window.frame.width / presenter.docket.totalDuration
            
            let now = Date.now.timeIntervalSince(startTime)
            
            if
                let segment = docket.segment(for: now),
                currentSegment != segment
            {
                currentSegment = segment
                Notify(message: segment.name)
            }
            
            cursor.frame.origin.x = now * scale
            CATransaction.commit()
            if now > presenter.docket.totalDuration {
                timer.invalidate()
                Notify(message: "Bye!")
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3500)) {
                    app.terminate(nil)
                }
            }
        }
        RunLoop.main.add(t, forMode: .common)
    }
    app.run()
}

struct DocketPresenter {
    internal init(docket: Docket, layer: CALayer = CALayer()) {
        self.docket = docket
        self.layer = layer
        refreshLayers()
    }
    var docket: Docket {
        didSet {
            refreshLayers()
        }
    }
    var layer: CALayer
    
    mutating func layout() {
        refreshLayers()
    }
    
    private mutating func refreshLayers() {
        var sublayers = layer.sublayers ?? []
        let numberOfLayersToRemove = sublayers.count - docket.segments.count
        if numberOfLayersToRemove > 0 {
            sublayers[sublayers.endIndex.advanced(by: -numberOfLayersToRemove)...].forEach { $0.removeFromSuperlayer()
            }
        } else {
            sublayers.append(contentsOf: Array(repeating: false, count: -numberOfLayersToRemove).map { _ in
                let newLayer = CALayer()
                layer.addSublayer(newLayer)
                return newLayer
            })
        }
        let layerFrame = layer.frame
        
        var colors: LazyMapSequence<LazySequence<(PartialRangeFrom<Int>)>.Elements, NSColor>.Iterator = {
            let colors: [NSColor] = [.systemRed, .systemBlue, .systemYellow, .systemMint, .systemOrange, .systemPink, .systemTeal, .systemPurple, .systemBrown, .systemCyan, .systemIndigo]
            return (1...)
                .lazy
                .map { colors[$0 % colors.count].withAlphaComponent(0.3) }
                .makeIterator()
        }()
        _ = zip(layer.sublayers ?? [], docket.segments).reduce(TimeInterval(0)) { (startTime, segment: (CALayer, Docket.Segment)) in
            segment.0.frame = CGRect(x: (startTime / docket.totalDuration) * layerFrame.width,
                                     y: 0,
                                     width: (segment.1.duration / docket.totalDuration) * layerFrame.width,
                                     height: layerFrame.height)
            segment.0.backgroundColor = colors.next()?.cgColor
            return startTime + segment.1.duration
        }
    }
}
