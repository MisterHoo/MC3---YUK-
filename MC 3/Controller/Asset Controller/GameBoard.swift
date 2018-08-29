//
//  GameBoard.swift
//  MC 3
//
//  Created by Yosua Hoo on 20/08/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import ARKit

class GameBoard : SCNNode {
    
    var holeNode : [[SCNNode]] = []
    var holeBox : [[SCNNode]] = []
    var tempHoleNode : [SCNNode] = []
    var tempHoleBox : [SCNNode] = []
    var goalPostHoleA : SCNNode!
    var goalPostHoleB : SCNNode!
    var goalPostBoxA : SCNNode!
    var goalPostBoxB : SCNNode!
    var congklak : SCNNode!
    
    func loadModel(){
        guard let virtualObjectScene = SCNScene(named: "ModelAsset.scnassets/congklak/congklak.scn") else {return}
        
        congklak = virtualObjectScene.rootNode.childNode(withName: "congklak", recursively: false)
        
        
        tempHoleNode.append(congklak.childNode(withName: "hole1.1", recursively: false)!)
        tempHoleNode.append(congklak.childNode(withName: "hole1.2", recursively: false)!)
        tempHoleNode.append(congklak.childNode(withName: "hole1.3", recursively: false)!)
        tempHoleNode.append(congklak.childNode(withName: "hole1.4", recursively: false)!)
        tempHoleNode.append(congklak.childNode(withName: "hole1.5", recursively: false)!)
        tempHoleNode.append(congklak.childNode(withName: "hole1.6", recursively: false)!)
        tempHoleNode.append(congklak.childNode(withName: "hole1.7", recursively: false)!)
        
        holeNode.append(tempHoleNode)
        tempHoleNode.removeAll()
        
        tempHoleNode.append(congklak.childNode(withName: "hole2.1", recursively: false)!)
        tempHoleNode.append(congklak.childNode(withName: "hole2.2", recursively: false)!)
        tempHoleNode.append(congklak.childNode(withName: "hole2.3", recursively: false)!)
        tempHoleNode.append(congklak.childNode(withName: "hole2.4", recursively: false)!)
        tempHoleNode.append(congklak.childNode(withName: "hole2.5", recursively: false)!)
        tempHoleNode.append(congklak.childNode(withName: "hole2.6", recursively: false)!)
        tempHoleNode.append(congklak.childNode(withName: "hole2.7", recursively: false)!)
        
        holeNode.append(tempHoleNode)
        tempHoleNode.removeAll()
        
        goalPostHoleA = (congklak.childNode(withName: "hole1.8", recursively: false)!)
        goalPostHoleB = (congklak.childNode(withName: "hole2.8", recursively: false)!)
    
        tempHoleBox.append(virtualObjectScene.rootNode.childNode(withName: "holeBox1.1", recursively: false)!)
        tempHoleBox.append(virtualObjectScene.rootNode.childNode(withName: "holeBox1.2", recursively: false)!)
        tempHoleBox.append(virtualObjectScene.rootNode.childNode(withName: "holeBox1.3", recursively: false)!)
        tempHoleBox.append(virtualObjectScene.rootNode.childNode(withName: "holeBox1.4", recursively: false)!)
        tempHoleBox.append(virtualObjectScene.rootNode.childNode(withName: "holeBox1.5", recursively: false)!)
        tempHoleBox.append(virtualObjectScene.rootNode.childNode(withName: "holeBox1.6", recursively: false)!)
        tempHoleBox.append(virtualObjectScene.rootNode.childNode(withName: "holeBox1.7", recursively: false)!)
        
        holeBox.append(tempHoleBox)
        tempHoleBox.removeAll()
        
        tempHoleBox.append(virtualObjectScene.rootNode.childNode(withName: "holeBox2.1", recursively: false)!)
        tempHoleBox.append(virtualObjectScene.rootNode.childNode(withName: "holeBox2.2", recursively: false)!)
        tempHoleBox.append(virtualObjectScene.rootNode.childNode(withName: "holeBox2.3", recursively: false)!)
        tempHoleBox.append(virtualObjectScene.rootNode.childNode(withName: "holeBox2.4", recursively: false)!)
        tempHoleBox.append(virtualObjectScene.rootNode.childNode(withName: "holeBox2.5", recursively: false)!)
        tempHoleBox.append(virtualObjectScene.rootNode.childNode(withName: "holeBox2.6", recursively: false)!)
        tempHoleBox.append(virtualObjectScene.rootNode.childNode(withName: "holeBox2.7", recursively: false)!)
        
        holeBox.append(tempHoleBox)
        tempHoleBox.removeAll()
        
        goalPostBoxA = (virtualObjectScene.rootNode.childNode(withName: "GoalPostHoleBoxA", recursively: false)!)
        goalPostBoxB = (virtualObjectScene.rootNode.childNode(withName: "GoalPostHoleBoxB", recursively: false)!)
        
        let wrapperNode = SCNNode()
        wrapperNode.addChildNode(congklak)
        
        for node in holeNode{
            for obj in node{
                wrapperNode.addChildNode(obj)
            }
        }
        
        for node in holeBox{
            for obj in node{
                wrapperNode.addChildNode(obj)
            }
        }
        
        wrapperNode.addChildNode(goalPostHoleA)
        wrapperNode.addChildNode(goalPostHoleB)
        
        wrapperNode.addChildNode(goalPostBoxA)
        wrapperNode.addChildNode(goalPostBoxB)
        
        self.addChildNode(wrapperNode)
    }
}
