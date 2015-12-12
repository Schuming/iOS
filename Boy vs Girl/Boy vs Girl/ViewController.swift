//
//  ViewController.swift
//  Boy vs Girl
//
//  Created by Lu Jingjing on 15/12/11.
//  Copyright © 2015年 Schuming. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var gameOver = false
    var role = 1 //0 - empty 1 - boy 2 girl
    //    var stateBox = [0,0,0,0,0,0,0,0,0]
    var stateBox = [Int](count: 9, repeatedValue: 0)
    var winState = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    
    var winFlag = false
    
    @IBAction func PlayAgain(sender: AnyObject) {
        
        // model initial
        gameOver = false
        role = 1 //0 - empty 1 - boy 2 girl
        //    var stateBox = [0,0,0,0,0,0,0,0,0]
        stateBox = [Int](count: 9, repeatedValue: 0)
        winState = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        winFlag = false
        
        
        // view initial
        imageWin.hidden = true
        imageWin.center = CGPointMake(imageWin.center.x - 400, imageWin.center.y)
        
        playAgainButton.hidden = true
        playAgainButton.center = CGPointMake(playAgainButton.center.x - 400, playAgainButton.center.y)
        

        for i in 0...8 {
            let button = view.viewWithTag(i) as! UIButton
            button.setImage(nil, forState: UIControlState.Normal)
        }
        
        
        
        
    }
    @IBOutlet weak var playAgainButton: UIButton!
    
    @IBOutlet weak var imageWin: UIImageView!
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func showPlayer(sender: AnyObject) {
        
        if gameOver == false {
            
            // add a player
            if stateBox[sender.tag] == 0{
                
                stateBox[sender.tag] = role
                
                if role == 1 {
                    sender.setImage(UIImage(named: "boy.png"), forState: UIControlState.Normal)
                    
                    role = 2
                } else {
                    sender.setImage(UIImage(named: "girl.png"), forState: UIControlState.Normal)
                    
                    role = 1
                }
            }
            
            gameOver = ifGameOver()

            
            // game over ?
            if gameOver {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.imageWin.hidden = false
                    self.imageWin.center = CGPointMake(self.imageWin.center.x + 400, self.imageWin.center.y)
                    
                    self.playAgainButton.hidden = false
                    self.playAgainButton.center = CGPointMake(self.playAgainButton.center.x + 400, self.playAgainButton.center.y)
                })

            }
            
        }
        
    }
    
    
    func ifGameOver() -> Bool{
        // if win ?
        for state in winState{
            if (stateBox[state[0]] == stateBox[state[1]] && stateBox[state[2]] == stateBox[state[1]] && stateBox[state[0]] != 0){
                
                
                if stateBox[state[0]] == 1 {
                    imageWin.image = UIImage(named: "boy.png")
                } else {
                    imageWin.image = UIImage(named: "girl.png")
                }
                
                gameOver = true
                
                return true
            }
        }
        
        
        // if draw ?
        if (!stateBox.contains(0)) {
                imageWin.image = UIImage(named: "background.png")
                return true
            
        }
        
        
        return false
    
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imageWin.hidden = true
        imageWin.center = CGPointMake(imageWin.center.x - 400, imageWin.center.y)
        
        playAgainButton.hidden = true
        playAgainButton.center = CGPointMake(playAgainButton.center.x - 400, playAgainButton.center.y)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

