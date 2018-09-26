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
            changePlayerNotif.image = UIImage(named: "GilliranP2")
            let duration: Double = 1.0
            UIView.animate(withDuration: duration){
                self.changePlayerNotif.alpha = 1.0
                self.player1.center = self.nextPlayerPoss
                self.player2.center = self.currentPlayerPoss
            }
            UIView.animate(withDuration: 1.0){
                self.changePlayerNotif.alpha = 0
            }
        }else {
            changePlayerNotif.image = UIImage(named: "GilliranP1")
            let duration: Double = 1.0
            UIView.animate(withDuration: duration){
                self.changePlayerNotif.alpha = 1.0
                self.player1.center = self.currentPlayerPoss
                self.player2.center = self.nextPlayerPoss
            }
            UIView.animate(withDuration: 1.0){
                self.changePlayerNotif.alpha = 0
            }
        }
    }
}

