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

extension GameplayViewController {
    
    
//    @objc func tapped (tapRecognizer : UITapGestureRecognizer){
//        let location = tapRecognizer.location(in: sceneView)
//        
//        print(location)
//        //when board hasn't delploy
//        if boardFlag == false {
//            addNodeAtLocation(location: location)
//        }else{
//            //when board already deployed
//            let selectedHole = chooseHoleToGetBean(location: location)
//            //print(selectedHole?.name)
//            
//            if indexHoleRow < 7{
//                //print(gameBoard.holeBox[indexHoleColumn][indexHoleRow].name)
//            }
//            if (selectedHole != nil){
//            if counterHand == 0 {
//                //ditangan kosong ambil terserah
//                freeWillPick(parentNode: selectedHole!, currentPlayer: currentPlayer)
//                if currentPlayer != enemyPlayer{
//                    print("masuk")
//                    curPlayerTime = 0
//                    enemyPlayer = currentPlayer
//                }
//            }else if counterHand == 1{
//                //last Biji in Hand
//                curPlayerTime += 1
//                
//                if indexHoleColumn == currentPlayer - 1{
//                    //ditempat dia sendiri
//                    if indexHoleRow == 7{
//                        //add di Goal Post
//                        addToGoalPost(selectedHole: selectedHole!)
//                    }else if indexHoleRow < 7{
//                        if selectedHole!.name == gameBoard.holeBox[indexHoleColumn][indexHoleRow].name {
//                            if checkIfEmpty(parentNode: selectedHole!) == false{
//                                //jatuh di tempat sendiri, gak kosong
//                                addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
//                                takeBeanToHand(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], currentPlayer: currentPlayer)
//                                indexHoleRow += 1
//                            }else{
//                                // TEMBAKKK
//                                if curPlayerTime > 8 {
//                                    addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
//                                    var enemyHoleColumn : Int = 0
//                                    if indexHoleColumn == 1 {
//                                        enemyHoleColumn = 0
//                                    }else{
//                                        enemyHoleColumn = 1
//                                    }
//                                    if checkIfEmpty(parentNode: gameBoard.holeBox[enemyHoleColumn][6-indexHoleRow]) == false{
//                                        tembak(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], indexEnemyColumn: enemyHoleColumn, curPlayer: currentPlayer)
//                                    }
//                                    changePlayer()
//                                }
//                            }
//                        }
//                    }
//                }else{
//                    //jatuh di tempat musuh
//                    if indexHoleRow < 7{
//                        if selectedHole!.name == gameBoard.holeBox[indexHoleColumn][indexHoleRow].name{
//                            if checkIfEmpty(parentNode: selectedHole!) == false{
//                                //gak Kosong, ambil punya musuh
//                                addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
//                                takeBeanToHand(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], currentPlayer:     currentPlayer)
//                                indexHoleRow += 1
//                                if selectedHole!.name == gameBoard.holeBox[currentPlayer-1][6].name{
//                                    print("pernah masuk yang pertama")
//                                    indexHoleRow = 0
//                                    if currentPlayer == 1{
//                                        indexHoleColumn = 1
//                                    }else {
//                                        indexHoleColumn = 0
//                                    }
//                                }
//                            }else{
//                                //Kosong, ganti Player
//                                addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
//                                changePlayer()
//                            }
//                        }
//                    }else if indexHoleRow == 7{
//                        //next target lubang pertama tempat kita
//                        if selectedHole!.name == gameBoard.holeBox[currentPlayer-1][0].name{
//                            print("pernah masuk yang kedua")
//                            addKacang(parentNode: gameBoard.holeBox[currentPlayer-1][0])
//                            takeBeanToHand(parentNode: gameBoard.holeBox[currentPlayer-1][0], currentPlayer:currentPlayer)
//                            indexHoleRow = 0
//                            indexHoleRow += 1
//                        }
//                        
//                    }
//                }
//            }else{
//                curPlayerTime += 1
//                if currentPlayer == 1{
//                    //player 1 turn
//                    if indexHoleRow == 7 && indexHoleColumn == 0{
//                        if  selectedHole!.name == gameBoard.goalPostBoxA.name {
//                            //jatuh di goalPost kita
//                            addToGoalPostA(parentNode: gameBoard.goalPostBoxA)
//                            //print(counterA)
//                        }
//                    }else if indexHoleRow == 7 && indexHoleColumn == 1{
//                        if selectedHole!.name == gameBoard.holeBox[0][0].name{
//                            //berada di hole terakhir sbelum goalPost musuh, nextTarget ke hole kita (skip goalPost musuh)
//                            addKacang(parentNode: gameBoard.holeBox[0][0])
//                            indexHoleColumn = 0
//                            indexHoleRow = 1
//                        }
//                    }else if indexHoleRow < 7 {
//                        if  selectedHole!.name == gameBoard.holeBox[indexHoleColumn][indexHoleRow].name {
//                            //default Run
//                            addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
//                            indexHoleRow += 1
//                        }
//                    }
//                }else if currentPlayer == 2{
//                    //player 2 turn
//                    if  indexHoleRow == 7 && indexHoleColumn == 1{
//                        if selectedHole!.name == gameBoard.goalPostBoxB.name{
//                            //jatuh di goalPost kita
//                            addToGoalPostB(parentNode: gameBoard.goalPostBoxB)
//                            //print(counterB)
//                        }
//                    }else if indexHoleColumn == 0 && indexHoleRow == 7{
//                        if  selectedHole!.name == gameBoard.holeBox[1][0].name{
//                            //berada di hole terakhir sbelum goalPost musuh, nextTarget hole kita (skip goalPost musuh)
//                            addKacang(parentNode: gameBoard.holeBox[1][0])
//                            indexHoleColumn = 1
//                            indexHoleRow = 1
//                        }
//                    }else if indexHoleRow < 7{
//                        if selectedHole!.name == gameBoard.holeBox[indexHoleColumn][indexHoleRow].name{
//                            //default Run
//                            addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
//                            indexHoleRow += 1
//                        }
//                    }
//                }
//            }
//            }
//            updateLabel(label: currentBeanInHandLabel, input: counterHand)
//            print("\(indexHoleColumn),\(indexHoleRow)")
//        }
//    }
    
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: sceneView)
        
        print(location)
        //when board hasn't delploy
        if boardFlag == false {
            addNodeAtLocation(location: location!)
        }else{
            //when board already deployed
            let selectedHole = chooseHoleToGetBean(location: location!)
            //print(selectedHole?.name)
            
            if indexHoleRow < 7{
                //print(gameBoard.holeBox[indexHoleColumn][indexHoleRow].name)
            }
            if (selectedHole != nil){
                if counterHand == 0 {
                    //ditangan kosong ambil terserah
                    freeWillPick(parentNode: selectedHole!, currentPlayer: currentPlayer)
                    if currentPlayer != enemyPlayer{
                        print("masuk")
                        curPlayerTime = 0
                        enemyPlayer = currentPlayer
                    }
                }else if counterHand == 1{
                    //last Biji in Hand
                    curPlayerTime += 1
                    
                    if indexHoleColumn == currentPlayer - 1{
                        //ditempat dia sendiri
                        if indexHoleRow == 7{
                            //add di Goal Post
                            addToGoalPost(selectedHole: selectedHole!)
                        }else if indexHoleRow < 7{
                            if selectedHole!.name == gameBoard.holeBox[indexHoleColumn][indexHoleRow].name {
                                if checkIfEmpty(parentNode: selectedHole!) == false{
                                    //jatuh di tempat sendiri, gak kosong
                                    addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                                    takeBeanToHand(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], currentPlayer: currentPlayer)
                                    indexHoleRow += 1
                                }else{
                                    // TEMBAKKK
                                    if curPlayerTime > 8 {
                                        addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                                        var enemyHoleColumn : Int = 0
                                        if indexHoleColumn == 1 {
                                            enemyHoleColumn = 0
                                        }else{
                                            enemyHoleColumn = 1
                                        }
                                        if checkIfEmpty(parentNode: gameBoard.holeBox[enemyHoleColumn][6-indexHoleRow]) == false{
                                            tembak(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], indexEnemyColumn: enemyHoleColumn, curPlayer: currentPlayer)
                                        }
                                        changePlayer()
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
                                    addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                                    takeBeanToHand(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow], currentPlayer:     currentPlayer)
                                    indexHoleRow += 1
                                    if selectedHole!.name == gameBoard.holeBox[currentPlayer-1][6].name{
                                        print("pernah masuk yang pertama")
                                        indexHoleRow = 0
                                        if currentPlayer == 1{
                                            indexHoleColumn = 1
                                        }else {
                                            indexHoleColumn = 0
                                        }
                                    }
                                }else{
                                    //Kosong, ganti Player
                                    addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                                    changePlayer()
                                }
                            }
                        }else if indexHoleRow == 7{
                            //next target lubang pertama tempat kita
                            if selectedHole!.name == gameBoard.holeBox[currentPlayer-1][0].name{
                                print("pernah masuk yang kedua")
                                addKacang(parentNode: gameBoard.holeBox[currentPlayer-1][0])
                                takeBeanToHand(parentNode: gameBoard.holeBox[currentPlayer-1][0], currentPlayer:currentPlayer)
                                indexHoleRow = 0
                                indexHoleRow += 1
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
                                //print(counterA)
                            }
                        }else if indexHoleRow == 7 && indexHoleColumn == 1{
                            if selectedHole!.name == gameBoard.holeBox[0][0].name{
                                //berada di hole terakhir sbelum goalPost musuh, nextTarget ke hole kita (skip goalPost musuh)
                                addKacang(parentNode: gameBoard.holeBox[0][0])
                                indexHoleColumn = 0
                                indexHoleRow = 1
                            }
                        }else if indexHoleRow < 7 {
                            if  selectedHole!.name == gameBoard.holeBox[indexHoleColumn][indexHoleRow].name {
                                //default Run
                                addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                                indexHoleRow += 1
                            }
                        }
                    }else if currentPlayer == 2{
                        //player 2 turn
                        if  indexHoleRow == 7 && indexHoleColumn == 1{
                            if selectedHole!.name == gameBoard.goalPostBoxB.name{
                                //jatuh di goalPost kita
                                addToGoalPostB(parentNode: gameBoard.goalPostBoxB)
                                //print(counterB)
                            }
                        }else if indexHoleColumn == 0 && indexHoleRow == 7{
                            if  selectedHole!.name == gameBoard.holeBox[1][0].name{
                                //berada di hole terakhir sbelum goalPost musuh, nextTarget hole kita (skip goalPost musuh)
                                addKacang(parentNode: gameBoard.holeBox[1][0])
                                indexHoleColumn = 1
                                indexHoleRow = 1
                            }
                        }else if indexHoleRow < 7{
                            if selectedHole!.name == gameBoard.holeBox[indexHoleColumn][indexHoleRow].name{
                                //default Run
                                addKacang(parentNode: gameBoard.holeBox[indexHoleColumn][indexHoleRow])
                                indexHoleRow += 1
                            }
                        }
                    }
                }
            }
            updateLabel(label: currentBeanInHandLabel, input: counterHand)
            print("\(indexHoleColumn),\(indexHoleRow)")
        }
    }
 
    
    func tembak(parentNode : SCNNode, indexEnemyColumn : Int, curPlayer : Int){
        takeBeanToHand(parentNode: parentNode, currentPlayer: curPlayer)
        takeBeanToHand(parentNode: gameBoard.holeBox[indexEnemyColumn][6-indexHoleRow], currentPlayer: curPlayer)
        
        if curPlayer == 1{
            while counterHand != 0 {
                addKacang(parentNode: gameBoard.goalPostBoxA)
                counterA += 1
            }
            updateLabel(label: scoreALabel, input: counterA)
        }else if curPlayer == 2{
            while counterHand != 0 {
                addKacang(parentNode: gameBoard.goalPostBoxB)
                counterB += 1
            }
            updateLabel(label: scoreBLabel, input: counterB)
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
        for j in 0...6{
            if parentNode.name == gameBoard.holeBox[currentPlayer-1][j].name{
                indexHoleColumn = currentPlayer-1
                indexHoleRow = j+1
                
                takeBeanToHand(parentNode: parentNode, currentPlayer: currentPlayer)
                
            }
        }
    }
    
    func takeBeanToHand(parentNode : SCNNode, currentPlayer : Int){
        for child in parentNode.childNodes{
            //print(child.name)
            if child.name == nil{
                counterHand += 1
                child.removeFromParentNode()
            }
        }
    }
    
    
    func addKacang(parentNode : SCNNode){
        let kacang = KacangObject()
        kacang.loadModel()
        kacang.position = SCNVector3Make(0, 0, 0)
        counterHand -= 1
        parentNode.addChildNode(kacang)
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
    
    func changePlayer (){
        if currentPlayer == 1{
            currentPlayer = 2
            updateLabel(label: currentPlayerLabel, input: currentPlayer)
        }else{
            currentPlayer = 1
            updateLabel(label: currentPlayerLabel, input: currentPlayer)
        }
    }
    
    func updateLabel(label : UILabel, input : Int){
        label.text = String(input)
    }
    
    func addToGoalPost(selectedHole : SCNNode){
        if currentPlayer == 1 && selectedHole.name == gameBoard.goalPostBoxA.name{
            //Goal Post player 1
            addKacang(parentNode: gameBoard.goalPostBoxA )
            counterA += 1
            updateLabel(label: scoreALabel, input: counterA)
            
        }else if currentPlayer == 2 && selectedHole.name == gameBoard.goalPostBoxB.name{
            //Goal Post Player 2
            addKacang(parentNode: gameBoard.goalPostBoxB )
            counterB += 1
            updateLabel(label: scoreBLabel, input: counterB)
            
        }
    }
    
    func addToGoalPostA(parentNode : SCNNode){
        addKacang(parentNode: parentNode)
        indexHoleColumn = 1
        indexHoleRow = 0
        counterA += 1
        updateLabel(label: scoreALabel, input: counterA)
    }
    
    func addToGoalPostB(parentNode : SCNNode){
        addKacang(parentNode: parentNode)
        indexHoleColumn = 0
        indexHoleRow = 0
        counterB += 1
        updateLabel(label: scoreBLabel, input: counterB)
    }
}
