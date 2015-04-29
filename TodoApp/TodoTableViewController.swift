//
//  TodoTableViewController.swift
//  TodoApp
//
//  Created by umeneri on 2015/04/29.
//  Copyright (c) 2015年 umeneri. All rights reserved.
//

import Foundation
import UIKit

class TodoTableViewController : UIViewController {
    var todoDataManager = TodoDataManager.sharedInstance
    var tableView : UITableView?
    
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
        self.alertController = UIAlertController(title: "Todo追加🐱", message: nil, preferredStyle: .Alert)
        self.alertController!.addTextFieldWithConfigurationHandler({ textField in
            textField.delegate = self
        })
        
        // !で確定させないと引数に渡せない
        self.presentViewController(self.alertController!, animated: true, completion: nil)
    }
}

extension TodoTableViewController : UITextFieldDelegate {
    
    // textField への文字入力終了後の処理
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        let todo = TODO(title: textField.text)
        if self.todoDataManager.create(todo) {
            println("oh no")
            textField.text = nil
            self.tableView!.reloadData()
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
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text = "todo"
        
        return cell
    }
    
}

