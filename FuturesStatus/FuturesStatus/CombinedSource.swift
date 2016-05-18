//
//  CombinedSource.swift
//  FuturesStatus
//
//  Created by Andrew(Zhiyong) Yang on 5/13/16.
//  Copyright © 2016 FoolDragon. All rights reserved.
//

import Cocoa
import ReactiveCocoa

class CombinedSource: NSObject , InfoSourceProtocol {
    
    var refreshInterval : UInt = 1;
    let (newItemSignal, observer) = Signal<InfoItemProtocol, NSError>.pipe()
    
    private let sina = SinaFuturesSource();
    
    override init() {
        
    }
    
    func start() {
    }
    
    func stop() {
        
    }
    
    
}
