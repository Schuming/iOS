//
//  ListDetailViewController.swift
//  Todo List
//
//  Created by Lu Jingjing on 15/12/15.
//  Copyright © 2015年 Schuming. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate : class {
    func listDetailViewControllerDidCancel(controller : ListDetailViewController)
    func listDetailViewController(controller : ListDetailViewController ,didFinishAddingCheckList checklist:Checklist)
    func listDetailViewController(controller : ListDetailViewController ,didFinishEdittingCheckList checklist:Checklist)
    
}
class ListDetailViewController : UITableViewController,UITextFieldDelegate {
    @IBOutlet weak var textField:UITextField!
    @IBOutlet weak var doneBarButton:UIBarButtonItem!
    
    weak var delegate : ListDetailViewControllerDelegate?
    var _checklist:Checklist?

    override func viewDidLoad() {
        // 1
        
        // 2
        super.viewDidLoad()
        
        // 3
        if let checklist = _checklist{
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.enabled = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancle() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(){
        if let checklist = _checklist {
            checklist.name = textField.text!
            delegate?.listDetailViewController(self, didFinishEdittingCheckList: checklist)
        } else {
            let checklist = Checklist(name: textField.text!)
            delegate?.listDetailViewController(self, didFinishAddingCheckList: checklist)
        }
    }

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText : NSString = textField.text!
        let newText : NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        doneBarButton.enabled = (newText.length > 0)
        return true
        
    }
}

