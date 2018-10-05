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
    func switchPlayer(){
        if currentPlayer == 2 {
            changePlayerNotif.image = UIImage(named: "GiliranP2")
            view.addSubview(changePlayerNotif)
            view.addSubview(blackBackground)
            let opacAnimation = opacityAnimationNotReverse(startingOpacity: 0, endingOpacity: 1, Duration: 0.5)
            let blackAnimation = opacityAnimation(startingOpacity: 0.3, endingOpacity: 0.3, Duration: animateTime)
            changePlayerNotif.layer.add(opacAnimation, forKey: "opacity")
            blackBackground.layer.add(blackAnimation, forKey: "opacity")
            opacTime()
            
            UIView.animate(withDuration: 0.5) {
                self.giliranPlayer.center = CGPoint.init(x: -(self.screenWidth/2), y: (self.screenHeight/2))
            }
            
            timer = Timer.scheduledTimer(timeInterval: (2.5), target: self, selector: #selector(GameplayViewController.mid), userInfo: nil, repeats: false)
            
            timer = Timer.scheduledTimer(timeInterval: (2.5), target: self, selector: #selector(GameplayViewController.mid), userInfo: nil, repeats: false)
           
            let duration: Double = 0
            UIView.animate(withDuration: duration){
                self.player1.center = self.nextPlayerPoss
                self.player2.center = self.currentPlayerPoss
            }
        }else {
            changePlayerNotif.image = UIImage(named: "GiliranP1")
            view.addSubview(changePlayerNotif)
            view.addSubview(blackBackground)
            let opacAnimation = opacityAnimationNotReverse(startingOpacity: 0, endingOpacity: 1, Duration: 0.5)
            let blackAnimation = opacityAnimation(startingOpacity: 0.3, endingOpacity: 0.3, Duration: animateTime)
            changePlayerNotif.layer.add(opacAnimation, forKey: "opacity")
            blackBackground.layer.add(blackAnimation, forKey: "opacity")
            opacTime()
            UIView.animate(withDuration: 0.5) {
                
                self.giliranPlayer.center = CGPoint.init(x: -(self.screenWidth/2), y: (self.screenHeight/2))
            }
            timer = Timer.scheduledTimer(timeInterval: (2.5), target: self, selector: #selector(GameplayViewController.mid), userInfo: nil, repeats: false)
            timer = Timer.scheduledTimer(timeInterval: (2.5), target: self, selector: #selector(GameplayViewController.gone), userInfo: nil, repeats: false)
            
            let duration: Double = 0
            UIView.animate(withDuration: duration){
                self.player1.center = self.nextPlayerPoss
                self.player2.center = self.currentPlayerPoss
            }
        }
        
    }
    func opacTime(){
        isPaused = true
        timer = Timer.scheduledTimer(timeInterval: (animateTime*2), target: self, selector: #selector(GameplayViewController.opacTimeF), userInfo: nil, repeats: false)
    }
    @objc func opacTimeF(){
        isPaused = false
    }
    @objc func mid(){
        UIView.animate(withDuration: 0.5) {
            self.giliranPlayer.center = CGPoint.init(x: (self.screenWidth+100), y: (self.screenHeight/2))
        }
    }
    @objc func gone(){
        view.addSubview(changePlayerNotif)
        let opacAnimationGone = opacityAnimationNotReverse(startingOpacity: 1, endingOpacity: 0, Duration: 0.5)
        changePlayerNotif.layer.add(opacAnimationGone, forKey: "opacity")
    }
    
    func opacityAnimation(startingOpacity: CGFloat, endingOpacity: CGFloat, Duration: Double) -> CABasicAnimation
    {
        let opacAnim = CABasicAnimation(keyPath: "opacity")
        opacAnim.fromValue = startingOpacity
        opacAnim.toValue = endingOpacity
        opacAnim.duration = Duration
        opacAnim.autoreverses = true
        
        return opacAnim
    }
    
    func opacityAnimationNotReverse(startingOpacity: CGFloat, endingOpacity: CGFloat, Duration: Double) -> CABasicAnimation
    {
        let opacAnim = CABasicAnimation(keyPath: "opacity")
        opacAnim.fromValue = startingOpacity
        opacAnim.toValue = endingOpacity
        opacAnim.duration = Duration
        opacAnim.autoreverses = false
        
        return opacAnim
    }
}

