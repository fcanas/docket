//
//  Notifications.swift
//  TextLift
//
//  Created by Fabián Cañas on 9/26/21.
//  Copyright © 2021 Fabián Cañas. All rights reserved.
//

import Cocoa
import Foundation
//import SwiftUI

func Notify(message: String, _ screen: NSScreen? = NSScreen.main, dismiss: DispatchTimeInterval = .seconds(3)) {
    guard let screen = screen else { return }
    DispatchQueue.main.async {
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: screen.frame.width, height: screen.frame.height), styleMask: [.borderless], backing: .buffered, defer: false, screen: screen)
        window.level = .screenSaver
        window.backgroundColor = .clear
       
        let host = NotificationView(message)
        
        window.contentView?.wantsLayer = true
        if
            let contentView = window.contentView,
            let layer = contentView.layer
        {
            layer.backgroundColor = .clear
            
            host.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(host)
            
            host.alphaValue = 0
            host.layer?.transform = CATransform3DMakeScale(0.8, 0.8, 0.8)
            
            host.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            host.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            host.widthAnchor.constraint(equalToConstant: 600).isActive = true
            host.heightAnchor.constraint(equalToConstant: 600).isActive = true
        }

        window.isReleasedWhenClosed = false
        window.orderFrontRegardless()
        
        NSAnimationContext.runAnimationGroup { ctx in
            ctx.duration = 0.3
            ctx.allowsImplicitAnimation = true
            host.animator().layer?.transform = CATransform3DIdentity
            host.animator().alphaValue = 1
        }

        // Dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + dismiss) {
            
            NSAnimationContext.runAnimationGroup { ctx in
                ctx.duration = 0.3
                ctx.allowsImplicitAnimation = true
                host.animator().alphaValue = 0
                if !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion {
                    host.animator().layer?.transform = CATransform3DTranslate(CATransform3DMakeScale(0.8, 0.8, 0.8), host.bounds.width/8, host.bounds.height/8, 0)
                }
            } completionHandler: {
                host.isHidden = true
                window.close()
            }
        }
    }
}
