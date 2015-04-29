//
//  TodoTableViewCell.swift
//  TodoApp
//
//  Created by umeneri on 2015/04/29.
//  Copyright (c) 2015年 umeneri. All rights reserved.
//

import Foundation
import UIKit

class TodoTableViewCell : UITableViewCell {
    var haveButtonsDisplayed = false
    
    // override 必要
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        
        // show swipe
        let showSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: "showDeleteButton")
        showSwipeRecognizer.direction = .Left
        self.contentView.addGestureRecognizer(showSwipeRecognizer)
        
        // hide swipe
        self.contentView.backgroundColor = UIColor.whiteColor()
        let hideSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: "hideDeleteButton")
        self.contentView.addGestureRecognizer(hideSwipeRecognizer)
    }

    // 継承する場合はなぜかこれが必要 xcodeの機能使えば自動追加される
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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


