//
//  Settings.swift
//  FuturesStatus
//
//  Created by Andrew(Zhiyong) Yang on 5/10/16.
//  Copyright © 2016 FoolDragon. All rights reserved.
//

import Cocoa
import ReactiveCocoa

let kItemNameKey = "Settings.ItemName.key";

class Settings: NSObject {
    var refreshInSeconds:NSInteger = 1
    var itemName:MutableProperty< String > ;
    
    static var _sharedInstance:Settings = Settings.createSharedInstance();
    
    private class func createSharedInstance () -> Settings {
        let instance = Settings();
        
        // loading nsdefault values
        if let itemName = NSUserDefaults.standardUserDefaults().valueForKey(kItemNameKey) {
            //            NSLog("Get saved value %@", itemName);
            NSLog("Get value %@", itemName as! String);
            instance.itemName.value = itemName as! String;
        }
        
        instance.itemName.signal.observeNext { (newValue :String) in
            NSLog("Saving new value %@", newValue);
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: kItemNameKey)
            NSUserDefaults.standardUserDefaults().synchronize();
        }
        return instance;
    }
    
    class func sharedInstance() -> Settings{
        return _sharedInstance;
    }
    
    override init() {
        self.itemName = MutableProperty<String>("AG1606");
    }
}
