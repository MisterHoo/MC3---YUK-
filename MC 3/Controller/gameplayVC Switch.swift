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
    
    func switchPlayer(){
        
        if currentPlayer == 2{
            //ganti dari player 1 ke player 2
            //set Image
            //ChangePlayerNotif -> Background Image
            print("masuk 1")
            changePlayerNotif.image = UIImage(named: "Giliran P2 BG")
            changePlayerNotifText.image = UIImage(named: "Giliran P2 Tulisan")
            
        }else if currentPlayer == 1{
            //ganti dari player 2 ke player 1
            //set Image
            //ChangePlayerNotif -> Background Image
            print("masuk 2")
            changePlayerNotif.image = UIImage(named: "Giliran P1 BG")
            changePlayerNotifText.image = UIImage(named: "Giliran P1 Tulisan")
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
            
//            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(stepOne), userInfo: nil, repeats: false)
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
        
    }
}


//    func switchPlayer(){
//        if currentPlayer == 2 {
//            changePlayerNotif.image = UIImage(named: "GiliranP2")
//            view.addSubview(changePlayerNotif)
//            view.addSubview(blackBackground)
//            let opacAnimation = opacityAnimationNotReverse(startingOpacity: 0, endingOpacity: 1, Duration: 1)
//            let blackAnimation = opacityAnimation(startingOpacity: 0.3, endingOpacity: 0.3, Duration: animateTime)
//            changePlayerNotif.layer.add(opacAnimation, forKey: "opacity")
//            blackBackground.layer.add(blackAnimation, forKey: "opacity")
//            opacTime()
//
//            UIView.animate(withDuration: 0.5) {
//                self.giliranPlayer.center = CGPoint.init(x: -(self.screenWidth/2), y: (self.screenHeight/2))
//            }
//
//            timer = Timer.scheduledTimer(timeInterval: (3), target: self, selector: #selector(GameplayViewController.mid), userInfo: nil, repeats: false)
//            timer = Timer.scheduledTimer(timeInterval: (3), target: self, selector: #selector(GameplayViewController.gone), userInfo: nil, repeats: false)
//
//            let duration: Double = 0
//            UIView.animate(withDuration: duration){
//                self.player1.center = self.nextPlayerPoss
//                self.player2.center = self.currentPlayerPoss
//            }
//        }else {
//            changePlayerNotif.image = UIImage(named: "GiliranP1")
//            view.addSubview(changePlayerNotif)
//            view.addSubview(blackBackground)
//            let opacAnimation = opacityAnimationNotReverse(startingOpacity: 0, endingOpacity: 1, Duration: 1)
//            let blackAnimation = opacityAnimation(startingOpacity: 0.3, endingOpacity: 0.3, Duration: animateTime)
//            changePlayerNotif.layer.add(opacAnimation, forKey: "opacity")
//            blackBackground.layer.add(blackAnimation, forKey: "opacity")
//            opacTime()
//            UIView.animate(withDuration: 0.5) {
//                self.giliranPlayer.center = CGPoint.init(x: -(self.screenWidth/2), y: (self.screenHeight/2))
//            }
//            timer = Timer.scheduledTimer(timeInterval: (3), target: self, selector: #selector(GameplayViewController.mid), userInfo: nil, repeats: false)
//            timer = Timer.scheduledTimer(timeInterval: (3), target: self, selector: #selector(GameplayViewController.gone), userInfo: nil, repeats: false)
//
//            let duration: Double = 0
//            UIView.animate(withDuration: duration){
//                self.player1.center = self.nextPlayerPoss
//                self.player2.center = self.currentPlayerPoss
//            }
//        }
//
//    }
//    func opacTime(){
//        isPaused = true
//        timer = Timer.scheduledTimer(timeInterval: (animateTime*2), target: self, selector: #selector(GameplayViewController.opacTimeF), userInfo: nil, repeats: false)
//    }
//    @objc func opacTimeF(){
//        isPaused = false
//    }
//    @objc func mid(){
//        UIView.animate(withDuration: 1) {
//            self.giliranPlayer.center = CGPoint.init(x: (self.screenWidth+100), y: (self.screenHeight/2))
//        }
//    }
//    @objc func gone(){
//        view.addSubview(changePlayerNotif)
//        let opacAnimationGone = opacityAnimationNotReverse(startingOpacity: 1, endingOpacity: 0, Duration: 1)
//        changePlayerNotif.layer.add(opacAnimationGone, forKey: "opacity")
//    }
//
//    func opacityAnimation(startingOpacity: CGFloat, endingOpacity: CGFloat, Duration: Double) -> CABasicAnimation
//    {
//        let opacAnim = CABasicAnimation(keyPath: "opacity")
//        opacAnim.fromValue = startingOpacity
//        opacAnim.toValue = endingOpacity
//        opacAnim.duration = Duration
//        opacAnim.autoreverses = true
//
//        return opacAnim
//    }
//
//    func opacityAnimationNotReverse(startingOpacity: CGFloat, endingOpacity: CGFloat, Duration: Double) -> CABasicAnimation
//    {
//        let opacAnim = CABasicAnimation(keyPath: "opacity")
//        opacAnim.fromValue = startingOpacity
//        opacAnim.toValue = endingOpacity
//        opacAnim.duration = Duration
//        opacAnim.autoreverses = false
//
//        return opacAnim
//    }
//}

