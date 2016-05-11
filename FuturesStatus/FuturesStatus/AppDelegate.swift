//
//  AppDelegate.swift
//  FuturesStatus
//
//  Created by Andrew(Zhiyong) Yang on 5/7/16.
//  Copyright © 2016 FoolDragon. All rights reserved.
//

import Cocoa
import Alamofire

let UP_CHAR="↓"
let DOWN_CHAR="↑"

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let popover = NSPopover()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
//        let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
        
        if let button = statusItem.button {
//            button.image = NSImage(named: "StatusBarButtonImage")
            button.title = "Waiting...";
            button.action = Selector("showSettings:")
            
        }
        
        popover.contentViewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        
//        let menu = NSMenu()
//        
//        menu.addItem(NSMenuItem(title: "Print Quote", action: Selector("printQuote:"), keyEquivalent: "P"))
//        menu.addItem(NSMenuItem.separatorItem())
//        menu.addItem(NSMenuItem(title: "Quit Quotes", action: Selector("terminate:"), keyEquivalent: "q"))
//        
//        statusItem.menu = menu
        
        startNetworkRequest(UInt64(Settings.sharedInstance().refreshInSeconds));
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
    
    func startNetworkRequest(intervalSecs:UInt64) -> Void {
        NSLog("refreshing with interval: %d...", intervalSecs)
        // use sina api, ref: http://blog.sina.com.cn/s/blog_7ed3ed3d0101gphj.html
        Alamofire.request(.GET, "http://hq.sinajs.cn/list=AG1606", parameters: nil)
            .responseString { response in
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(intervalSecs * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                    self.startNetworkRequest(UInt64(Settings.sharedInstance().refreshInSeconds));
                })
                
                if  response.result.isFailure {
                    return;
                }
                
                
//                println(string)
                let myStringToBeMatched = response.result.value
                let myRegex = "\".*\""
                if let match = myStringToBeMatched!.rangeOfString(myRegex, options: .RegularExpressionSearch){
                    
                    print("\(myStringToBeMatched) is matching!")
                    
                    let values = myStringToBeMatched?.substringWithRange(match).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\"")).componentsSeparatedByString(",")
                    if  values?.count < 9 {
                        return;
                    }
                    
                    let str = NSString(format: "%@\n%@", values![0], values![8]) as String;
//                    self.statusItem.button?.title =  str //values![0] + (values![8])
                    
                    if let button = self.statusItem.button {
                        //            button.image = NSImage(named: "StatusBarButtonImage")
//                        button.title = str;
                        let attrStr = NSMutableAttributedString(string: str);
                        attrStr.addAttribute(NSForegroundColorAttributeName, value: NSColor.redColor(), range: NSMakeRange(0, attrStr.length))
                        attrStr.addAttribute(NSFontAttributeName, value: NSFont.systemFontOfSize(7), range: NSMakeRange(0, attrStr.length));
                        button.image = NSImage(attributedString: attrStr);
                    }
                }
                
            }
        
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

