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
import AVFoundation

class GameplayViewController: UIViewController, ARSCNViewDelegate, MCBrowserViewControllerDelegate{
    
    // Test for Mr HOO
    //var view score
    
    //@IBOutlet weak var viewScore: UIView!
    
    // var outlet audio
    @IBOutlet weak var audioOutlet: UIButton!
    
    // var status label
    
    @IBOutlet weak var statusBackground: UIImageView!
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
    @IBOutlet weak var changePlayerNotifText: UIImageView!
    @IBOutlet weak var menangNotif: UIImageView!
    
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
    var isMultipeer : Bool = false
    
    var worldMapItems:[WorldMapItem]!
    
    var multiPeer : MPCHandeler!
    var multipeerSession: MPCHandeler!
    
    var gameNode = SCNNode()
    var gameBoard = GameBoard()
    var gameAnchor : ARAnchor!
    
    var counterHand : Int = 0
    var counterA : Int = 0
    var counterB : Int = 0
    
    var indexHoleColumn : Int = 0
    var indexHoleRow : Int = 0
    
    var currentPlayer : Int = 1
    var thisPlayer : Int = 1
    var enemyPlayer : Int = 1
    var curPlayerTime : Int = 0
    var isGameOver : Bool = false
    var isPaused : Bool = false
    
    var numberBeanNode : [SCNNode] = []
    
    var turnPlayer = AVAudioPlayer()
    var putSeed = AVAudioPlayer()
    var getSeed = AVAudioPlayer()
    var isAudioInited : Bool = false
    
    var timer = Timer()
    let animateTime: Double = 2
    
    var dataWorldMpaYangMauDikirim: Data!
    
    @IBOutlet weak var blackBackground: UIImageView!
    @IBOutlet weak var giliranPlayer: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @IBAction func backButtonAction(_ sender: UIButton)
    {
        
        createAlert(title: "Keluar dari game", message: "Anda yakin?")
        
        multipeerSession.mcAdvertiserAssistant = nil
        
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
    
    @IBAction func bantuanButton(_ sender: Any) {
        if statusLabel.isHidden == true && statusBackground.isHidden == true{
            //show Bantuan
            DispatchQueue.main.async {
                self.showIndicatorBean()
                self.statusLabel.isHidden = false
                self.statusBackground.isHidden = false
            }
        } else {
            //Hide Bantuan
            DispatchQueue.main.async {
                self.hideIndicatorBean()
                self.statusBackground.isHidden = true
                self.statusLabel.isHidden = true
            }
            
        }
    }
    
    @IBAction func audioButton(_ sender: Any) {
        print(audioOutlet.image(for: .normal))
        if audioOutlet.image(for: .normal) == UIImage(named: "sound") && isAudioInited == true{
            DispatchQueue.main.async {
                self.audioOutlet.setImage(UIImage(named: "mute"), for: .normal)
            }
            turnPlayer.volume = 0
            getSeed.volume = 0
            putSeed.volume = 0
        } else if isAudioInited == true{
            DispatchQueue.main.async {
                self.audioOutlet.setImage(UIImage(named: "sound"), for: .normal)
            }
            turnPlayer.volume = 1
            getSeed.volume = 1
            putSeed.volume = 1
        }
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
        
        print(player2.center)
        print(player1.center)
        currentPlayerPoss = player1.center
        nextPlayerPoss = player2.center
        thisPlayer = 1
        
        multipeerSession = MPCHandeler(receivedDataHandler: receivedData)
        multipeerSession.mpcHandelerDelgate = self
        //        viewScore.layer.cornerRadius = 5
        //        viewScore.layer.masksToBounds = true
        
        //multiPeer = (UIApplication.shared.delegate as! AppDelegate).multiPeer
        
        //        lockButtonOutlet.setImage(UIImage(named: "Unlocked"), for: .normal)
        //delegate sceneView
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        // add Light
        sceneView.autoenablesDefaultLighting = false
        sceneLight = SCNLight()
        sceneLight.type = .omni
        
        let lightNode = SCNNode()
        lightNode.light = sceneLight
        lightNode.position = SCNVector3(0, 10, 2)
        
        
        // updateLabel(label: currentPlayerLabel, input: currentPlayer)
        sceneView.scene.rootNode.addChildNode(lightNode)
        
        //set Audio Button
        isAudioInited = false
        audioOutlet.isEnabled = false
        DispatchQueue.main.async {
            self.audioOutlet.setImage(UIImage(named: "unavailable sound"), for: .disabled)
        }
        
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
            //loadWorldMap(from: multiPeer.receivedData)
            
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
    func sendMapFromUserDefault(){
        sceneView.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap
                else { print("Error: \(error!.localizedDescription)"); return }
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                else { fatalError("can't encode map") }
            self.multipeerSession.sendToAllPeers(data)
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
            //            DispatchQueue.global(qos: .background).async {
            self.gameAnchor = anchor
            
            //                print(gameBoard)
            //                print(gameAnchor)
            //                print(sceneView.anchor(for: gameBoard))
            //                print(sceneView.node(for: gameAnchor))
            
            let newPosition = SCNVector3(self.gameAnchor.transform.columns.3.x, self.gameAnchor.transform.columns.3.y, self.gameAnchor.transform.columns.3.z)
            self.gameBoard.position = newPosition
            
            DispatchQueue.main.async {
                self.gameBoard.loadModel()
                self.initModel()
            }
        }
    }
// mutliplayer
//    @IBAction func multiplayer(_ sender: Any) {
//       
//        multipeerSession.sessionBrowser()
//        multipeerSession.mcBrowser.delegate = self
//        present(multipeerSession.mcBrowser, animated: false)
//    }
//    
//    @IBAction func sendWorldMap(_ sender: Any) {
//        sceneView.session.getCurrentWorldMap { worldMap, error in
//            guard let map = worldMap
//                else { print("Error: \(error!.localizedDescription)"); return }
//            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
//                else { fatalError("can't encode map") }
//            self.multipeerSession.sendToAllPeers(data)
//        }
//    }
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        thisPlayer = 2
        dismiss(animated: false, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func multiplayer(_ sender: Any) {
        //connect Button
        multipeerSession.sessionBrowser()
        multipeerSession.mcBrowser.delegate = self
        present(multipeerSession.mcBrowser, animated: false)
        
    }
    @IBAction func sendWorldMap(_ sender: Any) {
        //send Button
        sceneView.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap
                else { print("Error: \(error!.localizedDescription)"); return }
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                else { fatalError("can't encode map") }
            self.multipeerSession.sendToAllPeers(data)
        }
    }
    func addNodeAtLocation (location : CGPoint){
        guard anchors.count > 0 else{
            print("anchors are not created yet")
            return
        }
        
        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        
        if hitResults.count > 0 && boardFlag == false{
            
            let result = hitResults.first!
            let anchor = ARAnchor(name: "congklak", transform: result.worldTransform)
            sceneView.session.add(anchor: anchor)
            print("nambah anchor")
            
        }
        
    }

    func initModel(){
        //Kacang
        
        for i in 0...1{
            for j in 0...6{
                for k in 1...7{
                    //                    DispatchQueue.global().async {
                    let kacang = KacangObject()
                    kacang.loadModel()
                    kacang.position = SCNVector3Make(0, Float(k) * 0.01, 0)
                    
                    //print(kacang.position)
                    //gameNode.addChildNode(kacang)
                    self.gameBoard.holeBox[i][j].addChildNode(kacang)
                    
                    //sceneView.scene.rootNode.addChildNode(kacang)
                    //                    }
                }
                DispatchQueue.global().async {
                    self.gameBoard.holeBox[i][j].childNode(withName: "Highlight", recursively: false)?.isHidden = true
                    //                    gameNode.addChildNode(gameBoard.holeNode[i][j])
                    //                    gameNode.addChildNode(gameBoard.holeBox[i][j])
                }
            }
        }
        
        gameBoard.goalPostBoxA.childNode(withName: "Highlight", recursively: false)?.isHidden = true
        gameBoard.goalPostBoxB.childNode(withName: "Highlight", recursively: false)?.isHidden = true
        
        gameBoard.name = "gameboard"
        sceneView.scene.rootNode.addChildNode(gameBoard)
        initGame()
        
        //validate no more board should place
        boardFlag = true
        
        //remove plane
        
        let planeNode = sceneView.scene.rootNode.childNode(withName: "titikPlane", recursively: false)
        planeNode?.removeFromParentNode()
        
    }

// MARK: - send world Map
    func sendWorldMapData(_ worldData : Data!){
        if multipeerSession.session.connectedPeers.count > 0 {
            do{
                try multipeerSession.session.send(worldData, toPeers: multipeerSession.session.connectedPeers, with: .reliable)
            }catch{
                fatalError("could not send world data")
            }
        }else{print("not connected to any device")}
    }
// mengolah data
    func receivedData(_ data: Data, from peer: MCPeerID) {
        do {
            print(data)
            if let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) {
                // Run the session with the received world map.
                let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = .horizontal
                configuration.initialWorldMap = worldMap
                sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
                
                print("ini dapet world map")
            }
                //                if let anchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARAnchor.self, from: data) {
                //                    // Add anchor to the session, ARSCNView delegate adds visible content.
                //                    sceneView.session.add(anchor: anchor)
                //                    print("ini dapet anchor")
                //                }
            else {
                print("unknown data recieved from \(peer)")
            }
        } catch {
            print("can't decode dataWorldMap recieved from \(peer)")
        }
        do {
            let recivedData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            print(recivedData)
            let lubang:String! = recivedData.object(forKey: "lubang") as! String
            let playerSekarang:String! = recivedData.object(forKey: "player") as! String
            let curPlayer : Int = Int(playerSekarang)!
            print("lubang yang terpilih \(lubang!)")
            print("current player \(curPlayer)")
            let currLubang:String = lubang!
            receiveSelectedHole(namaLubang: currLubang)
        } catch  {
            print("data ga bisa diolah")
        }
        
        //        if let loadedData = UserDefaults().data(forKey: "name") {
        //            if let loadedPerson = NSKeyedUnarchiver.unarchiveObject(with: data) as? NamaLubang {
        //                print(loadedPerson)
        //                loadedPerson
        //                print("\(loadedPerson.name!)")
        //                print("kacang berhasil deterima")
        //            }
        //        }
    }

//    func loadWorldMap(from archivedData: Data) {
//        do {
//            let uncompressedData = try archivedData.decompressed()
//            if let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: uncompressedData) {
//                // Run the session with the received world map.
//                let configuration = ARWorldTrackingConfiguration()
//                configuration.planeDetection = .horizontal
//                configuration.initialWorldMap = worldMap
//                sceneView?.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
//            }
//            else
//                if let anchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARAnchor.self, from: uncompressedData) {
//                    // Add anchor to the session, ARSCNView delegate adds visible content.
//                    sceneView.session.add(anchor: anchor)
//                }else{
//                    print("fail")
//            }
//        } catch {
//            DispatchQueue.main.async {
//                print("error load map")
//            }
//        }
//    }

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
}
    
extension GameplayViewController: MPCHandelerDelegate{
    func terserahLu() {
        sendMapFromUserDefault()
    }
}

extension GameplayViewController : ARSessionDelegate{
//    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        for i in 0...1{
//            for j in 0...6{
//                if gameAnchor != nil{
//                    guard let textNode = gameBoard.holeBox[i][j].childNode(withName: "SumBeanNode", recursively: false) else {
//                        return
//                    }
//                    textNode.look(at: (sceneView.pointOfView?.position)!)
//                }else{
//                    break
//                }
//            }
//        }
//    }

}
