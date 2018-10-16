//
//  GameplayVC + Gameplay.swift
//  MC 3
//
//  Created by Yosua Hoo on 19/09/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import AVFoundation

extension GameplayViewController {
    
    
    
    @objc func tapped (tapRecognizer : UITapGestureRecognizer){
        let location = tapRecognizer.location(in: sceneView)
        
        //print(location)
        //when board hasn't delploy
        if boardFlag == false {
            addNodeAtLocation(location: location)
        }else{
            //when board already deployed
            print("curPlayer : \(currentPlayer),thisPlayer : \(thisPlayer)")
            let selectedHole = chooseHoleToGetBean(location: location)
            if (selectedHole != nil && isGameOver == false && isPaused == false){
                if isMultipeer == true{
                    if currentPlayer == thisPlayer{
                        sendSelectedHole(parentNode: selectedHole!)
                        validateSelectedHole(selectedHole: selectedHole!)
                    }
                }else{
                    validateSelectedHole(selectedHole: selectedHole!)
                }
            }
            
            DispatchQueue.main.async {
                self.updateLabel(label: self.currentBeanInHandLabel, input: self.counterHand)
            }
            //print("\(counterHand),\(indexHoleColumn)|\(indexHoleRow)")
        }
    }
    
    func validateSelectedHole(selectedHole : SCNNode){
        if counterHand == 0 {
            //ditangan kosong ambil terserah
            freeWillPick(parentNode: selectedHole, currentPlayer: currentPlayer)
        }else if counterHand == 1{
            //last Biji in Hand
            curPlayerTime += 1
            if indexHoleColumn == currentPlayer - 1{//ditempat dia sendiri
                if indexHoleRow == 7{
                    addToGoalPost(selectedHole: selectedHole)//add di Goal Post
                }else if indexHoleRow < 7{
                    if selectedHole.name == gameBoard.holeBox[indexHoleColumn][indexHoleRow].name {
                        if checkIfEmpty(parentNode: selectedHole) == false{
                            //jatuh di tempat sendiri, gak kosong
                            addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], style: .light)
                            takeBeanToHand(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], currentPlayer: currentPlayer)
                            indexHoleRow += 1
                            //temporary
                            if indexHoleRow == 7{
                                if indexHoleColumn == 0{
                                    updateNextHighlight(beforeNode: selectedHole, nextNode: gameBoard.goalPostBoxA)
                                }else if indexHoleColumn == 1{
                                    updateNextHighlight(beforeNode: selectedHole, nextNode: gameBoard.goalPostBoxB)
                                }
                            }else{
                                updateNextHighlight(beforeNode: selectedHole, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                            }
                        }else{
                            // TEMBAKKK
                            if curPlayerTime > 8 {
                                print(curPlayerTime)
                                addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], style: .light)
                                var enemyHoleColumn : Int = 0
                                if indexHoleColumn == 1 {
                                    enemyHoleColumn = 0
                                }else{
                                    enemyHoleColumn = 1
                                }
                                if checkIfEmpty(parentNode: gameBoard.holeBox[enemyHoleColumn][6-indexHoleRow]) == false{
                                    tembak(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], indexEnemyColumn: enemyHoleColumn, curPlayer: currentPlayer)
                                }
                                clearHighlight(parentNode: selectedHole)
                                changePlayer(isFromTembak: true)
                            }else{
                                addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], style: .light)
                                clearHighlight(parentNode: selectedHole)
                                changePlayer(isFromTembak: false)
                            }
                        }
                    }
                }
            }else{
                //jatuh di tempat musuh
                if indexHoleRow < 7{
                    if selectedHole.name == gameBoard.holeBox[indexHoleColumn][indexHoleRow].name{
                        if checkIfEmpty(parentNode: selectedHole) == false{
                            //gak Kosong, ambil punya musuh
                            addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], style: .light)
                            takeBeanToHand(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], currentPlayer:     currentPlayer)
                            indexHoleRow += 1
                            
                            if indexHoleRow == 7{
                                indexHoleRow = 0
                                if indexHoleColumn == 0{
                                    indexHoleColumn = 1
                                }else if indexHoleColumn == 1{
                                    indexHoleColumn = 0
                                }
                            }
                            updateNextHighlight(beforeNode: selectedHole, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                        }else{
                            //Kosong, ganti Player
                            addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], style: .light)
                            clearHighlight(parentNode: selectedHole)
                            changePlayer(isFromTembak: false)
                        }
                    }
                }else if indexHoleRow == 7{
                    //next target lubang pertama tempat kita
                    if selectedHole.name == gameBoard.holeBox[currentPlayer-1][0].name{
                        addKacang(parentNode: gameBoard.holeBox[currentPlayer-1][0], style: .light)
                        takeBeanToHand(parentNode: gameBoard.holeBox[currentPlayer-1][0], currentPlayer:currentPlayer)
                        indexHoleRow = 0
                        indexHoleRow += 1
                        indexHoleColumn = currentPlayer-1
                        updateNextHighlight(beforeNode: selectedHole, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                    }
                }
            }
        }else{
            curPlayerTime += 1
            if currentPlayer == 1{
                //player 1 turn
                if indexHoleRow == 7 && indexHoleColumn == 0{
                    if  selectedHole.name == gameBoard.goalPostBoxA.name {
                        //jatuh di goalPost kita
                        addToGoalPostA(parentNode: gameBoard.goalPostBoxA)
                        updateNextHighlight(beforeNode: selectedHole, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                    }
                }else if indexHoleRow == 7 && indexHoleColumn == 1{
                    if selectedHole.name == gameBoard.holeBox[0][0].name{
                        //berada di hole terakhir sbelum goalPost musuh, nextTarget ke hole kita (skip goalPost musuh)
                        addKacang(parentNode: gameBoard.holeBox[0][0], style: .light)
                        indexHoleColumn = 0
                        indexHoleRow = 1
                        updateNextHighlight(beforeNode: selectedHole, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                    }
                }else if indexHoleRow < 7 {
                    if  selectedHole.name == gameBoard.holeBox[indexHoleColumn][indexHoleRow].name {
                        //default Run
                        addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], style : .light)
                        indexHoleRow += 1
                        if(indexHoleRow == 7){
                            if indexHoleColumn == 0{
                                updateNextHighlight(beforeNode: selectedHole, nextNode: gameBoard.goalPostBoxA)
                            }else if indexHoleColumn == 1{
                                updateNextHighlight(beforeNode: selectedHole, nextNode: gameBoard.holeBox[0][0])
                            }
                        }else{
                            updateNextHighlight(beforeNode: selectedHole, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                        }
                    }
                }
            }else if currentPlayer == 2{
                //player 2 turn
                
                if  indexHoleRow == 7 && indexHoleColumn == 1{
                    if selectedHole.name == gameBoard.goalPostBoxB.name{
                        //jatuh di goalPost kita
                        addToGoalPostB(parentNode: gameBoard.goalPostBoxB)
                        updateNextHighlight(beforeNode: selectedHole, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                    }
                }else if indexHoleColumn == 0 && indexHoleRow == 7{
                    if  selectedHole.name == gameBoard.holeBox[1][0].name{
                        //berada di hole terakhir sbelum goalPost musuh, nextTarget hole kita (skip goalPost musuh)
                        addKacang(parentNode: gameBoard.holeBox[1][0], style: .light)
                        indexHoleColumn = 1
                        indexHoleRow = 1
                        updateNextHighlight(beforeNode: selectedHole, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                    }
                }else if indexHoleRow < 7{
                    if selectedHole.name == gameBoard.holeBox[indexHoleColumn][indexHoleRow].name{
                        //default Run
                        addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow],style: .light)
                        indexHoleRow += 1
                        
                        if(indexHoleRow == 7){
                            if indexHoleColumn == 1{
                                updateNextHighlight(beforeNode: selectedHole, nextNode: gameBoard.goalPostBoxB)
                            }else if indexHoleColumn == 0{
                                updateNextHighlight(beforeNode: selectedHole, nextNode: gameBoard.holeBox[1][0])
                            }
                        }else{
                            updateNextHighlight(beforeNode: selectedHole, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                        }
                    }
                }
            }
        }
    }
    
    func tembak(parentNode : SCNNode, indexEnemyColumn : Int, curPlayer : Int){
        takeBeanToHand(parentNode: parentNode, currentPlayer: curPlayer)
        takeBeanToHand(parentNode: gameBoard.holeBox[indexEnemyColumn][6-indexHoleRow], currentPlayer: curPlayer)
        
        if curPlayer == 1{
            while counterHand != 0 {
                addKacang(parentNode: gameBoard.goalPostBoxA, style: .heavy)
                counterA += 1
            }
            DispatchQueue.main.async {
                 self.updateLabel(label: self.scoreALabel, input: self.counterA)
            }
        }else if curPlayer == 2{
            while counterHand != 0 {
                addKacang(parentNode: gameBoard.goalPostBoxB, style: .heavy)
                counterB += 1
            }
            DispatchQueue.main.async {
                self.updateLabel(label: self.scoreBLabel, input: self.counterB)
            }
        }
        DispatchQueue.main.async {
            self.updateStringLabel(label: self.statusLabel, input: "Berhasil Tembak")
            let timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.tungguGantiLabel), userInfo: nil, repeats: false)
        }
    }
    
    func checkIfEmpty(parentNode : SCNNode) -> Bool{
        var count = 0
        for child in parentNode.childNodes{
            if child.name == nil{
                count += 1
            }
        }
        
        if count == 0{
            return true
        }else{
            return false
        }
    }
    
    func freeWillPick(parentNode : SCNNode, currentPlayer : Int){
        var flag = false
        
        for j in 0...6{
            if parentNode.name == gameBoard.holeBox[currentPlayer-1][j].name{
                indexHoleColumn = currentPlayer-1
                indexHoleRow = j+1
                takeBeanToHand(parentNode: parentNode, currentPlayer: currentPlayer)
                heptic(style: .heavy)
                
                if counterHand != 0{
                    flag = true
                }
                
                if flag == true{
                    for i in 0...6{
                        clearHighlight(parentNode: gameBoard.holeBox[currentPlayer-1][i])
                    }
                    
                    if(indexHoleRow == 7){
                        if indexHoleColumn == 0{
                            updateNextHighlight(beforeNode: parentNode, nextNode: gameBoard.goalPostBoxA)
                        }else if indexHoleColumn == 1{
                            updateNextHighlight(beforeNode: parentNode, nextNode: gameBoard.goalPostBoxB)
                        }
                    }else{
                        updateNextHighlight(beforeNode: parentNode, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                    }
                    DispatchQueue.main.async {
                        //self.destroyIndicatorBean()
                        self.updateStringLabel(label: self.statusLabel, input: "Biji berhasil diambil!\nLetakkan biji satu persatu sesuai urutan")
                    }
                    break
                }
            }
        }
    }
    
    func takeBeanToHand(parentNode : SCNNode, currentPlayer : Int){
        DispatchQueue.main.async {
            self.updateIndicatorBean()
        }
        
        self.getSeed.play()
        for child in parentNode.childNodes{
            //print(child.name)
            if child.name == nil{
                counterHand += 1
                child.removeFromParentNode()
            }
        }
    }
    
    // MARK: tambah kacang
    func addKacang(parentNode : SCNNode, style : UIImpactFeedbackStyle){
        let kacang = KacangObject()
        heptic(style: style)
        
        DispatchQueue.main.async {

            self.updateStringLabel(label: self.statusLabel, input: "Letakkan biji satu persatu sesuai urutan")
        }
        
        kacang.loadModel()
        kacang.position = SCNVector3Make(0, 0, 0)
        counterHand -= 1
        parentNode.addChildNode(kacang)
        if putSeed.isPlaying == true{
            putSeed.currentTime = 0
        }else {
            putSeed.play()
        }
        

//        var newPerson = [NamaLubang]()
//
//        //add some values into custom class.
//        newPerson.append(NamaLubang(name: nama, age: 45))
//        let newPerson = NamaLubang(name: nama, age: 0)
//
//
//
//        //store you class object into NSUserDefaults.
//        let personData = NSKeyedArchiver.archivedData(withRootObject: newPerson)
//        UserDefaults().set(personData, forKey: "personData")
        
//        multipeerSession.sendToAllPeers(personData)
//
//        let willSendObject = NamaLubang(name: nama)
//        do {
//            let data = try? NSKeyedArchiver.archivedData(withRootObject: willSendObject, requiringSecureCoding: true)
//        } catch {
//            print("error archived Data")
//        }
        
//        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: nodeKacang, requiringSecureCoding: true)
//            else { fatalError("can't encode node") }
//
    }
    
    // MARK: send Selected Hole to MultiPeer
    func sendSelectedHole(parentNode : SCNNode){
        guard let nama = parentNode.name else {
            return print("fail to get name")
        }
        
        print(nama)
        let messengaDic = ["lubang" : nama , "player" : String(currentPlayer)]
        
        guard let messageData = try? JSONSerialization.data(withJSONObject: messengaDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            else {fatalError("cant encode node")}
        multipeerSession.sendToAllPeers(messageData)
        print("data ini sudah dikirim \(messageData)")
    }
    
    // MARK: received Data add Kacang to selected Hole
    func receiveSelectedHole(namaLubang: String){
        print(namaLubang)
        if namaLubang == gameBoard.goalPostBoxA.name{
            validateSelectedHole(selectedHole: gameBoard.goalPostBoxA)
        }else if namaLubang == gameBoard.goalPostBoxB.name{
            validateSelectedHole(selectedHole: gameBoard.goalPostBoxB)
        }else{
            for i in 0...1{
                for j in 0...6{
                    if namaLubang == gameBoard.holeBox[i][j].name{
                        validateSelectedHole(selectedHole: gameBoard.holeBox[i][j])
                        break
                    }
                }
            }
        }
    }
    
    func chooseHoleToGetBean (location : CGPoint) -> SCNNode?{
        //SCNHitTestOption -> coba diubah" dipelajari
        //[.boundingBox : true]
        let hitTestOptions : [SCNHitTestOption : Any] = [.categoryBitMask : 3]
        let hitResults = sceneView!.hitTest(location, options: hitTestOptions)
        
        return hitResults.lazy.compactMap { result in
            guard let node = result.node.parent as? SCNNode? else {return nil}
            return node
        }.first
    }
    
    func changePlayer (isFromTembak : Bool){
        curPlayerTime = 0
        
        DispatchQueue.main.async {
            self.updateIndicatorBean()
            self.switchPlayer()
            if isFromTembak == false{
                self.updateStringLabel(label: self.statusLabel, input: "Giliran P\(self.currentPlayer)\nAmbil biji di lubang yang sudah ditandai")
            }
        }
        
        if currentPlayer == 1{
            currentPlayer = 2
            //updateLabel(label: currentPlayerLabel, input: currentPlayer)
        }else{
            currentPlayer = 1
            //updateLabel(label: currentPlayerLabel, input: currentPlayer)
        }
        print(currentPlayer)
        DispatchQueue.main.async {
            self.highlightZeroInHand()
        }
        turnPlayer.play()
    }

    
    func updateLabel(label : UILabel, input : Int){
        label.text = String(input)
    }
    
    func updateStringLabel(label : UILabel, input : String){
        label.text = input
    }
    
    func addToGoalPost(selectedHole : SCNNode){
        if currentPlayer == 1 && selectedHole.name == gameBoard.goalPostBoxA.name{
            //Goal Post player 1
            addKacang(parentNode: gameBoard.goalPostBoxA, style: .heavy )
            counterA += 1
            DispatchQueue.main.async {
                self.clearHighlight(parentNode: selectedHole)
                self.highlightZeroInHand()
                self.updateLabel(label: self.scoreALabel, input: self.counterA)
            }
        }else if currentPlayer == 2 && selectedHole.name == gameBoard.goalPostBoxB.name{
            //Goal Post Player 2
            addKacang(parentNode: gameBoard.goalPostBoxB, style: .heavy )
            counterB += 1
            DispatchQueue.main.async {
                self.clearHighlight(parentNode: selectedHole)
                self.highlightZeroInHand()
                self.updateLabel(label: self.scoreBLabel, input: self.counterB)
            }
        }
    }
    
    func addToGoalPostA(parentNode : SCNNode){
        addKacang(parentNode: parentNode, style: .heavy)
        indexHoleColumn = 1
        indexHoleRow = 0
        counterA += 1
        DispatchQueue.main.async {
            self.updateLabel(label: self.scoreALabel, input: self.counterA)
        }
        
    }
    
    func addToGoalPostB(parentNode : SCNNode){
        addKacang(parentNode: parentNode, style: .heavy)
        indexHoleColumn = 0
        indexHoleRow = 0
        counterB += 1
        DispatchQueue.main.async {
            self.updateLabel(label: self.scoreBLabel, input: self.counterB)
        }
    }
    
    func heptic(style : UIImpactFeedbackStyle){
        let hepticFeedback = UIImpactFeedbackGenerator(style: style)
        hepticFeedback.prepare()
        DispatchQueue.main.async {
            hepticFeedback.impactOccurred()
        }
    }
    
    func updateNextHighlight(beforeNode : SCNNode, nextNode : SCNNode){
        DispatchQueue.main.async {
            self.updateIndicatorBean()
        }
        
        if counterHand == 0{
            DispatchQueue.main.async {
                self.highlightZeroInHand()
            }
        }else{
            clearHighlight(parentNode: beforeNode)
            let highlight = nextNode.childNode(withName: "Highlight", recursively: false)
            highlight?.isHidden = false
            if currentPlayer == 1{
                highlight?.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 90/255, green: 140/255, blue: 255/255, alpha: 1)
            }else if currentPlayer == 2{
                highlight?.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            }
            print(nextNode.name)
        }
    }
    
    func clearHighlight(parentNode : SCNNode){
        parentNode.childNode(withName: "Highlight", recursively: false)?.isHidden = true
    }
    
    func highlightZeroInHand(){
        checkGameOver()
        if isGameOver == false {
            for i in 0...6{
                //clearHighlight(parentNode: gameBoard.holeBox[currentPlayer-1][i])
                if gameBoard.holeBox[currentPlayer-1][i].childNodes.count != 8{
                    let highlight = gameBoard.holeBox[currentPlayer-1][i].childNode(withName: "Highlight", recursively: false)
                    highlight?.isHidden = false
                    if currentPlayer == 1{
                        highlight?.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 90/255, green: 140/255, blue: 255/255, alpha: 1)
                    }else if currentPlayer == 2{
                        highlight?.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                    }
                }
            }
        }
    }
    
    func setAudioTurnChange(){
        let musicFile = Bundle.main.path(forResource: "Turn Change", ofType: ".wav")

        do {
            try turnPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicFile!))
        }catch  {
            print("audio error")
        }
        
    }
    
    func setAudioPutSeed(){
        let musicFile = Bundle.main.path(forResource: "Put Seed", ofType: ".aiff")
        
        do{
            try putSeed = AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicFile!))
        }catch {
            print("audio error")
        }
    }
    
    func setAudioAmbilBiji(){
        let musicFile = Bundle.main.path(forResource: "ambilBiji", ofType: ".mp3")
        
        do {
            try getSeed = AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicFile!))
        } catch {
            print("audio error")
        }
    }
    
    func checkOneSideEmpty() -> Bool{
        var counterPlayerA : Int = 0
        var counterPlayerB : Int = 0
        for i in 0...6{
            if gameBoard.holeBox[0][i].childNodes.count == 8{
                counterPlayerA += 1
            }
            if gameBoard.holeBox[1][i].childNodes.count == 8{
                counterPlayerB += 1
            }
        }
        if counterPlayerA == 7{
            for index in 0...6{
                takeBeanToHand(parentNode: gameBoard.holeBox[1][index], currentPlayer: 2)
            }
            while counterHand != 0 {
                addKacang(parentNode: gameBoard.goalPostBoxB, style: .heavy)
                counterB += 1
            }
            DispatchQueue.main.async {
                self.updateLabel(label: self.scoreBLabel, input: self.counterB)
            }
            return true
        }else if counterPlayerB == 7 {
            for index in 0...6{
                takeBeanToHand(parentNode: gameBoard.holeBox[0][index], currentPlayer: 1)
            }
            while counterHand != 0 {
                addKacang(parentNode: gameBoard.goalPostBoxA, style: .heavy)
                counterA += 1
            }
            DispatchQueue.main.async {
                self.updateLabel(label: self.scoreALabel, input: self.counterA)
            }
            return true
        }else{
            return false
        }
    }
    
    func checkGameOver(){
        if checkOneSideEmpty() == true{
            //make game cannot be played
            isGameOver = true
    
            if counterA > counterB{
                DispatchQueue.main.async {
                    self.animationMenang(curPlayer: 1)
                    self.updateStringLabel(label: self.statusLabel, input: "P1 Menang")
                }
            }else if counterB > counterA{
                DispatchQueue.main.async {
                    self.animationMenang(curPlayer: 2)
                    self.updateStringLabel(label: self.statusLabel, input: "P2 Menang")
                }
            }else{
                //Draw
                DispatchQueue.main.async {
                    self.updateStringLabel(label: self.statusLabel, input: "Seri!")
                }
            }
        }
    }
    
    func initGame(){
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.success)
        isGameOver = false
        isPaused = false
        isAudioInited = true
        highlightZeroInHand()
        audioOutlet.isEnabled = true
        
        DispatchQueue.main.async {
            self.audioOutlet.setImage(UIImage(named: "sound"), for: .normal)
            self.updateStringLabel(label: self.statusLabel, input: "Papan Congklak muncul!")
            let timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.tungguGantiLabel), userInfo: nil, repeats: false)
            self.createIndicatorBean()
            self.switchPlayer()
        }
        setAudioPutSeed()
        setAudioAmbilBiji()
        setAudioTurnChange()
    }
    
    @objc func tungguGantiLabel(){
        DispatchQueue.main.async {
            self.updateStringLabel(label: self.statusLabel, input: "Giliran P\(self.currentPlayer)\nAmbil biji di lubang yang sudah ditandai")
        }
    }
    
    func hideIndicatorBean(){
        for i in 0...1{
            for j in 0...6{
                let txtNode = gameBoard.holeBox[i][j].childNode(withName: "SumBeanNode", recursively: false)
                txtNode?.isHidden = true
            }
        }
    }
    
    func showIndicatorBean(){
        for i in 0...1{
            for j in 0...6{
                let txtNode = gameBoard.holeBox[i][j].childNode(withName: "SumBeanNode", recursively: false)
                txtNode?.isHidden = false
            }
        }
    }

    func updateIndicatorBean(){
        for i in 0...1{
            for j in 0...6{
                var counterBean = 0
                for child in gameBoard.holeBox[i][j].childNodes{
                    if child.name == nil{
                        counterBean += 1
                    }
                    let txtNode = gameBoard.holeBox[i][j].childNode(withName: "SumBeanNode", recursively: false)
                    if i == 0{
                        txtNode!.geometry = createSCNTextforNumberBean(value: counterBean, color: UIColor(red: 90/255, green: 140/255, blue: 255/255, alpha: 1))
                    }else{
                        txtNode!.geometry = createSCNTextforNumberBean(value: counterBean, color: UIColor.red)
                    }
                }
            }
        }
    }
    
    func createSCNTextforNumberBean(value : Int, color : UIColor) -> SCNText{
        var txtNote = SCNText()
        txtNote.string = String(value)
        txtNote.font = UIFont.systemFont(ofSize: 3)
        //txtNote.font = UIFont.init(name: "Yuanti SC", size: 255)
        txtNote.extrusionDepth = 0.2
        txtNote.materials.first?.diffuse.contents = color.withAlphaComponent(0.6)
        //txtNote.containerFrame = CGRect(x: 0, y: 0.05, width: 200, height: 200)
        txtNote.isWrapped = true
        txtNote.alignmentMode = kCAAlignmentCenter
        
        return txtNote
    }
    
    func createIndicatorBean(){
        //let beanView = UIView()
        
        for i in 0...1{
            for j in 0...6{
                var counterBean = 0
                for child in gameBoard.holeBox[i][j].childNodes{
                    if child.name == nil{
                        counterBean += 1
                    }
                }
                let txtNode = SCNNode()
                if i == 0{
                    //txtNode.position = SCNVector3(-0.05, 0.015, -0.005) kalau p2 gak pake -
                    txtNode.geometry = createSCNTextforNumberBean(value: counterBean, color: UIColor(red: 90/255, green: 140/255, blue: 255/255, alpha: 1))
                    txtNode.position = SCNVector3(-0.025,0.015,-0.01)
                    txtNode.eulerAngles = SCNVector3(0,67.5,67.5)
                }else{
                    txtNode.geometry = createSCNTextforNumberBean(value: counterBean, color: UIColor.red)
                    txtNode.position = SCNVector3(0.025,0.015,0.01)
                    txtNode.eulerAngles = SCNVector3(0,-67.5,-67.5)
                }
                
                txtNode.name = "SumBeanNode"
                txtNode.scale = SCNVector3(0.01, 0.01, 0.01)
                //txtNode.look(at: (sceneView.pointOfView?.position)!)
                gameBoard.holeBox[i][j].addChildNode(txtNode)
            }
        }
    }
    
    func destroyIndicatorBean(){
        for i in 0...1{
            for j in 0...6{
                for child in gameBoard.holeBox[i][j].childNodes{
                    if child.name == "SumBeanNode"{
                        child.removeFromParentNode()
                    }
                }
            }
        }
    }
    
}
