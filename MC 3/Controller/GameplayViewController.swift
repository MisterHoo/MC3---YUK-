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
import MultipeerConnectivity

class GameplayViewController: UIViewController, ARSCNViewDelegate {
    
    // Test for Mr HOO
    //var view score
    
    //@IBOutlet weak var viewScore: UIView!
    
    //var status label
    
    @IBOutlet weak var statusLabel: UILabel!
    
    //var layouting
    @IBOutlet weak var backButtonOutlet: UIButton!
    //@IBOutlet weak var lockButtonOutlet: UIButton!
    
    //var ARKit & SceneKit
    @IBOutlet weak var sceneView: ARSCNView!
    
    //@IBOutlet weak var currentPlayerLabel: UILabel!
    
    @IBOutlet weak var scoreBLabel: UILabel!
    @IBOutlet weak var scoreALabel: UILabel!
    @IBOutlet weak var currentBeanInHandLabel: UILabel!
    
    //player now
    @IBOutlet weak var currPlayer: UIImageView!
    @IBOutlet weak var nextPlayer: UIImageView!
    
    @IBOutlet weak var player1: UIView!
    @IBOutlet weak var player2: UIView!
    
    
    @IBOutlet weak var changePlayerNotif: UIImageView!
    
    var currentPlayerPoss: CGPoint!
    var nextPlayerPoss: CGPoint!
    
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
    
    var gameNode = SCNNode()
    var gameBoard = GameBoard()
    var gameAnchor : ARAnchor!
    
    var counterHand : Int = 0
    var counterA : Int = 0
    var counterB : Int = 0
    
    var indexHoleColumn : Int = 0
    var indexHoleRow : Int = 0
    
    var currentPlayer : Int = 1
    var enemyPlayer : Int = 1
    var curPlayerTime : Int = 0
    var isGameOver : Bool = false
    var isPaused : Bool = false
    
    var turnPlayer = AVAudioPlayer()
    var putSeed = AVAudioPlayer()
    var getSeed = AVAudioPlayer()
    
    var timer = Timer()
    let animateTime: Double = 2
    
    @IBOutlet weak var blackBackground: UIImageView!
    @IBOutlet weak var giliranPlayer: UILabel!
    
    @IBAction func backButtonAction(_ sender: UIButton)
    {
        
        createAlert(title: "Keluar dari game", message: "Anda yakin?")
        
        multiPeer.mcAdvertiserAssistant = nil
        
    }
    
    func createAlert (title : String, message : String) {
        let alert = UIAlertController (title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // Alert Button
        alert.addAction(UIAlertAction(title: "Ya", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            self.dismiss(animated: false, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Batal", style: UIAlertActionStyle.cancel, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //    @IBAction func lockButtonAction(_ sender: UIButton)
    //    {
    //        if lockButtonOutlet.currentImage == UIImage(named: "Unlocked")
    //        {
    //            lockButtonOutlet.setImage(UIImage(named: "Locked"), for: .normal)
    //        }else{
    //            lockButtonOutlet.setImage(UIImage(named: "Unlocked"), for: .normal)
    //        }
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("load")
        print(player2.center)
        print(player1.center)
        currentPlayerPoss = player1.center
        nextPlayerPoss = player2.center
        
        //        viewScore.layer.cornerRadius = 5
        //        viewScore.layer.masksToBounds = true
        
        multiPeer = (UIApplication.shared.delegate as! AppDelegate).multiPeer
        
        //        lockButtonOutlet.setImage(UIImage(named: "Unlocked"), for: .normal)
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
        
        
        //        updateLabel(label: currentPlayerLabel, input: currentPlayer)
        sceneView.scene.rootNode.addChildNode(lightNode)
        
        //init label
        //updateLabel(label: currentPlayerLabel, input: currentPlayer)
        DispatchQueue.main.async {
            self.updateLabel(label: self.scoreALabel, input: 0)
            self.updateLabel(label: self.scoreBLabel, input: 0)
            self.updateLabel(label: self.currentBeanInHandLabel, input: 0)
            self.updateStringLabel(label: self.statusLabel, input: "Cari dan deteksi bidang datar untuk meletakkan plane")
        }
        
        
        
        //debugOptions
        //        var option = SCNDebugOptions.showPhysicsShapes
        //        sceneView.debugOptions = option
        
        //configure Tap Gesture
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.tapped(tapRecognizer:)))
        sceneView.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
        
        
    }
    func writeWorldMap(_ worldMap: ARWorldMap, to url: URL) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
        try data.write(to: url)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //AppUtility.lockOrientation(.all)
        
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
        
        if let planeAnchor = anchor as? ARPlaneAnchor, anchor.name == nil{
            if boardFlag == false && anchors.isEmpty{
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
                
                node?.name = "titikPlane"
                planeNode.name = "planeNode"
                
                node?.addChildNode(planeNode)
                anchors.append(planeAnchor)
                
                //print(sceneView.node(for: ))
                //print(sceneView.anchor(for: planeNode))
                
                DispatchQueue.main.async {
                    //papan plane sudah ada
                    self.updateStringLabel(label: self.statusLabel, input: "Ketuk plane untuk meletakkan papan congklak")
                }
                
                //                gameNode = node!
                //                gameAnchor = planeAnchor
            }
        }else if anchor.name == "congklak"{
            node = gameBoard
        }
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        if let planeAnchor = anchor as? ARPlaneAnchor, anchor.name == nil{
            if anchors.contains(planeAnchor){
                
                if node.childNodes.count > 0 && boardFlag == false{
                    DispatchQueue.main.async {
                        //papan plane sudah ada
                        self.updateStringLabel(label: self.statusLabel, input: "Ketuk plane untuk meletakkan papan congklak")
                    }
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
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("masuk")
        if let name = anchor.name, name.hasPrefix("congklak"){
            //            print("masuk if")
            //            let tempGameBoard = GameBoard()
            //            tempGameBoard.name = "gameboard"
            //            node.addChildNode(tempGameBoard)
            //            gameNode = node
            //            gameBoard = gameNode.childNode(withName: "gameboard", recursively: false) as! GameBoard
            gameAnchor = anchor
            
            print(gameBoard)
            print(gameAnchor)
            print(sceneView.anchor(for: gameBoard))
            print(sceneView.node(for: gameAnchor))
            
            let newPosition = SCNVector3(gameAnchor.transform.columns.3.x, gameAnchor.transform.columns.3.y, gameAnchor.transform.columns.3.z)
            gameBoard.position = newPosition
            
            DispatchQueue.main.async {
                self.gameBoard.loadModel()
                self.initModel()
            }
        }
    }
    
    func addNodeAtLocation (location : CGPoint){
        //        guard anchors.count > 0 else{
        //            print("anchors are not created yet")
        //            return
        //        }
        
        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        
        if hitResults.count > 0 && boardFlag == false{
            
            let result = hitResults.first!
            //            let newLocation = SCNVector3Make(result.worldTransform.columns.3.x,result.worldTransform.columns.3.y,result.worldTransform.columns.3.z)
            
            let anchor = ARAnchor(name: "congklak", transform: result.worldTransform)
            sceneView.session.add(anchor: anchor)
            print("nambah anchor")
            
            getCurrentWorldMapData { (data, error) in
                self.worldMapData = data
                self.sendWorldMapData(self.worldMapData)
            }
            //adding object
            
            //            let tempGameBoard = GameBoard()
            //            tempGameBoard.name = "gameboard"
            //            gameNode.addChildNode(tempGameBoard)
            //
            //            let newPosition = SCNVector3Make(gameAnchor.transform.columns.3.x,gameAnchor.transform.columns.3.y,gameAnchor.transform.columns.3.z)
            //
            //            gameBoard = gameNode.childNode(withName: "gameboard", recursively: false) as! GameBoard
            //
            //
            //Papan
            //            DispatchQueue.main.async {
            //                self.gameBoard.position = newPosition
            //                self.gameBoard.loadModel()
            //                self.initModel()
            //            }
            
            
            //            print(sceneView.anchor(for: gameBoard))
            
            //            //let gamePhysicsShape = SCNPhysicsShape(node: gameNode, options: SCNPhysicsShape.Option.type)
            //
            //
            //            //Kacang
            //
            //            for i in 0...1{
            //                for j in 0...6{
            //                    for k in 1...7{
            //                        let kacang = KacangObject()
            //                        kacang.loadModel()
            //                        kacang.position = SCNVector3Make(0, Float(k) * 0.01, 0)
            //
            //                        //print(kacang.position)
            //                        //gameNode.addChildNode(kacang)
            //                        gameBoard.holeBox[i][j].addChildNode(kacang)
            //
            //                        //sceneView.scene.rootNode.addChildNode(kacang)
            //                    }
            //                    gameBoard.holeBox[i][j].childNode(withName: "Highlight", recursively: false)?.isHidden = true
            ////                    gameNode.addChildNode(gameBoard.holeNode[i][j])
            ////                    gameNode.addChildNode(gameBoard.holeBox[i][j])
            //                }
            //            }
            //
            //            gameBoard.goalPostBoxA.childNode(withName: "Highlight", recursively: false)?.isHidden = true
            //            gameBoard.goalPostBoxB.childNode(withName: "Highlight", recursively: false)?.isHidden = true
            //
            //            sceneView.scene.rootNode.addChildNode(gameBoard)
            //            initGame()
            //
            //            //convert World Map to Data
            //            getCurrentWorldMapData { (data, error) in
            //                self.worldMapData = data
            //                self.sendWorldMapData(self.worldMapData)
            //            }
            //
            //            //validate no more board should place
            //            boardFlag = true
            //
            //            //remove plane
            //
            //            let planeNode = sceneView.scene.rootNode.childNode(withName: "planeNode", recursively: true)
            //            planeNode?.removeFromParentNode()
            //
            //            let end = Date()
            //
            //            print(end.timeIntervalSince(start))
            
        }
        
    }
    
    func initModel(){
        //Kacang
        
        for i in 0...1{
            for j in 0...6{
                for k in 1...7{
                    let kacang = KacangObject()
                    kacang.loadModel()
                    kacang.position = SCNVector3Make(0, Float(k) * 0.01, 0)
                    
                    //print(kacang.position)
                    //gameNode.addChildNode(kacang)
                    gameBoard.holeBox[i][j].addChildNode(kacang)
                    
                    //sceneView.scene.rootNode.addChildNode(kacang)
                }
                gameBoard.holeBox[i][j].childNode(withName: "Highlight", recursively: false)?.isHidden = true
                //                    gameNode.addChildNode(gameBoard.holeNode[i][j])
                //                    gameNode.addChildNode(gameBoard.holeBox[i][j])
            }
        }
        
        gameBoard.goalPostBoxA.childNode(withName: "Highlight", recursively: false)?.isHidden = true
        gameBoard.goalPostBoxB.childNode(withName: "Highlight", recursively: false)?.isHidden = true
        
        sceneView.scene.rootNode.addChildNode(gameNode)
        initGame()
        
        //        //convert World Map to Data
        //        getCurrentWorldMapData { (data, error) in
        //            self.worldMapData = data
        //            self.sendWorldMapData(self.worldMapData)
        //        }
        
        //validate no more board should place
        boardFlag = true
        
        //remove plane
        
        let planeNode = sceneView.scene.rootNode.childNode(withName: "titikPlane", recursively: false)
        planeNode?.removeFromParentNode()
        
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
