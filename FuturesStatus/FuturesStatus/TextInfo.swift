//
//  TextInfo.swift
//  FuturesStatus
//
//  Created by Andrew(Zhiyong) Yang on 5/12/16.
//  Copyright © 2016 FoolDragon. All rights reserved.
//

import Cocoa

class TextInfo: NSObject {
    
    var text: String = "";
    var title: String = "";
}

// MARK: - InfoItemProtocol
extension TextInfo: InfoItemProtocol{
    
    func info() -> NSImage {
        
        return Utils.buildImage(title, content: text);
    }
}
