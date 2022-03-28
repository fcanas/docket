//
//  NotificationView.swift
//  TextLift
//
//  Created by Fabián Cañas on 9/26/21.
//  Copyright © 2021 Fabián Cañas. All rights reserved.
//

import AppKit

func NotificationView(_ message: String) -> NSView {
    let `self` = NSView(frame: .zero)
    
    self.wantsLayer = true
    self.layerContentsRedrawPolicy = .onSetNeedsDisplay
    
    // h : +104
    // w : +63
    
    var NotificationRect = CGRect(x: 0, y: 0, width: 600, height: 600)
    
    let font = NSFont.systemFont(ofSize: 42)
    let messageBox = (message as NSString).boundingRect(with: NotificationRect.size,
                                                        options: [],
                                                        attributes: [.font:font])
    NotificationRect = NSRect(origin: .zero, size: messageBox.insetBy(dx: -32, dy: -52).size)
    
    let backgroundView = NSView()
    let unclippedBackgroundView = NSView()
    
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    backgroundView.wantsLayer = true
    backgroundView.layerContentsRedrawPolicy = .onSetNeedsDisplay
    
    unclippedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    unclippedBackgroundView.wantsLayer = true
    unclippedBackgroundView.layerContentsRedrawPolicy = .onSetNeedsDisplay
    
    let backgroundLayer = backgroundView.layer!
    
    backgroundLayer.bounds = NotificationRect
    backgroundLayer.backgroundColor = NSColor.magenta.cgColor
    
    self.layer?.addSublayer(backgroundLayer)
    
    let blur = NSVisualEffectView()
    blur.material = .menu
    blur.bounds = NotificationRect
    blur.translatesAutoresizingMaskIntoConstraints = false
    blur.state = .active
    blur.layerContentsRedrawPolicy = .onSetNeedsDisplay
    
    backgroundView.addSubview(blur)
    self.addSubview(unclippedBackgroundView)
    self.addSubview(backgroundView)
    
    blur.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
    blur.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
    blur.widthAnchor.constraint(equalTo: backgroundView.widthAnchor).isActive = true
    blur.heightAnchor.constraint(equalTo: backgroundView.heightAnchor).isActive = true
    
    backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    
    backgroundView.widthAnchor.constraint(equalToConstant: NotificationRect.width).isActive = true
    backgroundView.heightAnchor.constraint(equalToConstant: NotificationRect.height).isActive = true
    
    unclippedBackgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    unclippedBackgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    
    unclippedBackgroundView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 1).isActive = true //(equalToConstant: NotificationRect.width).isActive = true
    unclippedBackgroundView.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 1).isActive = true
    
    let textView = NSTextField()
    textView.translatesAutoresizingMaskIntoConstraints = false
    
    textView.stringValue = message
    textView.textColor = NSColor.secondaryLabelColor
    textView.font = font
    textView.alignment = .center
    textView.isEditable = false
    textView.isBezeled = false
    textView.drawsBackground = false
    textView.maximumNumberOfLines = 0
    
    self.addSubview(textView)
    textView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    textView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    
    backgroundLayer.cornerRadius = 30
    backgroundLayer.cornerCurve = .continuous
    backgroundLayer.masksToBounds = true
    
    unclippedBackgroundView.layer?.cornerRadius = 30
    unclippedBackgroundView.layer?.cornerCurve = .continuous
    unclippedBackgroundView.layer?.shadowColor = NSColor.yellow.cgColor
    unclippedBackgroundView.layer?.shadowOpacity = 1
    unclippedBackgroundView.layer?.shadowRadius = 15
    unclippedBackgroundView.layer?.shadowOffset = CGSize(width: 10, height: -10)
    unclippedBackgroundView.layer?.masksToBounds = false
    
    return self
}
