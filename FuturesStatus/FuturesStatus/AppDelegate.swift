//
//  AppDelegate.swift
//  FuturesStatus
//
//  Created by Andrew(Zhiyong) Yang on 5/7/16.
//  Copyright © 2016 FoolDragon. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
//        let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
        
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            button.action = Selector("printQuote:")
        }
        
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Print Quote", action: Selector("printQuote:"), keyEquivalent: "P"))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Quit Quotes", action: Selector("terminate:"), keyEquivalent: "q"))
        
        statusItem.menu = menu
        
    }
    
    func printQuote(sender: AnyObject) {
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"
        
        print("\(quoteText) — \(quoteAuthor)")
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

