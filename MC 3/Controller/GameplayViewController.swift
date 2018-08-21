//
//  GameplayViewController.swift
//  MC 3
//
//  Created by Rhesa Febrin Saputra on 8/15/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class GameplayViewController: UIViewController, ARSCNViewDelegate {
    
    //var layouting
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var lockButtonOutlet: UIButton!
    
    //var ARKit & SceneKit
    @IBOutlet weak var sceneView: ARSCNView!
    
    var planeGeometry : SCNPlane!
    var plantIdentifiers : [UUID] = []
    var anchors : [ARAnchor] = []
    var sceneLight : SCNLight!
    var boardFlag : Bool = false
    
    
    
    @IBAction func backButtonAction(_ sender: UIButton)
    {
        performSegue(withIdentifier: "gameToMenu", sender: self)
    }
    
    
    @IBAction func lockButtonAction(_ sender: UIButton)
    {
        if lockButtonOutlet.currentImage == UIImage(named: "Unlocked")
        {
            lockButtonOutlet.setImage(UIImage(named: "Locked"), for: .normal)
        }else{
            lockButtonOutlet.setImage(UIImage(named: "Unlocked"), for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lockButtonOutlet.setImage(UIImage(named: "Unlocked"), for: .normal)
        
        //delegate sceneView
        sceneView.delegate = self
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        // add Light
        sceneView.autoenablesDefaultLighting = false
        sceneLight = SCNLight()
        sceneLight.type = .omni
        
        let lightNode = SCNNode()
        lightNode.light = sceneLight
        lightNode.position = SCNVector3(0, 10, 2)
        
        sceneView.scene.rootNode.addChildNode(lightNode)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: sceneView)
        
        addNodeAtLocation(location: location!)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        var node : SCNNode?
        
        if let planeAnchor = anchor as? ARPlaneAnchor{
            if anchors.count == 0 && boardFlag == false{
                node = SCNNode()
                
                
                var width : CGFloat = 0
                var height : CGFloat = 0
                
                width = CGFloat(planeAnchor.extent.x)
                height = CGFloat(planeAnchor.extent.z)
    
                
                //validate width & height
                if planeAnchor.extent.x >= 0.5{
                    width = 0.5
                }
                if planeAnchor.extent.z >= 0.3{
                    height = 0.3
                }
                
                
                planeGeometry = SCNPlane(width: width, height: height)
                
                print(width)
                print(height)
                
               
                
                
                planeGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.4)
            
                let planeNode = SCNNode(geometry: planeGeometry)
                
                planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
                planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2,1,0,0)
            
                updateMaterial()
            
                node?.addChildNode(planeNode)
                anchors.append(planeAnchor)
            }
        }
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        if let planeAnchor = anchor as? ARPlaneAnchor {
            
            if anchors.contains(planeAnchor){
                
                if node.childNodes.count > 0 && boardFlag == false{
                    
                    let planeNode = node.childNodes.first!
                    planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
                    
                    if let plane = planeNode.geometry as? SCNPlane {
                        
                        var width : CGFloat = 0
                        var height : CGFloat = 0
                        
                        width = CGFloat(planeAnchor.extent.x)
                        height = CGFloat(planeAnchor.extent.z)
                        
                        
                        //validate width & height
                        if planeAnchor.extent.x >= 0.5{
                            width = 0.5
                        }
                        if planeAnchor.extent.z >= 0.3{
                            height = 0.3
                        }
                        
                        
                        plane.width = width
                        plane.height = height
                        updateMaterial()
                    }
                }
            }
        }
    }
    
    
    func updateMaterial(){
        let material = self.planeGeometry.materials.first!
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(self.planeGeometry.width), Float(self.planeGeometry.height), 1)
    }
    
    func addNodeAtLocation (location : CGPoint){
        guard anchors.count > 0 else{
            print("anchors are not created yet")
            return
        }
        
        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        
        if hitResults.count > 0 && boardFlag == false{
            
            let result = hitResults.first!
            
            print("\(result.worldTransform.columns.0.x),\(result.worldTransform.columns.0.y)),\(result.worldTransform.columns.0.z))")
            print("\(result.worldTransform.columns.1.x),\(result.worldTransform.columns.1.y)),\(result.worldTransform.columns.1.z))")
            print("\(result.worldTransform.columns.2.x),\(result.worldTransform.columns.2.y)),\(result.worldTransform.columns.2.z))")
            print("\(result.worldTransform.columns.3.x),\(result.worldTransform.columns.3.y)),\(result.worldTransform.columns.3.z))")
            
            let anchor = anchors.first as! ARPlaneAnchor
            
            let newLocation = SCNVector3Make(result.worldTransform.columns.3.x,result.worldTransform.columns.3.y,result.worldTransform.columns.3.z)
            
            
            //adding object
            
            let gameBoard = GameBoard()
            gameBoard.loadModel()
            gameBoard.pivot = SCNMatrix4MakeTranslation(0.2,0,0)
            gameBoard.position = newLocation
           
            //print(gameBoard.rotation)
            
            sceneView.scene.rootNode.addChildNode(gameBoard)
            
            //validate no more object
            boardFlag = true
            
            //remove plane
             
            
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
