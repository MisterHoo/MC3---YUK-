//
//  MultiPeerHandeler.swift
//  MC 3
//
//  Created by Kennyzi Yusuf on 20/08/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MultiPeerHandeler: NSObject, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var peerID:MCPeerID!
    var mcSession:MCSession!
    var mcAdvertiserAssistant:MCAdvertiserAssistant!
    var mcBrowser:MCBrowserViewController!
    var namaPlayer:String = "u"
    
    //bikin nama player

    func setupConnectivity(){
         peerID = MCPeerID(displayName: namaPlayer)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        print(mcSession)
    }
    
    func startHosting() {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-kb", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    func joinSession() {
        mcBrowser = MCBrowserViewController(serviceType: "hws-kb", session: mcSession)
        mcBrowser.delegate = self
        
        
    }
    
//    func joinSession(){
//        browser = MCBrowserViewController(serviceType: "ba-td", session: self.mcSession)
//    }
//    func host(advertise: Bool) {
//        if advertise {
//            self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "ba-td", discoveryInfo: nil, session: self.mcSession)
//            self.mcAdvertiserAssistant.start()
//        }else{
//            self.mcAdvertiserAssistant.stop()
//            self.mcAdvertiserAssistant = nil
//        }
//    }
    
    // MARK: - Send Data
//    func sendImage(img: UIImage) {
//        if mcSession.connectedPeers.count > 0 {
//            if let imageData = UIImagePNGRepresentation(img) {
//                do {
//                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
//                } catch let error as NSError {
//                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
//                    ac.addAction(UIAlertAction(title: "OK", style: .default))
//                    present(ac, animated: true)
//                }
//            }
//        }
//    }
   
    // MARK: - MC Delegate Func
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    // recive data
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}

