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
//    var sceneLight : SCNLight!
    
    
    
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
        let node = SCNNode()
        
        if let planeAnchor = anchor as? ARPlaneAnchor{
            planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            planeGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.6)
            
            let planeNode = SCNNode(geometry: planeGeometry)
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2,1,0,0)
            
            updateMaterial()
            
            node.addChildNode(planeNode)
            anchors.append(planeAnchor)
        }
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            if anchors.contains(planeAnchor){
                if node.childNodes.count > 0{
                    let planeNode = node.childNodes.first!
                    planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
                    
                    if let plane = planeNode.geometry as? SCNPlane {
                        plane.width = CGFloat(planeAnchor.extent.x)
                        plane.height = CGFloat(planeAnchor.extent.z)
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
        
        if hitResults.count > 0{
            
            let result = hitResults.first!
            let newLocation = SCNVector3(result.worldTransform.columns.3.x
                , result.worldTransform.columns.3.y
                , result.worldTransform.columns.3.z)
            //adding object
            /*
             let shipNode = spaceShip()
             shipNode.loadModal()
             shipNode.position = newLocation
             
             sceneView.scene.rootNode.addChildNode(shipNode)
             */
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
