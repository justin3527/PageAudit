//
//  ListItemVO.swift
//  PageAudit
//
//  Created by naver on 2017. 5. 14..
//  Copyright © 2017년 ansi. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ListItemVO : Object{
    dynamic var title:String = ""
    
   dynamic var url:String = ""
    
    dynamic var currentData:String = ""
    
   dynamic var isChanged : Bool = false
    
    override class func primaryKey () -> String {
        return "title"
    }
    
    
    
}

class SettingValue : Object{
    dynamic var id : Int = 0 
    dynamic var timeIntaval : Int = 0
    
    override class func primaryKey () -> String {
        return "id"
    }
}
