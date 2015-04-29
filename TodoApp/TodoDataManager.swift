//
//  TodoDataManager.swift
//  TodoApp
//
//  Created by umeneri on 2015/04/29.
//  Copyright (c) 2015年 umeneri. All rights reserved.
//

import Foundation

struct TODO {
    var title : String
}

// finalはシングルトンクラスとして必要
final class TodoDataManager {
    let STORE_KEY = "TodoDataManager.store_key"
    
    // TodoDataManagerを単一インスタンスに
    // ここはかなり詰まった。 さらにバージョンによって書き方が変わる
    //let sharedInstance = TodoDataManager()
    class var sharedInstance : TodoDataManager {
        struct Static {
            static let instance : TodoDataManager = TodoDataManager()
        }
        return Static.instance
    }
//
//    class var sharedInstance : TodoDataManager {
//        struct Static {
//            static var instance : TodoDataManager?
//        }
//        
//        if !Static.instance {
//            Static.instance = TodoDataManager()
//        }
//        return Static.instance!
//    }
//    
    var todoList : [TODO]
    var size : Int {
        get {
            return todoList.count
        }
        set {
            println(newValue)
        }
    }
    

    // private はシングルトンの場合は必須
    private init() {
        /* ストレージからデータ読み出し*/
        let defaults = NSUserDefaults.standardUserDefaults()
        if let data  = defaults.objectForKey(self.STORE_KEY) as? [String] {
            self.todoList = data.map { title in
                TODO(title: title)
            }
        } else {
            self.todoList = []
        }
    }

    func save() {
        /* ストレージへデータ書き出し*/
        let defaults = NSUserDefaults.standardUserDefaults()
        let data = self.todoList.map { todo in
            todo.title
        }
        defaults.setObject(data, forKey: self.STORE_KEY)
        defaults.synchronize()
    }
    
    class func validate(todo: TODO!) -> Bool {
        // sample にミスが
        //return todo != nil && todo.title != ""
        return todo.title != ""
    }
    
    func create(todo: TODO!) -> Bool {
        if TodoDataManager.validate(todo) {
            self.todoList.append(todo)
            self.save()
            return true
        }
        
        println("not valid")
        
        return false
    }

    func update(todo: TODO!, index: Int) -> Bool {
        if index >= self.todoList.count {
            return false
        }

    
        if TodoDataManager.validate(todo) {
            todoList[index] = todo
            self.save()
            return true
        }
                println("not valid")
        return false
    }
    
    func remove(index: Int) -> Bool {
        if index >= self.todoList.count {
            return false
        }
        self.todoList.removeAtIndex(index)
        self.save()
        
        return true
    }
    
    func insert(todo: TODO!,  index: Int) -> Bool {
        if index >= self.todoList.count {
            return false
        }

        self.todoList.insert(todo, atIndex: index)
        self.save()
        
        return true
    }
    
    subscript(index: Int) -> TODO {
        return todoList[index]
    }
    
}