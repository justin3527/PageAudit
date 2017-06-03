//
//  ViewController.swift
//  PageAudit
//
//  Created by naver on 2017. 5. 14..
//  Copyright © 2017년 ansi. All rights reserved.
//

import UIKit
import UserNotifications
class ViewController: UIViewController {

    var timer = Timer();
    var value:Int = 0;
    
    
    override func viewDidLoad() {
        timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.refreshTheLocation), userInfo: nil, repeats: true)
        
        
        
        super.viewDidLoad()
        
        
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshTheLocation(){
        
        
        value += 1;
        print(value)
        
        
    }


}

