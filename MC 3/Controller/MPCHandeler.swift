//
//  MPCHandeler.swift
//  MC 3
//
//  Created by Yosua Hoo on 27/08/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import MultipeerConnectivity

class MPCHandeler: NSObject, MCSessionDelegate,MCBrowserViewControllerDelegate, MCAdvertiserAssistantDelegate {
    
    let viewController = ViewController()
    
    static let serviceType = "Traadisional"
    
    let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    var session : MCSession!
    var mcAdvertiserAssistant:MCAdvertiserAssistant!
    var mcBrowser:MCBrowserViewController!
    
    var receivedData : Data!
    
    //private let reciveDataHandler: (Data, MCPeerID) -> Void
    var gamePlayViewController = GameplayViewController()
    
    private var serviceBrowser: MCNearbyServiceBrowser!
    private var serviceAdvertiser: MCNearbyServiceAdvertiser!
    private let receivedDataHandler: (Data, MCPeerID) -> Void
    /// - Tag: MultipeerSetup
    init(receivedDataHandler: @escaping (Data, MCPeerID) -> Void ) {
        self.receivedDataHandler = receivedDataHandler
        
        super.init()
        
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: MPCHandeler.serviceType, discoveryInfo: nil, session: session)
        mcAdvertiserAssistant.delegate = self
        mcAdvertiserAssistant.start()
        
//        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: MPCHandeler.serviceType)
//        serviceAdvertiser.delegate = self
//        serviceAdvertiser.startAdvertisingPeer()
        
//        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: MPCHandeler.serviceType)
//        serviceBrowser.delegate = self
//        serviceBrowser.startBrowsingForPeers()
    }
    func sendToAllPeers(_ data: Data) {
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("error sending data to peers: \(error.localizedDescription)")
        }
    }

    
    func setupPeerId(){
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
    }
    
    func hosting(){
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: MPCHandeler.serviceType, discoveryInfo: nil, session: session)
        mcAdvertiserAssistant.delegate = self
        mcAdvertiserAssistant.start()
    }
    
    func sessionBrowser(){
        mcBrowser = MCBrowserViewController(serviceType: MPCHandeler.serviceType, session: session)
        mcBrowser.delegate = self
//        print(mcBrowser.delegate)
    }
    
    //Mark
    
    public class MyClass {
        static let myNotification = Notification.Name("MPC_DidChangeStateNotification")
    }
    
    public class MyClass2 {
        static let myNotification = Notification.Name("MPC_DidRecieveDataNotification")
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
        
        let userInfo = ["peerID":peerID,"state":state.rawValue] as [String : Any]
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: MyClass.myNotification, object: nil, userInfo: userInfo)
        }
    }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        //gamePlayViewController.loadWorldMap(from: data)
        receivedDataHandler(data, peerID)
        
//        receivedData = data
//        let userInfo = ["data":data, "peerID":peerID] as [String : Any]
//        DispatchQueue.main.async {
//            NotificationCenter.default.post(name: MyClass2.myNotification, object: nil, userInfo: userInfo)
//        }
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        // code
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // code
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // code
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: (Bool, MCSession?) -> Void) {
        
        invitationHandler (true, session)
    }
    
    /*
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
    */
    /*
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        receivedData = data
    }
    */
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
        
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        print("kampret")
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        
    }
}

extension MPCHandeler : MCNearbyServiceAdvertiserDelegate {
    
}

extension MPCHandeler : MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
    }
    
    
}
