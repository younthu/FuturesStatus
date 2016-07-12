//
//  Utils.swift
//  FuturesStatus
//
//  Created by Andrew(Zhiyong) Yang on 5/12/16.
//  Copyright © 2016 FoolDragon. All rights reserved.
//

import Cocoa

class Utils: NSObject {

    class func buildImage( title: String, content: String) -> NSImage{
        let titleAttr = NSMutableAttributedString(string: title);
        titleAttr.addAttribute(NSForegroundColorAttributeName, value: NSColor.redColor(), range: NSMakeRange(0, titleAttr.length))
        titleAttr.addAttribute(NSFontAttributeName, value: NSFont.systemFontOfSize(4), range: NSMakeRange(0, titleAttr.length));
        
        
        let contentAttr = NSMutableAttributedString(string: content);
        contentAttr.addAttribute(NSForegroundColorAttributeName, value: NSColor.redColor(), range: NSMakeRange(0, contentAttr.length))
        contentAttr.addAttribute(NSFontAttributeName, value: NSFont.systemFontOfSize(7), range: NSMakeRange(0, contentAttr.length));
        
        
        titleAttr.appendAttributedString(NSAttributedString(string:"\n"))
        titleAttr.appendAttributedString(contentAttr);
        
        return NSImage(attributedString:
            titleAttr
        );
    }
}
