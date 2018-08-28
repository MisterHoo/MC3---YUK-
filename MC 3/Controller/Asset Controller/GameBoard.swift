//
//  GameBoard.swift
//  MC 3
//
//  Created by Yosua Hoo on 20/08/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import ARKit

class GameBoard : SCNNode {
    
    var holeNode : [SCNNode] = []
    var goalPostHoleA : SCNNode!
    var goalPostHoleB : SCNNode!
    
    func loadModel(){
        guard let virtualObjectScene = SCNScene(named: "ModelAsset.scnassets/congklak/congklak.scn") else {return}
        
        guard let congklak = virtualObjectScene.rootNode.childNode(withName: "congklak", recursively: false) else {return}
        
        holeNode.append(congklak.childNode(withName: "hole1.1", recursively: false)!)
        holeNode.append(congklak.childNode(withName: "hole1.2", recursively: false)!)
        holeNode.append(congklak.childNode(withName: "hole1.3", recursively: false)!)
        holeNode.append(congklak.childNode(withName: "hole1.4", recursively: false)!)
        holeNode.append(congklak.childNode(withName: "hole1.5", recursively: false)!)
        holeNode.append(congklak.childNode(withName: "hole1.6", recursively: false)!)
        holeNode.append(congklak.childNode(withName: "hole1.7", recursively: false)!)
        
        holeNode.append(congklak.childNode(withName: "hole2.1", recursively: false)!)
        holeNode.append(congklak.childNode(withName: "hole2.2", recursively: false)!)
        holeNode.append(congklak.childNode(withName: "hole2.3", recursively: false)!)
        holeNode.append(congklak.childNode(withName: "hole2.4", recursively: false)!)
        holeNode.append(congklak.childNode(withName: "hole2.5", recursively: false)!)
        holeNode.append(congklak.childNode(withName: "hole2.6", recursively: false)!)
        holeNode.append(congklak.childNode(withName: "hole2.7", recursively: false)!)
        
        
        goalPostHoleA = (congklak.childNode(withName: "hole1.8", recursively: false)!)
        goalPostHoleB = (congklak.childNode(withName: "hole2.8", recursively: false)!)
    
        
        print(holeNode.count)
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes{
            wrapperNode.addChildNode(child)
        }
        
        for node in holeNode{
            wrapperNode.addChildNode(node)
        }
        
        wrapperNode.addChildNode(goalPostHoleA)
        wrapperNode.addChildNode(goalPostHoleB)
        
        self.addChildNode(wrapperNode)
    }
}
