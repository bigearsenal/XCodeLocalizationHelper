//
//  AppDelegate.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 10/17/20.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var statusBar: StatusBarController?
    var popover = NSPopover()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        
        // Set the SwiftUI's ContentView to the Popover's ContentViewController
        popover.contentSize = NSSize(width: 680, height: 300)
        popover.contentViewController = NSHostingController(rootView: contentView)
        
        // Initialising the status bar
        statusBar = StatusBarController(popover)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

