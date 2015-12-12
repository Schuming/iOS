//
//  ViewController.swift
//  Todo List
//
//  Created by Lu Jingjing on 15/12/12.
//  Copyright © 2015年 Schuming. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController ,HandleItemInTableViewDelegate{
    
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
        super.init(coder: aDecoder)
        
        let item0 = TodoItem(todoItemCheckStatus: false,todoItemName: "Get up")
        todoItems.append(item0)
        
        let item1 = TodoItem(todoItemCheckStatus: false,todoItemName: "Go to work")
        todoItems.append(item1)
        
        let item2 = TodoItem(todoItemCheckStatus: false,todoItemName: "Have lunch")
        todoItems.append(item2)
        
        let item3 = TodoItem(todoItemCheckStatus: false,todoItemName: "Have a nap")
        todoItems.append(item3)
        
        let item4 = TodoItem(todoItemCheckStatus: false,todoItemName: "Go home")
        todoItems.append(item4)
        
    }
    
    func HandleItemViewController(controller: HandleItemTableViewController, didFinishEdittingItem   item: TodoItem) {
        
        
        // update model
        todoItems[indexForItemToEdit] = item
        
        //update view
        let indexPath = NSIndexPath(forRow: indexForItemToEdit, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.textLabel?.text = item._todoItemName
        
        
        dismissViewControllerAnimated(true, completion: nil)
        
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
        
    }
    
    
    
    func HandleItemViewControllerDidCancle(controller: HandleItemTableViewController) {
        dismissViewControllerAnimated(true, completion: nil )
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //model
        todoItems.removeAtIndex(indexPath.row)
        
        //view
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
    }
    
    
    
}

