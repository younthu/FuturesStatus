//
//  InfoSource.swift
//  FuturesStatus
//
//  Created by Andrew(Zhiyong) Yang on 5/12/16.
//  Copyright © 2016 FoolDragon. All rights reserved.
//

import Cocoa
import ReactiveCocoa

protocol InfoSourceProtocol {
    var refreshInterval: UInt {get set};
    var newItemSignal : Signal<InfoItemProtocol, NSError> {get};
    
    func start();
    func stop();
    
}
