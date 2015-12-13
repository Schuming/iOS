//
//  HandleItemTableViewController.swift
//  Todo List
//
//  Created by Lu Jingjing on 15/12/12.
//  Copyright © 2015年 Schuming. All rights reserved.
//


//protocal 5 steps 假如object a 创建了object b
// 1. 在object b中声明协议
// 2. 在object b中声明使用协议的delegate
// 3. 在object b中调用协议方法
// 4. 在object a中实现协议方法
// 5. 将object a 赋值给object b的delegate


import UIKit

protocol HandleItemInTableViewDelegate : class {
    func HandleItemViewControllerDidCancle(controller : HandleItemTableViewController)
    func HandleItemViewController(controller : HandleItemTableViewController,didFinishAddingItem item:TodoItem)
    func HandleItemViewController(controller : HandleItemTableViewController,didFinishEdittingItem item:TodoItem)

}


class HandleItemTableViewController : UITableViewController,UITextFieldDelegate
{

    weak var delegate : HandleItemInTableViewDelegate?
    var itemToHandle : TodoItem?
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBAction func done(sender: AnyObject) {
        itemToHandle = TodoItem()
        itemToHandle?._todoItemName = textField.text!
        itemToHandle?._todoItemcheckStatus = false
//            TodoItem(todoItemCheckStatus: false, todoItemName: textField.text!)
        if self.title == "Add Item" {
        
            delegate?.HandleItemViewController(self, didFinishAddingItem: itemToHandle!)
        } else if self.title == "Edit Item" {
            delegate?.HandleItemViewController(self, didFinishEdittingItem: itemToHandle!)
        }
        
    }
    @IBAction func cancle(sender: AnyObject) {
        delegate?.HandleItemViewControllerDidCancle(self)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField.delegate = self
        doneBarButton.enabled = false
        
        textField.text = itemToHandle?._todoItemName
        
        let lap = UITapGestureRecognizer(target: self, action: Selector("handleTap:")) //此处 “：”必须要加,不加的话后面recognizer参数无法传递进去
        self.view.addGestureRecognizer(lap)
        
        
    }
    
    /* 解释为什么直接override touchesBegan不起作用
    //------------------------- comment -----------------------------
    // touchesBegan is a UIView method besides being a UIViewController method.
    // to override it you need to subclass UIView or UITableView and not the controller
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(false)
    }
    */
    
    func handleTap(recogenizer : UITapGestureRecognizer){
        
        self.tableView.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
  
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    
    let oldStr : NSString = textField.text!
    let newStr : NSString = oldStr.stringByReplacingCharactersInRange(range, withString: string)
    
    doneBarButton.enabled = (newStr.length > 0)
    
    return true
    }

//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    

}
