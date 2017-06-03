//
//  Common.swift
//  PageAudit
//
//  Created by naver on 2017. 5. 19..
//  Copyright © 2017년 ansi. All rights reserved.
//

import Foundation
import RealmSwift

class CommonData{

    var realm = try! Realm()
    lazy var itemVO = [ListItemVO]()
    var commonFunc : CommonFunc!
    var settingValue : SettingValue!
    
    init(){
        commonFunc = CommonFunc()
        let auditList = realm.objects(ListItemVO.self)
        for i in 0..<auditList.count{
            
            let ivo = ListItemVO()
            
            ivo.title = auditList[i].title
            ivo.url = auditList[i].url
            ivo.isChanged = auditList[i].isChanged
            
            itemVO.append(ivo)
        }
        
        let setList = realm.objects(SettingValue.self).filter("id = %d",1)
        if(setList.isEmpty){
            let setValue  = SettingValue()
            setValue.timeIntaval = 5
            setValue.id = 1
            
            try! realm.write{
                realm.add(setValue)
            }
        }
        else{
            settingValue = setList[0]
        }

    
    }
    
    //<==================realm==================>
    
    
    func dataDelete(_ index:Int){
        
        try! realm.write {
           let item =  realm.objects(ListItemVO.self).filter("title = %s",itemVO[index].title)
            realm.delete(item)
        }
        itemVO.remove(at: index)
    }
    
//    func dataUpdate(_ index:Int, _ value:Bool)
//    {
//        
//        
//        try! realm.write {
//            self.itemVO[index].isChanged = value
//            realm.add(itemVO[index], update: true)
//        }
//        
//    }
    
    func dataUpdate(_ index:Int)
    {
        
        try! realm.write{
            realm.create(ListItemVO.self, value: ["title": itemVO[index].title, "url": itemVO[index].url, "currentData": itemVO[index].currentData, "isChanged": itemVO[index].isChanged], update:true)
        }
//        print("456")
//        try! realm.write {
//           if att == 1{
//                self.itemVO[index].url = text
//            }
//            else{
//                print("456")
//                self.itemVO[index].currentData = text
//            }
//            realm.add(itemVO[index], update: true)
//        }
//        
//        print("456")
        
    }
    
    func dataAdd(_ title:String, _ url:String)
    {
        
        try! realm.write{
            realm.create(ListItemVO.self, value: ["title": title, "url": url, "currentData": commonFunc.getPage(url), "isChanged": false], update:true)
        }
        
        let ivo = ListItemVO()
        ivo.title = title
        ivo.url = url
        ivo.currentData = commonFunc.getPage(url)
        ivo.isChanged = false
        
        itemVO.append(ivo)
        
    }
    
    func isExist(_ title:String) -> Bool
    {
        let result = realm.objects(ListItemVO.self).filter("title = %@", title)
        
        if(result.count == 0){
            return false;
        }
        else{
            return true;
        }
    }
    
    func getIntaval() -> Int{
        return settingValue.timeIntaval
    }
    
    func setIntaval(_ time:Int){
        
        try! realm.write{
            realm.create(SettingValue.self, value: ["id":1,"timeIntaval":time], update:true)
        }
    }
    
    func getTitle(_ index:Int) -> String{
      return  self.itemVO[index].title
    }
    
    func getUrl(_ index:Int) -> String{
        return  self.itemVO[index].url
    }
    
    func getItemIndex(_ title:String) -> Int{
        
        if(self.itemVO.count>0){
        
            for i in 0..<self.itemVO.count{
                
                print(i)
                if(itemVO[i].title == title){
                    return i
                }
            }
            
        }
        
        return -1
    }
    
    

}
