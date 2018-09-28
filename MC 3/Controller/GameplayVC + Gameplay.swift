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
            let selectedHole = chooseHoleToGetBean(location: location)
            if (selectedHole != nil && isGameOver == false){
                if counterHand == 0 {
                    //ditangan kosong ambil terserah
                    freeWillPick(parentNode: selectedHole!, currentPlayer: currentPlayer)
                }else if counterHand == 1{
                    //last Biji in Hand
                    curPlayerTime += 1
                    if indexHoleColumn == currentPlayer - 1{//ditempat dia sendiri
                        if indexHoleRow == 7{
                            addToGoalPost(selectedHole: selectedHole!)//add di Goal Post
                        }else if indexHoleRow < 7{
                            if selectedHole!.name == gameBoard.holeBox[indexHoleColumn][indexHoleRow].name {
                                if checkIfEmpty(parentNode: selectedHole!) == false{
                                    //jatuh di tempat sendiri, gak kosong
                                    addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], style: .light)
                                    takeBeanToHand(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], currentPlayer: currentPlayer)
                                    indexHoleRow += 1
                                    //temporary
                                    if indexHoleRow == 7{
                                        if indexHoleColumn == 0{
                                            updateNextHighlight(beforeNode: selectedHole!, nextNode: gameBoard.goalPostBoxA)
                                        }else if indexHoleColumn == 1{
                                            updateNextHighlight(beforeNode: selectedHole!, nextNode: gameBoard.goalPostBoxB)
                                        }
                                    }else{
                                        updateNextHighlight(beforeNode: selectedHole!, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
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
                                        clearHighlight(parentNode: selectedHole!)
                                        changePlayer(isFromTembak: true)
                                    }
                                }
                            }
                        }
                    }else{
                        //jatuh di tempat musuh
                        if indexHoleRow < 7{
                            if selectedHole!.name == gameBoard.holeBox[indexHoleColumn][indexHoleRow].name{
                                if checkIfEmpty(parentNode: selectedHole!) == false{
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
                                    updateNextHighlight(beforeNode: selectedHole!, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                                }else{
                                    //Kosong, ganti Player
                                    addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], style: .light)
                                    clearHighlight(parentNode: selectedHole!)
                                    changePlayer(isFromTembak: false)
                                }
                            }
                        }else if indexHoleRow == 7{
                            //next target lubang pertama tempat kita
                            if selectedHole!.name == gameBoard.holeBox[currentPlayer-1][0].name{
                                addKacang(parentNode: gameBoard.holeBox[currentPlayer-1][0], style: .light)
                                takeBeanToHand(parentNode: gameBoard.holeBox[currentPlayer-1][0], currentPlayer:currentPlayer)
                                indexHoleRow = 0
                                indexHoleRow += 1
                                indexHoleColumn = currentPlayer-1
                                updateNextHighlight(beforeNode: selectedHole!, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                            }
                        }
                    }
                }else{
                    curPlayerTime += 1
                    if currentPlayer == 1{
                        //player 1 turn
                        if indexHoleRow == 7 && indexHoleColumn == 0{
                            if  selectedHole!.name == gameBoard.goalPostBoxA.name {
                                //jatuh di goalPost kita
                                addToGoalPostA(parentNode: gameBoard.goalPostBoxA)
                                updateNextHighlight(beforeNode: selectedHole!, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                            }
                        }else if indexHoleRow == 7 && indexHoleColumn == 1{
                            if selectedHole!.name == gameBoard.holeBox[0][0].name{
                                //berada di hole terakhir sbelum goalPost musuh, nextTarget ke hole kita (skip goalPost musuh)
                                addKacang(parentNode: gameBoard.holeBox[0][0], style: .light)
                                indexHoleColumn = 0
                                indexHoleRow = 1
                                updateNextHighlight(beforeNode: selectedHole!, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                            }
                        }else if indexHoleRow < 7 {
                            if  selectedHole!.name == gameBoard.holeBox[indexHoleColumn][indexHoleRow].name {
                                //default Run
                                addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], style : .light)
                                indexHoleRow += 1
                                if(indexHoleRow == 7){
                                    if indexHoleColumn == 0{
                                        updateNextHighlight(beforeNode: selectedHole!, nextNode: gameBoard.goalPostBoxA)
                                    }else if indexHoleColumn == 1{
                                        updateNextHighlight(beforeNode: selectedHole!, nextNode: gameBoard.holeBox[0][0])
                                    }
                                }else{
                                    updateNextHighlight(beforeNode: selectedHole!, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                                }
                            }
                        }
                    }else if currentPlayer == 2{
                        //player 2 turn
                   
                        if  indexHoleRow == 7 && indexHoleColumn == 1{
                            if selectedHole!.name == gameBoard.goalPostBoxB.name{
                                //jatuh di goalPost kita
                                addToGoalPostB(parentNode: gameBoard.goalPostBoxB)
                                updateNextHighlight(beforeNode: selectedHole!, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                            }
                        }else if indexHoleColumn == 0 && indexHoleRow == 7{
                            if  selectedHole!.name == gameBoard.holeBox[1][0].name{
                                //berada di hole terakhir sbelum goalPost musuh, nextTarget hole kita (skip goalPost musuh)
                                addKacang(parentNode: gameBoard.holeBox[1][0], style: .light)
                                indexHoleColumn = 1
                                indexHoleRow = 1
                                updateNextHighlight(beforeNode: selectedHole!, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                            }
                        }else if indexHoleRow < 7{
                            if selectedHole!.name == gameBoard.holeBox[indexHoleColumn][indexHoleRow].name{
                                //default Run
                                addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow],style: .light)
                                indexHoleRow += 1
                            
                                if(indexHoleRow == 7){
                                    if indexHoleColumn == 1{
                                        updateNextHighlight(beforeNode: selectedHole!, nextNode: gameBoard.goalPostBoxB)
                                    }else if indexHoleColumn == 0{
                                        updateNextHighlight(beforeNode: selectedHole!, nextNode: gameBoard.holeBox[1][0])
                                    }
                                }else{
                                    updateNextHighlight(beforeNode: selectedHole!, nextNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                                }
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.updateLabel(label: self.currentBeanInHandLabel, input: self.counterHand)
            }
            print("\(counterHand),\(indexHoleColumn)|\(indexHoleRow)")
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
                        self.updateStringLabel(label: self.statusLabel, input: "Biji berhasil diambil!\nLetakkan biji satu persatu sesuai urutan")
                    }
                    break
                }
            }
        }
    }
    
    func takeBeanToHand(parentNode : SCNNode, currentPlayer : Int){
        getSeed.play()
        for child in parentNode.childNodes{
            //print(child.name)
            if child.name == nil{
                counterHand += 1
                child.removeFromParentNode()
            }
        }
    }
    
    
    func addKacang(parentNode : SCNNode, style : UIImpactFeedbackStyle){
        let kacang = KacangObject()
        DispatchQueue.main.async {
            self.updateStringLabel(label: self.statusLabel, input: "Letakkan biji satu persatu sesuai urutan")
        }
        heptic(style: style)
        kacang.loadModel()
        kacang.position = SCNVector3Make(0, 0, 0)
        counterHand -= 1
        parentNode.addChildNode(kacang)
        if putSeed.isPlaying == true{
            putSeed.currentTime = 0
        }else {
            putSeed.play()
        }
        
        
    }
    
    func chooseHoleToGetBean (location : CGPoint) -> SCNNode?{
        //SCNHitTestOption -> coba diubah" dipelajari
        //[.boundingBox : true]
        let hitTestOptions : [SCNHitTestOption : Any] = [.categoryBitMask : 3]
        let hitResults = sceneView.hitTest(location, options: hitTestOptions)
        
        return hitResults.lazy.compactMap { result in
            guard let node = result.node.parent as? SCNNode? else {return nil}
            return node
        }.first
    }
    
    func changePlayer (isFromTembak : Bool){
        curPlayerTime = 0
      
        DispatchQueue.main.async {
            self.switchPlayer()
            if isFromTembak == false{
                self.updateStringLabel(label: self.statusLabel, input: "Giliran P\(self.currentPlayer)\nAmbil biji di lubang yang sudah ditandai")
            }
        }

        
        checkGameOver()
        if currentPlayer == 1{
            currentPlayer = 2
            //updateLabel(label: currentPlayerLabel, input: currentPlayer)
        }else{
            currentPlayer = 1
            //updateLabel(label: currentPlayerLabel, input: currentPlayer)
        }
        print(currentPlayer)
        highlightZeroInHand()
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
            clearHighlight(parentNode: selectedHole)
            highlightZeroInHand()
            DispatchQueue.main.async {
                self.updateLabel(label: self.scoreALabel, input: self.counterA)
            }
            
        }else if currentPlayer == 2 && selectedHole.name == gameBoard.goalPostBoxB.name{
            //Goal Post Player 2
            addKacang(parentNode: gameBoard.goalPostBoxB, style: .heavy )
            counterB += 1
            clearHighlight(parentNode: selectedHole)
            highlightZeroInHand()
            DispatchQueue.main.async {
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
        hepticFeedback.impactOccurred()
    }
    
    func updateNextHighlight(beforeNode : SCNNode, nextNode : SCNNode){
        if counterHand == 0{
            highlightZeroInHand()
        }else{
            clearHighlight(parentNode: beforeNode)
            nextNode.childNode(withName: "Highlight", recursively: false)?.isHidden = false
            print(nextNode.name)
        }
    }
    
    func clearHighlight(parentNode : SCNNode){
        parentNode.childNode(withName: "Highlight", recursively: false)?.isHidden = true
    }
    
    func highlightZeroInHand(){
        for i in 0...6{
            if gameBoard.holeBox[currentPlayer-1][i].childNodes.count != 7{
                gameBoard.holeBox[currentPlayer-1][i].childNode(withName: "Highlight", recursively: false)?.isHidden = false
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
    
    func setAudioGetSeed(){
        let musicFile = Bundle.main.path(forResource: "ambilBiji", ofType: ".mp3")
        do{
            try getSeed = AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicFile!))
        }catch {
            print("audio error")
        }
    }
    
    func checkOneSideEmpty() -> Bool{
        var counterPlayerA : Int = 0
        var counterPlayerB : Int = 0
        for i in 0...6{
            if gameBoard.holeBox[0][i].childNodes.count == 7{
                counterPlayerA += 1
            }
            if gameBoard.holeBox[1][i].childNodes.count == 7{
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
            
            if counterA != counterB{
                DispatchQueue.main.async {
                    self.updateStringLabel(label: self.statusLabel, input: "P\(self.currentPlayer) Menang")
                }
            }else{
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
        setAudioPutSeed()
        setAudioTurnChange()
        setAudioGetSeed()
        highlightZeroInHand()
        DispatchQueue.main.async {
            self.updateStringLabel(label: self.statusLabel, input: "Papan Congklak muncul!")
            let timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.tungguGantiLabel), userInfo: nil, repeats: false)
        }
    }
    
    @objc func tungguGantiLabel(){
        updateStringLabel(label: statusLabel, input: "Giliran P\(currentPlayer)\nAmbil biji di lubang yang sudah ditandai")
    }
}
