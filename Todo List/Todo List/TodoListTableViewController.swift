//
//  ViewController.swift
//  Todo List
//
//  Created by Lu Jingjing on 15/12/12.
//  Copyright © 2015年 Schuming. All rights reserved.
//

// v2015121501

import UIKit

class TodoListTableViewController: UITableViewController ,HandleItemInTableViewDelegate{
    
    var checklist : Checklist!
    var indexForItemToEdit = 0
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let handleItemController = navigationController.topViewController as! HandleItemTableViewController
        handleItemController.delegate = self
        
        if segue.identifier == "AddItemSegue" {
            handleItemController.title = "Add Item"
        } else if segue.identifier == "EditItemSegue" {
            handleItemController.title = "Edit Item"
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                handleItemController.itemToHandle = todoItems[indexPath.row]
                indexForItemToEdit = indexPath.row
            }
        }
    }
    
    var todoItems = [TodoItem]()
    required init?(coder aDecoder: NSCoder) {
        
        
//        let item0 = TodoItem(todoItemCheckStatus: false,todoItemName: "Get up")
//        todoItems.append(item0)
//        
//        let item1 = TodoItem(todoItemCheckStatus: false,todoItemName: "Go to work")
//        todoItems.append(item1)
//        
//        let item2 = TodoItem(todoItemCheckStatus: false,todoItemName: "Have lunch")
//        todoItems.append(item2)
//        
//        let item3 = TodoItem(todoItemCheckStatus: false,todoItemName: "Have a nap")
//        todoItems.append(item3)
//        
//        let item4 = TodoItem(todoItemCheckStatus: false,todoItemName: "Go home")
//        todoItems.append(item4)
        
        todoItems = [TodoItem]()
        
        
        
        super.init(coder: aDecoder)

        loadTodoItems()
        //        print("Doc folder is \(docmentsDirectory())")
        //                print("Data file path is \(dataFilePath())")
    }
    func loadTodoItems(){
        let path = dataFilePath()
        
        if NSFileManager.defaultManager().fileExistsAtPath(path){
            if let data = NSData(contentsOfFile: path){
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                todoItems = unarchiver.decodeObjectForKey("todoItems") as! [TodoItem]
                
                unarchiver.finishDecoding()
            }
        }
    
    }
    
    
    func HandleItemViewController(controller: HandleItemTableViewController, didFinishEdittingItem   item: TodoItem) {
        
        
        // update model
        todoItems[indexForItemToEdit] = item
        
        //update view
        let indexPath = NSIndexPath(forRow: indexForItemToEdit, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.textLabel?.text = item._todoItemName
        
        
        dismissViewControllerAnimated(true, completion: nil)
        
        saveItems()
        
    }
    
    func HandleItemViewController(controller: HandleItemTableViewController, didFinishAddingItem   item: TodoItem) {
        
        let count = todoItems.count
        
        // update model
        todoItems.append(item)
        
        //update view
        let indexPath = NSIndexPath(forRow: count, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
        
        saveItems()
    }
    
    
    
    func HandleItemViewControllerDidCancle(controller: HandleItemTableViewController) {
        dismissViewControllerAnimated(true, completion: nil )
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = checklist.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Item")
        let cell = tableView.dequeueReusableCellWithIdentifier("Item", forIndexPath: indexPath)
        cell.textLabel?.text = todoItems[indexPath.row]._todoItemName
        
        let label = cell.viewWithTag(1000) as! UILabel
        if todoItems[indexPath.row]._todoItemcheckStatus {
            label.text = "√"
        } else {
            label.text = ""
        }
        
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let label = cell!.viewWithTag(1000) as! UILabel
        if label.text == "√" {
            label.text = ""
        } else {
            label.text = "√"
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        saveItems()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //model
        todoItems.removeAtIndex(indexPath.row)
        
        //view
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        saveItems()
    }
    
    func docmentsDirectory() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        let directory = docmentsDirectory() as NSString
        return directory.stringByAppendingPathComponent("Checklists.plist")
    }
    
    func saveItems() {
        /*
        NSMutableData (and its superclass NSData) provide data objects, object-oriented wrappers for byte buffers. Data objects let simple allocated buffers (that is, data with no embedded pointers) take on the behavior of Foundation objects. They are typically used for data storage and are also useful in Distributed Objects applications, where data contained in data objects can be copied or moved between applications. NSData creates static data objects, and NSMutableData creates dynamic data objects. You can easily convert one type of data object to the other with the initializer that takes an NSData object or an NSMutableData object as an argument.
        
        */
        
        let data = NSMutableData()
        
        
        
        /*
        NSKeyedArchiver, a concrete subclass of NSCoder, provides a way to encode objects (and scalar values) into an architecture-independent format that can be stored in a file. When you archive a set of objects, the class information and instance variables for each object are written to the archive. NSKeyedArchiver’s companion class, NSKeyedUnarchiver, decodes the data in an archive and creates a set of objects equivalent to the original set.
        Overview
        A keyed archive differs from a non-keyed archive in that all the objects and values encoded into the archive are given names, or keys. When decoding a non-keyed archive, values have to be decoded in the same order in which they were encoded. When decoding a keyed archive, because values are requested by name, values can be decoded out of sequence or not at all. Keyed archives, therefore, provide better support for forward and backward compatibility.
        The keys given to encoded values must be unique only within the scope of the current object being encoded. A keyed archive is hierarchical, so the keys used by object A to encode its instance variables do not conflict with the keys used by object B, even if A and B are instances of the same class. Within a single object, however, the keys used by a subclass can conflict with keys used in its superclasses.
        An NSArchiver object can write the archive data to a file or to a mutable-data object (an instance of NSMutableData) that you provide.
        */
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        
        
        
        /*
         Here used to drop a crash message of "unrecognized selector" which means you forget to implement a certain method.In this case,the missing method appears to be encodeWithCoder() on the TodoItem object-that is what the crash message says.
        Here is what happened:You asked NSKeyedArchiver to encode the array of items,so it not only
        has to encode the array itself but also each Todoitem object inside that array.
        
        NSKeyArchiver knows how to encode an Array object but it does not know anything about ChecklistItem.So you have to help it out a bit.
        */
        archiver.encodeObject(todoItems, forKey: "todoItems")
        
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
}

