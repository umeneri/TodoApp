//
//  TodoTableViewController.swift
//  TodoApp
//
//  Created by umeneri on 2015/04/29.
//  Copyright (c) 2015年 umeneri. All rights reserved.
//

import Foundation
import UIKit

enum TodoAlertViewType {
    case Create, Update(Int), Remove(Int)
}

class TodoTableViewController : UIViewController {
    var todoDataManager = TodoDataManager.sharedInstance
    var tableView : UITableView?
    var alertType : TodoAlertViewType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 64))
        header.image = UIImage(named: "header")
        // header をタッチ可能領域にする
        header.userInteractionEnabled = true
        
        let title = UILabel(frame: CGRect(x: 10, y: 20, width: 310, height: 44))
        title.text = "Todoリスト 🐶"
        header.addSubview(title)
        
        // as!での型変換がないとだめ
        let button = UIButton.buttonWithType(.System) as! UIButton
        button.frame = CGRect(x: 320 - 100, y: 20, width: 100, height: 44)
        button.setTitle("(ΦωΦ)", forState: .Normal)
        button.addTarget(self, action:"showCreateView", forControlEvents: .TouchUpInside)
        header.addSubview(button)
        
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        self.tableView = UITableView(frame: CGRect(x: 0, y: 60, width: 320, height: screenHeight - 60))
        //  ?
        self.tableView!.dataSource = self
        self.view.addSubview(self.tableView!)
        self.view.addSubview(header)
    }
    
    // todo 追加時のダイアログ
    var alertController : UIAlertController?
    
    // todo 追加時の View
    func showCreateView() {
        self.alertType = TodoAlertViewType.Create
        self.alertController = UIAlertController(title: "Todo追加🐱", message: nil, preferredStyle: .Alert)
        self.alertController!.addTextFieldWithConfigurationHandler({ textField in
            textField.delegate = self
        })
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        self.alertController?.addAction(okAction)
        
        // !で確定させないと引数に渡せない
        self.presentViewController(self.alertController!, animated: true, completion: nil)
    }
}

extension TodoTableViewController : UITextFieldDelegate {
    
    // textField への文字入力終了後の処理
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if let type = self.alertType {
            println(type)
            
            switch type {
            case .Create:
                let todo = TODO(title: textField.text)
                if self.todoDataManager.create(todo) {
                    textField.text = nil
                    self.tableView!.reloadData()
                }
            case let .Update(index):
                let todo = TODO(title: textField.text)
                if self.todoDataManager.update(todo, at:index) {
                    textField.text = nil
                    self.tableView!.reloadData()
                }
            case let .Remove(index):
                break
            }
        }
        
        // alert を閉じる
        self.alertController!.dismissViewControllerAnimated(false, completion: nil)
        return true
    }
}

extension TodoTableViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoDataManager.size
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cell = TodoTableViewCell(style: .Default, reuseIdentifier: nil)
        cell.delegate = self
        cell.textLabel?.text = self.todoDataManager[indexPath.row].title
        cell.tag = indexPath.row
        
        return cell
    }
    
}

extension TodoTableViewController : TodoTableViewCellDelegate {
    func updateTodo(index: Int) {
        self.alertType = TodoAlertViewType.Update(index)
        
        self.alertController = UIAlertController(title: "編集😺", message: nil, preferredStyle: .Alert)
        self.alertController!.addTextFieldWithConfigurationHandler({ textField in
            textField.text = self.todoDataManager[index].title
            textField.delegate = self
        })
        
        // !で確定させないと引数に渡せない
        self.presentViewController(self.alertController!, animated: true, completion: nil)
    }
    func removeTodo(index: Int) {
        self.alertType = TodoAlertViewType.Update(index)
        
        self.alertController = UIAlertController(title: "削除😹", message: nil, preferredStyle: .Alert)
        self.alertController!.addAction(UIAlertAction(title: "Delete", style: .Destructive) { action in
            self.todoDataManager.remove(index)
            self.tableView!.reloadData()
        })
        
        self.alertController!.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
     
        // !で確定させないと引数に渡せない
        self.presentViewController(self.alertController!, animated: true, completion: nil)
    }
}

