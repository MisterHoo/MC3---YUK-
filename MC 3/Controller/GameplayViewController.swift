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
    
    var worldMap : ARWorldMap!
    var worldMapData : Data!
    
    var planeGeometry : SCNPlane!
    var plantIdentifiers : [UUID] = []
    var anchors : [ARAnchor] = []
    var sceneLight : SCNLight!
    var boardFlag : Bool = false
    
    var gameManager : gameManager!
    
    var isServer : Bool = false
    
    var worldMapItems:[WorldMapItem]!
    
    var multiPeer : MPCHandeler!
    
    let gameNode = SCNNode()
    let gameBoard = GameBoard()
    
    
    var counterHand : Int = 0
    var counterA : Int = 0
    var counterB : Int = 0
    
    var indexHoleColumn : Int = 0
    var indexHoleRow : Int = 0
    
    @IBAction func backButtonAction(_ sender: UIButton)
    {
        
        performSegue(withIdentifier: "gameToMenu", sender: self)
        multiPeer.mcAdvertiserAssistant = nil
        
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
        
        multiPeer = (UIApplication.shared.delegate as! AppDelegate).multiPeer

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
        
        
//        var option = SCNDebugOptions.showPhysicsShapes
//        sceneView.debugOptions = option

        
        // Do any additional setup after loading the view.
        


    }
    func writeWorldMap(_ worldMap: ARWorldMap, to url: URL) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
        try data.write(to: url)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUtility.lockOrientation(.all)
        
//        if multiPeer.session.connectedPeers.count != nil {
//            print(multiPeer.session.connectedPeers.count)
//        }
        
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = .horizontal
//        configuration.isLightEstimationEnabled = true
        
        if isServer == true{
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal
            configuration.isLightEstimationEnabled = true
            print("server")
            sceneView.session.run(configuration)
        }else{
            print("bukan Server")
            print(multiPeer.receivedData)
            loadWorldMap(from: multiPeer.receivedData)

            //print(worldMap)
            print(multiPeer.session)
            //print("bukan Server")
//            configuration.initialWorldMap = worldMap
//            sceneView.session.run(configuration)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.pause()
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
                
                planeGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.4)
            
                let planeNode = SCNNode(geometry: planeGeometry)
                
                planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
                planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2,1,0,0)
            
                updateMaterial()
                
                planeNode.name = "planeNode"
            
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
                        if planeAnchor.extent.x >= 0.3{
                            width = 0.3
                        }
                        if planeAnchor.extent.z >= 0.5{
                            height = 0.5
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: sceneView)
        
        //when board hasn't delploy
        if boardFlag == false {
            addNodeAtLocation(location: location!)
        }else{
            //when board already deployed
            let selectedHole = chooseHoleToGetBean(location: location!)
            print(selectedHole?.name)
            
            if counterHand == 0{
                for i in 0...1{
                    for j in 0...6{
                        if selectedHole?.name == gameBoard.holeBox[i][j].name{
                            indexHoleColumn = i
                            indexHoleRow = j+1
                        
                            for child in (selectedHole?.childNodes)!{
                                print(child.name)
                                if child.name == nil{
                                    counterHand += 1
                                    child.removeFromParentNode()
                                }
                            }
                        }
                    }
                }
            }else{
                print("Sum in Hand : \(counterHand)")
                if selectedHole?.name == gameBoard.goalPostBoxA.name{
                    addKacang(parentNode: gameBoard.goalPostBoxA)
                    indexHoleColumn = 1
                    indexHoleRow = 0
                    counterHand -= 1
                    counterA += 1
                    print(counterA)
                }else if selectedHole?.name == gameBoard.goalPostBoxB.name{
                    addKacang(parentNode: gameBoard.goalPostBoxB)
                    indexHoleColumn = 0
                    indexHoleRow = 0
                    counterHand -= 1
                    counterB += 1
                    print(counterB)
                }else if selectedHole?.name == gameBoard.holeBox[indexHoleColumn][indexHoleRow].name{
                    addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                    indexHoleRow += 1
                    counterHand -= 1
                }
            }
        }
    }
    
    func addKacang(parentNode : SCNNode){
        let kacang = KacangObject()
        kacang.loadModel()
        kacang.position = SCNVector3Make(0, 0, 0)
        
        parentNode.addChildNode(kacang)
    }
    
    func chooseHoleToGetBean (location : CGPoint) -> SCNNode?{
        let hitTestOptions : [SCNHitTestOption : Any] = [.categoryBitMask : 3]
        let hitResults = sceneView.hitTest(location, options: hitTestOptions)
        
        return hitResults.lazy.compactMap { result in
            guard let node = result.node.parent as? SCNNode else {return nil}
            return node
        }.first
    }
    
    func addNodeAtLocation (location : CGPoint){
        guard anchors.count > 0 else{
            print("anchors are not created yet")
            return
        }
        
        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        
        if hitResults.count > 0 && boardFlag == false{
            
            let result = hitResults.first!
            let newLocation = SCNVector3Make(result.worldTransform.columns.3.x,result.worldTransform.columns.3.y,result.worldTransform.columns.3.z)
            
            
            
            //adding object
            
            
            //Papan
            
            gameBoard.loadModel()
            gameBoard.position = newLocation
            
            
            
          
            //let gamePhysicsShape = SCNPhysicsShape(node: gameNode, options: SCNPhysicsShape.Option.type)
            
            
            //Kacang
            
            
            for i in 0...1{
                for j in 0...6{
                    for k in 1...7{
                        let kacang = KacangObject()
                        kacang.loadModel()
                        //kacang.position = SCNVector3Make(gameBoard.position.x + gameBoard.holeNode[i][j].position.x, gameBoard.position.y + gameBoard.holeNode[i][j].position.y + Float(k) * 0.01, gameBoard.position.z + gameBoard.holeNode[i][j].position.z)
                        
                        kacang.position = SCNVector3Make(0, Float(k) * 0.01, 0)

                        print(kacang.position)
                        //gameNode.addChildNode(kacang)
                        gameBoard.holeBox[i][j].addChildNode(kacang)
                        
                        //sceneView.scene.rootNode.addChildNode(kacang)
                    }
                   
//                    gameNode.addChildNode(gameBoard.holeNode[i][j])
//                    gameNode.addChildNode(gameBoard.holeBox[i][j])
                }
            }
            
            for i in 0...1{
                for j in 0...6{
                    let index = gameBoard.holeBox[i][j].childNodes
                    print(index.count)
                    for child in gameBoard.holeBox[i][j].childNodes{
                        print(child.name)
                        print(child.position)
                    }
                }
            }
            
            sceneView.scene.rootNode.addChildNode(gameBoard)
          


//            gameNode.addChildNode(gameBoard.goalPostBoxA)
//            gameNode.addChildNode(gameBoard.goalPostBoxB)
//
//            gameNode.addChildNode(gameBoard.goalPostHoleA)
//            gameNode.addChildNode(gameBoard.goalPostHoleB)
            
//
//            for holeBoxColl in gameBoard.holeBox{
//                for holeNode in holeBoxColl{
//                    for i in 1...7{
//                        let kacang = KacangObject()
//                        kacang.loadModel()
//                        kacang.position = SCNVector3Make(gameBoard.position.x + holeNode.position.x, gameBoard.position.y + holeNode.position.y, gameBoard.position.z + holeNode.position.z)
//
//                        //holeNode.addChildNode(kacang)
//                        gameNode.addChildNode(kacang)
//
//                    }
//                }
//            }
//            gameNode.addChildNode(gameBoard)
//            sceneView.scene.rootNode.addChildNode(gameNode)
            
           
            //convert World Map to Data
            getCurrentWorldMapData { (data, error) in
                self.worldMapData = data
                self.sendWorldMapData(self.worldMapData)
            }
            
            //validate no more board should place
            boardFlag = true
            
            //remove plane
             
            let planeNode = sceneView.scene.rootNode.childNode(withName: "planeNode", recursively: true)
            planeNode?.removeFromParentNode()
            
            
        }
        
    }
    
    // MARK: - send world Map
    func sendWorldMapData(_ worldData : Data!){
        if multiPeer.session.connectedPeers.count > 0 {
//            if let worldData = DataManager.loadData(worldData.){
//                do {
//                    try multiPeer.mcSession.send(worldData, toPeers: multiPeer.mcSession.connectedPeers, with: .reliable)
//                }catch {
//                    fatalError("could not send world data")
//                }
//            }
            do{
                try multiPeer.session.send(worldData, toPeers: multiPeer.session.connectedPeers, with: .reliable)
            }catch{
                fatalError("could not send world data")
            }
        }else{print("not connected to any device")}
    }
    
    func loadWorldMap(from archivedData: Data) {
        do {
            let uncompressedData = try archivedData.decompressed()
//            guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: uncompressedData) else {
//                DispatchQueue.main.async {
//                    print("error unarchived map")
//                }
//                return
//            }
//
//            DispatchQueue.main.async {
//                self.worldMap = worldMap
//                print(self.worldMap)
//            }
            if let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: uncompressedData) {
                // Run the session with the received world map.
                let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = .horizontal
                configuration.initialWorldMap = worldMap
                sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            }
            else
                if let anchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARAnchor.self, from: uncompressedData) {
                    // Add anchor to the session, ARSCNView delegate adds visible content.
                    sceneView.session.add(anchor: anchor)
                }else{
                    print("fail")
            }
        } catch {
            DispatchQueue.main.async {
                print("error load map")
            }
        }
    }
    
    private func fetchArchivedWorldMap(from url: URL, _ closure: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.global().async {
            do {
                _ = url.startAccessingSecurityScopedResource()
                defer { url.stopAccessingSecurityScopedResource() }
                let data = try Data(contentsOf: url)
                closure(data, nil)
                
            } catch {
                DispatchQueue.main.async {
                    print("error")
                }
                closure(nil, error)
            }
        }
    }
    
    func getCurrentWorldMapData(_ closure: @escaping (Data?, Error?) -> Void) {
        // When loading a map, send the loaded map and not the current extended map
        if let worldMap = worldMap {
            compressWorldMap(map: worldMap, closure)
            return
        } else {
            sceneView.session.getCurrentWorldMap { map, error in
                if let error = error {
                    closure(nil, error)
                }
                guard let map = map else {return }
                self.compressWorldMap(map: map, closure)
            }
        }
    }
    
    func compressWorldMap(map: ARWorldMap, _ closure: @escaping (Data?, Error?) -> Void){
        DispatchQueue.global().async {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                let compressData = data.compressed()
                closure(compressData,nil)
            } catch {
                print("error")
                closure(nil, error)
            }
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
