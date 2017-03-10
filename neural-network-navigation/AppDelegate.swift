//
//  AppDelegate.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 2/22/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if #available(OSX 10.12.2, *) {
            NSApplication.shared().isAutomaticCustomizeTouchBarMenuItemEnabled = true
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

