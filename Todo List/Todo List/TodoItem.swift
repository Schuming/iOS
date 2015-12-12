//
//  TodoItem.swift
//  Todo List
//
//  Created by Lu Jingjing on 15/12/12.
//  Copyright © 2015年 Schuming. All rights reserved.
//

import Foundation

class TodoItem {
    var _todoItemcheckStatus = false
    var _todoItemName = ""
    
    init(todoItemCheckStatus : Bool , todoItemName : String){
        self._todoItemcheckStatus = todoItemCheckStatus
        self._todoItemName = todoItemName
    }
}
