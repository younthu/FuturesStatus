//
//  AppDelegate.swift
//  FuturesStatus
//
//  Created by Andrew(Zhiyong) Yang on 5/7/16.
//  Copyright © 2016 FoolDragon. All rights reserved.
//

import Cocoa
import Alamofire
import ReactiveCocoa
import BlocksKit

let UP_CHAR="↓"
let DOWN_CHAR="↑"

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let popover = NSPopover()
    
    let sinaSource = SinaFuturesSource();
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
//        let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
        
        if let button = statusItem.button {
//            button.image = NSImage(named: "StatusBarButtonImage")
            button.title = "Waiting...";
            button.action = #selector(AppDelegate.showSettings(_:))
            
        }
        
        sinaSource.newItemSignal.observeNext { (item: InfoItemProtocol) in
            if let button = self.statusItem.button {
                //            button.image = NSImage(named: "StatusBarButtonImage")
                button.image = item.info();
                
            }
        }
        
        sinaSource.start();
        
        Settings.sharedInstance().itemName.signal.observeNext { (value:String) in
            self.sinaSource.itemId = value;
        }
        
        popover.contentViewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    func showSettings(sender:AnyObject?){
        togglePopover(sender);
    }
    
    func renderInfo(str:NSAttributedString){
        
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

