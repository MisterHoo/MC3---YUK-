//
//  KacangObject.swift
//  MC 3
//
//  Created by Yosua Hoo on 28/08/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import Foundation
import SceneKit

class KacangObject : SCNNode {
    
    func loadModel (){
        guard let kacangObjectScene = SCNScene(named: "ModelAsset.scnassets/bijinya/kacang5.scn") else {return}
        
        let wrapperNode = SCNNode()
        
        for child in kacangObjectScene.rootNode.childNodes{
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)
        
    }
    
}
