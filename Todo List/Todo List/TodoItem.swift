//
//  TodoItem.swift
//  Todo List
//
//  Created by Lu Jingjing on 15/12/12.
 //

import Foundation

class TodoItem : NSObject,NSCoding{
    
    var _todoItemcheckStatus : Bool
    var _todoItemName : String
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(_todoItemName, forKey: "_todoItemName")
        aCoder.encodeBool(_todoItemcheckStatus, forKey: "_todoItemcheckStatus")
    }
    
    required init?(coder aDecoder: NSCoder) {
        _todoItemName = aDecoder.decodeObjectForKey("_todoItemName") as! String
        _todoItemcheckStatus = aDecoder.decodeBoolForKey("_todoItemcheckStatus") 
        super.init()
    }
    
    override init() {
                self._todoItemcheckStatus = false
                self._todoItemName = ""
        super.init()
    }
    
}
