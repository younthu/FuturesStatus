//
//  SinaFuturesSource.swift
//  FuturesStatus
//
//  Created by Andrew(Zhiyong) Yang on 5/12/16.
//  Copyright © 2016 FoolDragon. All rights reserved.
//

import Cocoa
import Alamofire
import ReactiveCocoa

class SinaFuturesSource: NSObject , InfoSourceProtocol{
    
    
    var refreshInterval : UInt = 1;
    let (newItemSignal, observer) = Signal<InfoItemProtocol, NSError>.pipe()
    
    var itemId = "AG1606";
    
    override init() {
        
    }
    
    func start() {
        self.startNetworkRequest(2);
    }
    
    func stop() {
        
    }
    
    func startNetworkRequest(intervalSecs:UInt64) -> Void {
        NSLog("refreshing with interval: %d...", intervalSecs)
        // use sina api, ref: http://blog.sina.com.cn/s/blog_7ed3ed3d0101gphj.html
        Alamofire.request(.GET, "http://hq.sinajs.cn/list=" + itemId, parameters: nil)
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
                    
                    let values = myStringToBeMatched?.substringWithRange(match).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\"")).componentsSeparatedByString(",")
                    if  values?.count < 9 {
                        return;
                    }
                    
                    
                    let title = String(values![0]);
                    let value = String(values![8]);
                    
                    let item = TextInfo();
                    item.title = title;
                    item.text = value;
                    NSLog("%@,%@", title, value);
                    self.observer.sendNext(item);
                }
                
        }
        
    }
}

