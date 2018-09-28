//
//  gameplayVC Switch.swift
//  MC 3
//
//  Created by Kennyzi Yusuf on 26/09/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import AVFoundation

extension GameplayViewController {
    
    func switchPlayer(){
        if currentPlayer == 2 {
            changePlayerNotif.image = UIImage(named: "GiliranP2")
            view.addSubview(changePlayerNotif)
            let opacAnimation = opacityAnimation(startingOpacity: 0, endingOpacity: 1, Duration: 2)
            changePlayerNotif.layer.add(opacAnimation, forKey: "opacity")
            let duration: Double = 0
            UIView.animate(withDuration: duration){
                self.player1.center = self.nextPlayerPoss
                self.player2.center = self.currentPlayerPoss
            }
        }else {
            changePlayerNotif.image = UIImage(named: "GiliranP1")
            view.addSubview(changePlayerNotif)
            let opacAnimation = opacityAnimation(startingOpacity: 0, endingOpacity: 1, Duration: 2)
            changePlayerNotif.layer.add(opacAnimation, forKey: "opacity")
            //changePlayerNotif.isopaque
            let duration: Double = 0
            UIView.animate(withDuration: duration){
                self.player1.center = self.currentPlayerPoss
                self.player2.center = self.nextPlayerPoss
            }
        }
        
    }
    
    func opacityAnimation(startingOpacity: CGFloat, endingOpacity: CGFloat, Duration: Double) -> CABasicAnimation
    {
        let opacAnim = CABasicAnimation(keyPath: "opacity")
        opacAnim.fromValue = startingOpacity
        opacAnim.toValue = endingOpacity
        opacAnim.duration = Duration
        opacAnim.autoreverses = true
        //opacAnim.repeatCount = 1
        
        return opacAnim
    }
}

