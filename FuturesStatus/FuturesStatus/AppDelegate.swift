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
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
//        let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
        
        if let button = statusItem.button {
//            button.image = NSImage(named: "StatusBarButtonImage")
            button.title = "AG1606:3753";
            button.action = Selector("printQuote:")
            button
        }
        
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Print Quote", action: Selector("printQuote:"), keyEquivalent: "P"))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Quit Quotes", action: Selector("terminate:"), keyEquivalent: "q"))
        
        statusItem.menu = menu
        
        startNetworkRequest(10);
    }
    
    func renderInfo(str:NSAttributedString){
        
    }
    
    func startNetworkRequest(intervalSecs:UInt64) -> Void {
        // use sina api, ref: http://blog.sina.com.cn/s/blog_7ed3ed3d0101gphj.html
        Alamofire.request(.GET, "http://hq.sinajs.cn/list=AG1606", parameters: nil)
            .responseString { response in
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(intervalSecs * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                    self.startNetworkRequest(intervalSecs);
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

