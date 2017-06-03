//
//  CommonFunc.swift
//  PageAudit
//
//  Created by naver on 2017. 5. 19..
//  Copyright © 2017년 ansi. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class CommonFunc {
    
    var timer=Timer()
    
    var commonData:CommonData!
    
    init() {
        
    }
    init(commonData:CommonData!){
        self.commonData = commonData
    }
    
    func getPage(_ url:String) -> String{
        if let url = NSURL(string: url) {
            do {
                let contents = try NSString(contentsOf: url as URL, usedEncoding: nil)
                return contents as String
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
            
        }
        return "";
    }
    
   @objc func auditThePage(){
        var contents:String = ""
        var count:Int = 0
        
        for i in 0..<commonData.itemVO.count{
            let newData = getPage(commonData.itemVO[i].url)
            if commonData.itemVO[i].currentData == newData{
                print("same")
            }
            else{
                
                commonData.itemVO[i].isChanged = true
                commonData.dataUpdate(i)
                
                commonData.itemVO[i].currentData = newData
                commonData.dataUpdate(i)
                
                count += 1
                
                 if (i+1) == commonData.itemVO.count{
                    contents = (commonData.itemVO[i].title)
                }
                else if count == 1{
                    contents = (commonData.itemVO[i].title+"\\")
                }
                else{
                    contents += (commonData.itemVO[i].title+"\\")
                }
                
                print("===========different=============")
                
            }
            
        }
    print(contents);
    
        if(count != 0){
            self.notiButton(contents, count)
        }
    
    }
    
    func notiButton(_ contents:String, _ size:Int)
    {
        
        
        
        if #available(iOS 10.0, *){
            
            let content = UNMutableNotificationContent()
            content.title = "Changed Page"
            content.body = contents
            content.sound = UNNotificationSound.default()
            content.badge = size as NSNumber;
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,repeats: false)
            
            let request = UNNotificationRequest(identifier: "warnning",
                                                content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if error != nil {
                    // Something went wrong
                }
            })
            
        }
        else{
            let noti = UILocalNotification()
            noti.fireDate = Date(timeIntervalSinceNow: 1)
            noti.timeZone = TimeZone.autoupdatingCurrent
            noti.alertBody = "Changed Page"
            noti.alertAction = contents
            noti.applicationIconBadgeNumber = size
            noti.soundName = UILocalNotificationDefaultSoundName
            
            //UIApplication.shared.scheduleLocalNotification(noti) // 시간 스케줄 설정 후 노티 실행
            UIApplication.shared.presentLocalNotificationNow(noti) // 바로 노티 실행
        }
        
    
    }
    
    func startRepeat(_ time:Int){
        
        timer=Timer.scheduledTimer(timeInterval: TimeInterval(time*60), target: self, selector: #selector(self.auditThePage), userInfo: nil, repeats: true)
    }
    


    
    
}
