//
//  SettingsViewController.swift
//  FuturesStatus
//
//  Created by Andrew(Zhiyong) Yang on 5/9/16.
//  Copyright © 2016 FoolDragon. All rights reserved.
//

import Cocoa
import ReactiveCocoa
import BlocksKit

class SettingsViewController: NSViewController,NSTextFieldDelegate {

    @IBOutlet weak var apiList: NSComboBox!
    let settings:Settings = Settings.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.refreshIntervalField.rac_textSignal().toSignalProducer().map({ text in
            text as! String
        }).startWithNext({ (string:String) in
            if(string.isEmpty){
                return;
            }
            self.settings.refreshInSeconds = NSInteger(string)!;
        })
        
        self.quitButton.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
//            NSApplication.terminate(NSApplication.)
            NSApp.terminate(self)
            return RACSignal.empty()
        })
        
        self.itemNameLabel.stringValue = Settings.sharedInstance().itemName.value;
        self.itemNameLabel.rac_textSignal().toSignalProducer()
            .map({text in text as! String})
            .startWithNext { (string:String) in
                if(string.isEmpty){
                    return;
                }
                self.settings.itemName.value = string;
        }
    }
    
    
    
    @IBOutlet weak var itemNameLabel: NSTextField!
    @IBOutlet weak var quitButton: NSButton!
    @IBOutlet weak var refreshIntervalField: NSTextField!
}
