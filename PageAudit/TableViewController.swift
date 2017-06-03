//
//  TableViewController.swift
//  PageAudit
//
//  Created by naver on 2017. 5. 14..
//  Copyright © 2017년 ansi. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SwipeCellKit


class TableViewController : UITableViewController, UITextFieldDelegate{


   var timer = Timer(); 
    var commonData :CommonData!
    var commonFunc : CommonFunc!
    @IBOutlet var timeText:UITextField!
    
    
    override func viewDidLoad() {
        self.timeText.delegate = self
        self.start()
        
        super.viewDidLoad()
    }
    
    func start(){
        commonData = CommonData()
        commonFunc = CommonFunc(commonData: commonData)
        
        commonFunc.auditThePage()
        timeText.text =  String(commonData.getIntaval());
        commonFunc.startRepeat(commonData.getIntaval())
    }
    

    //테이블 수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return commonData.itemVO.count
    }
    
    //각셀 설정
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = commonData.itemVO[indexPath.row]
       // self.tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "ListCell")
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! SwipeTableViewCell
        let cell = SwipeTableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "ListCell")
        cell.textLabel?.text = row.title
        cell.detailTextLabel?.text = row.url
        
        if(row.isChanged == true)
        {
            cell.backgroundColor = UIColor.red
        }
        else{
            cell.backgroundColor = UIColor.white
        }
        
        
        cell.delegate = self
        
      
    
        
        return cell
    }
    
    
    //셀 선택 시
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //클릭 후선 택 해제
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        commonData.itemVO[indexPath.row].isChanged = false
        commonData.dataUpdate(indexPath.row)
        
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        //url open
        let url = NSURL(string:commonData.itemVO[indexPath.row].url)!
        UIApplication.shared.openURL(url as URL)
        
    }
    
//    //셀 삭제
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if editingStyle == .delete{
//            commonData.dataDelete(indexPath.row)
//            self.tableView.reloadData()
//            
//        }
//        else if editingStyle == .insert{
//            print("editv")
//        }
//    }
    
   
    
    
    
    @IBAction func addTheAudit(){
        
       addAlert("", "", false)
        
    }
    
    
    


}

extension TableViewController:SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left {
            
            let editAction = SwipeAction(style: SwipeActionStyle.default, title: "Edit") { action, indexPath in
                // handle action by updating model with deletion
                self.addAlert(self.commonData.getTitle(indexPath.row), self.commonData.getUrl(indexPath.row),true)
                
            }
            return [editAction]
        }
        else {
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                self.commonData.dataDelete(indexPath.row)
                self.tableView.reloadData()
                
            }
            deleteAction.image = UIImage(named: "delete")
            return [deleteAction]
        }
        
        
        
        //  guard orientation == .right else { return nil }
        
        
            
//            self.tableView.beginUpdates()
//            self.tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
//            action.fulfill(with: .delete)
//            self.tableView.endUpdates()
        
        
        // customize the action appearance
        
        
    }
    //스와이프 옵션
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .border
        return options
    }
}

