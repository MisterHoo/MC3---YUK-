//
//  ViewController.swift
//  MC 3
//
//  Created by Yosua Hoo on 14/08/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, UITextFieldDelegate,MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        
    }
    

    @IBOutlet weak var menuSlider: UIPageControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var ikutButtonOutlet: UIButton!
    @IBOutlet weak var mainButtonOutlet: UIButton!
    
    var appDelegate:AppDelegate!
    let multiPeer = MultiPeerHandeler()
    
    @IBAction func ikutButtonAction(_ sender: UIButton) {
        //performSegue(withIdentifier: "menuToLobby", sender: self)
        multiPeer.joinSession()
        present(multiPeer.mcBrowser, animated: true)
    }
    
    @IBAction func mainButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "menuToGame", sender: self)
        multiPeer.startHosting()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        UserDefaults.standard.set(usernameTextField.text, forKey: "Username")
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let username = UserDefaults.standard.value(forKey: "Username") as? String{
            usernameTextField.text = username
            multiPeer.namaPlayer = username
        }
        multiPeer.setupConnectivity()
        usernameTextField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

