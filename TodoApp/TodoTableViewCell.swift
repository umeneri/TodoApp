//
//  TodoTableViewCell.swift
//  TodoApp
//
//  Created by umeneri on 2015/04/29.
//  Copyright (c) 2015年 umeneri. All rights reserved.
//

import Foundation
import UIKit

@objc protocol TodoTableViewCellDelegate {
    // @optionalではない
    optional func updateTodo(index: Int)
    optional func removeTodo(index: Int)
}

class TodoTableViewCell : UITableViewCell {
    // weak は delegation ように必要
    weak var delegate : TodoTableViewCellDelegate?
    
    var haveButtonsDisplayed = false
    
    // 継承する場合はなぜかこれが必要 xcodeの機能使えば自動追加される
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // override 必要
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        
        self.createView()
        
        // show swipe
        let showSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: "showDeleteButton")
        showSwipeRecognizer.direction = .Left
        self.contentView.addGestureRecognizer(showSwipeRecognizer)
        
        // hide swipe
        self.contentView.backgroundColor = UIColor.whiteColor()
        let hideSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: "hideDeleteButton")
        self.contentView.addGestureRecognizer(hideSwipeRecognizer)
    }
    
    func createView() {
        let origin = self.frame.origin
        let size = self.frame.size
        
        self.contentView.backgroundColor = UIColor.whiteColor()
        
        let updateButton = UIButton.buttonWithType(.System) as! UIButton
        updateButton.frame = CGRect(x: origin.x + size.width - 100, y: origin.y, width: 50, height: size.height)
        updateButton.backgroundColor = UIColor.lightGrayColor()
        updateButton.setTitle("編集", forState: .Normal)
        updateButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        updateButton.addTarget(self, action: "updateTodo", forControlEvents: .TouchUpInside)
        
        let removeButton = UIButton.buttonWithType(.System) as! UIButton
        //let removeButton = UIButton.buttonWithType(.System) as! UIButton
        removeButton.frame = CGRect(x: origin.x + size.width - 50, y: origin.y, width: 50, height: size.height)
        removeButton.backgroundColor = UIColor.redColor()
        removeButton.setTitle("削除", forState: .Normal)
        removeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        removeButton.addTarget(self, action: "removeTodo", forControlEvents: .TouchUpInside)
        
        self.backgroundView = UIView(frame: self.bounds)
        // ?
        self.backgroundView?.addSubview(updateButton)
        self.backgroundView?.addSubview(removeButton)
    }
    
    func updateTodo() {
        // ? はなぜつく?
        delegate?.updateTodo?(self.tag)
    }
    
    func removeTodo() {
        delegate?.removeTodo?(self.tag)
    }
    
    func showDeleteButton() {
        if !haveButtonsDisplayed {
            UIView.animateWithDuration(0.1, animations: {
                let size = self.contentView.frame.size
                let origin = self.contentView.frame.origin
                
                self.contentView.frame = CGRect(x: origin.x - 100, y: origin.y, width: size.width, height: size.height)
                }) { completed in self.haveButtonsDisplayed = true }
        }
    }
    
    func hideDeleteButton() {
        if haveButtonsDisplayed {
            UIView.animateWithDuration(0.1, animations: {
                let size = self.contentView.frame.size
                let origin = self.contentView.frame.origin
                
                self.contentView.frame = CGRect(x: origin.x + 100, y: origin.y, width: size.width, height: size.height)
                }) { completed in self.haveButtonsDisplayed = false }
        }
    }
    
}


