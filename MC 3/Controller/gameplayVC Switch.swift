//
//  gameplayVC Switch.swift
//  MC 3
//
//  Created by Kennyzi Yusuf on 26/09/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import UIKit
import SceneKit

extension GameplayViewController {
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    //uk text 167x35
    //uk bg 375x68
    //currentPlayerPoss == posisi P1
    //nextPlayerPoss == posisi P2
    
    func switchPlayer(){
        
        if currentPlayer == 2{
            //ganti dari player 1 ke player 2
            //set Image
            //ChangePlayerNotif -> Background Image
            print("masuk 1")
            changePlayerNotif.image = UIImage(named: "Giliran P2 BG")
            changePlayerNotifText.image = UIImage(named: "Giliran P2 Tulisan")
            player1.center = nextPlayerPoss
            player2.center = currentPlayerPoss
            
        }else if currentPlayer == 1{
            //ganti dari player 2 ke player 1
            //set Image
            //ChangePlayerNotif -> Background Image
            print("masuk 2")
            changePlayerNotif.image = UIImage(named: "Giliran P1 BG")
            changePlayerNotifText.image = UIImage(named: "Giliran P1 Tulisan")
            player1.center = currentPlayerPoss
            player2.center = nextPlayerPoss
        }
            //set Position
            changePlayerNotif.center = CGPoint.init(x: (self.screenWidth/2), y: (self.screenHeight/2)) //set BG to center
            changePlayerNotifText.center = CGPoint.init(x: -(self.changePlayerNotifText.bounds.width/2), y: self.screenHeight/2)
            changePlayerNotifText.alpha = 1
        
            //tambahin view
            view.addSubview(changePlayerNotif)
            view.addSubview(changePlayerNotifText)
        
            //set alpha to zero
            changePlayerNotif.alpha = 0
        
//           timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(stepOne), userInfo: nil, repeats: false)
            stepOne()

    }
    
    func stepOne(){
        //show background
        //move text from left to mid
        UIView.animate(withDuration: 0.5, animations: {
            self.isPaused = true
            print("step 1 masuk")
            self.changePlayerNotif.alpha = 1
            self.changePlayerNotifText.center = CGPoint.init(x: (self.screenWidth/2), y: (self.screenHeight/2))
        }) { (true) in
            self.stepTwo()
        }
    }
    
    func stepTwo(){
        //hold for 2 seconds
        UIView.animate(withDuration: 2.0, animations: {
            print("step 2 masuk")
            self.changePlayerNotifText.center = CGPoint.init(x: (self.screenWidth/2), y: (self.screenHeight/2))
        }) { (true) in
            self.stepThree()
        }
    }
    
    func stepThree(){
        //hide background
        //move text from mid to right
        UIView.animate(withDuration: 0.5, animations: {
            print("step 3 masuk")
            self.changePlayerNotif.alpha = 0
            self.changePlayerNotifText.center = CGPoint.init(x: (self.screenWidth + self.screenWidth/2), y: (self.screenHeight/2))
        }) { (true) in
            self.changePlayerNotifText.alpha = 0
            self.isPaused = false
        }
    }
    
    @objc func kosongan(){
        
    }
    
    func animationMenang(curPlayer : Int){
        if curPlayer == 1{
            print("player 1 menang")
            menangNotif.image = UIImage(named: "P1 Menang")
            print(menangNotif.image)
        }else if curPlayer == 2 {
            print("player 2 menang")
            menangNotif.image = UIImage(named: "P2 Menang")
        }
        menangNotif.center = CGPoint.init(x: (self.screenWidth/2), y: (self.screenHeight/2)) //set BG to center
        
        //set alpha 0
        menangNotif.alpha = 0
        
        view.addSubview(menangNotif)
        
        //start animation
        menangStepOne()
    }
    
    func menangStepOne(){
        UIView.animate(withDuration: 0.75) {
            self.isPaused = true
            self.menangNotif.alpha = 1
        }
    }
}
