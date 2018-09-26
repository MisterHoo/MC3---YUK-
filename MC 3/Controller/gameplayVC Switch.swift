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
            UIView.animate(withDuration: 2.0){
                self.player1.center.x += 100
                self.player2.center.x -= 100
            }
        }
    }
}

