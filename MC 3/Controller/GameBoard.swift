//
//  GameBoard.swift
//  MC 3
//
//  Created by Yosua Hoo on 20/08/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import ARKit

class GameBoard : SCNNode{
    
    func loadModel(){
        guard let virtualObjectScene = SCNScene(named: "ModelAsset.scnassets/congklak.scn") else {return}
        
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes{
            wrapperNode.addChildNode(child)
        }
        print("ada Object koq")
        
        self.addChildNode(wrapperNode)
        
    }
}
