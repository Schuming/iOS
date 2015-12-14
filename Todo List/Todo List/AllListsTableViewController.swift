//
//  AllListsTableViewController.swift
//  Todo List
//
//  Created by Lu Jingjing on 15/12/14.
//  Copyright © 2015年 Schuming. All rights reserved.
//

import UIKit

class AllListsTableViewController: UITableViewController ,ListDetailViewControllerDelegate{

    var lists : [Checklist]
    
    required init?(coder aDecoder: NSCoder) {
        // 1
        lists = [Checklist]()
        
        // 2
        super.init(coder: aDecoder)
        
        // 3
        var list = Checklist(name :"Mon")
        lists.append(list)
        
        list = Checklist(name :"Tue")
        lists.append(list)
        
        list = Checklist(name :"Wed")
        lists.append(list)
        
        list = Checklist(name :"Thur")
        lists.append(list)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lists.count
    }

    
    func cellForTableView(tableView : UITableView)->UITableViewCell{
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = cellForTableView(tableView)

        let checklist = lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .DetailDisclosureButton
        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let checklist = lists[indexPath.row]
        performSegueWithIdentifier("ShowChecklist", sender: checklist)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destinationViewController as! TodoListTableViewController
            controller.checklist = sender as! Checklist
            
        } else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            
            controller.delegate = self
            controller._checklist = nil
        }
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingCheckList checklist: Checklist) {
        let newRowIndex = lists.count
        lists.append(checklist)
        
        let indexPath = NSIndexPath(forRow: newRowIndex,inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishEdittingCheckList checklist: Checklist) {
        if let index = lists.indexOf(checklist){
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                cell.textLabel?.text = checklist.name
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        lists.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
}
