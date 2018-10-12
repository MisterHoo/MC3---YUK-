//
//  ViewController.swift
//  MC 3
//
//  Created by Yosua Hoo on 14/08/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, UITextFieldDelegate,MCBrowserViewControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var mainMenuIcon: UIImageView!
    @IBOutlet weak var bgPurple: UIImageView!
    @IBOutlet weak var bgRed: UIImageView!
    @IBOutlet weak var bgBlue: UIImageView!
    @IBOutlet weak var iconDualDevice: UIImageView!
    @IBOutlet weak var iconSingleDevice: UIImageView!
    @IBOutlet weak var buttonSingleDevice: UIButton!
    @IBOutlet weak var buttonDualDevice: UIButton!
    @IBOutlet weak var buttonMain: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    
    var imageArray = [UIImage]()
    


    @IBOutlet weak var menuSlider: UIPageControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var ikutButtonOutlet: UIButton!
    @IBOutlet weak var mainButtonOutlet: UIButton!
    
    var multiPeer : MPCHandeler!
    var isServer : Bool = false
    
    @IBAction func ikutButtonAction(_ sender: UIButton) {
        //performSegue(withIdentifier: "menuToLobby", sender: self)
        multiPeer.sessionBrowser()
        multiPeer.mcBrowser.delegate = self
        present(multiPeer.mcBrowser, animated: false)
    }
    
    @IBAction func mainButtonAction(_ sender: UIButton) {
        //multiPeer.hosting()
        isServer = true
        DispatchQueue.main.async {
            self.inAnimateSelectionDevice()
        }
//        performSegue(withIdentifier: "menuToGame", sender: self)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.outAnimateSelectionDevice()
        }
    }
    
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
        DispatchQueue.main.async {
            
            self.dismiss(animated: true, completion: nil)
            self.moveToGame()
            
            //            browserViewController.delegate = self
            //            self.isServer = false
            //            NotificationCenter.default.post(name: Notification.Name(rawValue: "MOVE"), object: nil)
        }
    }
    func moveToGame(){
        let scondVC = self.storyboard!.instantiateViewController(withIdentifier: "gamePlay")
        self.present(scondVC, animated: false, completion: nil)
        
    }
    @objc func moveToGameVC(){
        print("bener")
        self.performSegue(withIdentifier: "menuToGame", sender: self)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: false, completion: nil)
    }
    
    //VC
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        UserDefaults.standard.set(usernameTextField.text, forKey: "Username")
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? GameplayViewController
        
        destination?.isServer = isServer
    }
    
    public class MyClass {
        static let myNotification = Notification.Name("MPC_DidChangeStateNotification")
    }
    
    public class MyClass2 {
        static let myNotification = Notification.Name("MPC_DidRecieveDataNotification")
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(moveToGameVC), name: NSNotification.Name(rawValue: "MPC_DidRecieveDataNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveToGameVC), name: NSNotification.Name(rawValue: "MPC_DidChangeStateNotification"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonMain.isEnabled = true
        backButton.isEnabled = false
        buttonSingleDevice.isEnabled = false
        buttonDualDevice.isEnabled = false
        
        DispatchQueue.main.async {
            self.didLoadAnimate()
        }
        
        //multiPeer = (UIApplication.shared.delegate as! AppDelegate).multiPeer
        
        if let username = UserDefaults.standard.value(forKey: "Username") as? String{
            usernameTextField.text = username
            //multiPeer.namaPlayer = username
        }
        //multiPeer.setupPeerId()
        //multiPeer.setupPeerId()
//        usernameTextField.delegate = self
        
//        imageArray = [UIImage(named: "AssetCongklak"),UIImage(named: "AssetGundu"),UIImage(named: "AssetGasing")] as! [UIImage]
        
//        print(scrollView.frame.width)
//        print(scrollView.frame.height)
//
//        for i in 0..<imageArray.count
//        {
//            let imageView = UIImageView()
//            imageView.image = imageArray[i]
//            let xPosition = self.scrollView.frame.width * CGFloat(i)
//            print("\(xPosition)")
//            imageView.frame = CGRect(x: xPosition, y: 0, width: self.scrollView.bounds.width, height: self.scrollView.bounds.height)
//            imageView.contentMode = .scaleAspectFit
//
//            imageView.translatesAutoresizingMaskIntoConstraints = true
//
//            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
//
//            scrollView.addSubview(imageView)
//        }
//        self.scrollView.delegate = self
//
//    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView)
//    {
//        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
//        pageControl.currentPage = Int(pageNumber)
//    }
//
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
//    {
//
//    }
    
    
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        usernameTextField.resignFirstResponder()
//    }
    
        func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        
//        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        }
    
        func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // Don't forget to reset when view is being removed
        }
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    }
}

extension ViewController{
    //animasi view Controller
    
    //bgPurple
    //bgRed x : 375 -> 187, y : 0, width : 375, height : 812
    //bgBlue x : -375 -> -188 , y : 0,  width : 375, height : 812
    //MainMenuicon
    //iconsingledevice x : -105 -> 48, y : 260 , center x : 141, width : 92, height : 203
    //iconsdualDevice x : 388 -> 235, y : 260, center x : 141,  width : 92, height : 203
    //buttonsingledevice x : -118-> 35 , y: 489 , center x : 128, width : 118, height : 73
    //buttondualdevice x : 375 -> 222, y : 489, center x : 128, width : 118, height : 73
    //backButton x : -70 -> 22, y : 60, width : 70, height : 44
    
    func inAnimateSelectionDevice(){
        //init Position
        bgRed.frame = CGRect.init(x: 375, y: 0, width: 375, height: 812)
        bgBlue.frame = CGRect.init(x: -375, y: 0, width: 375, height: 812)
        iconSingleDevice.frame = CGRect.init(x: -105, y: 260, width: 90, height: 203)
        iconDualDevice.frame = CGRect.init(x: 388, y: 260, width: 92, height: 203)
        buttonSingleDevice.frame = CGRect.init(x: -118, y: 489, width: 118, height: 73)
        buttonDualDevice.frame = CGRect.init(x: 375, y: 489, width: 118, height: 73)
        backButton.frame = CGRect.init(x: -70, y: 60, width: 70, height: 44)
        
        
//        bgRed.alpha = 0
//        bgBlue.alpha = 0
        
        buttonMain.isEnabled = false
        backButton.isEnabled = true
        buttonDualDevice.isEnabled = true
        buttonSingleDevice.isEnabled = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bgRed.frame = CGRect.init(x: 187, y: 0, width: 375, height: 812)
            self.bgBlue.frame = CGRect.init(x: -188, y: 0, width: 375, height: 812)
//            self.bgRed.alpha = 1
//            self.bgBlue.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: 0.5, animations: {
                self.iconSingleDevice.frame = CGRect.init(x: 48, y: 260, width: 92, height: 203)
                self.iconDualDevice.frame = CGRect.init(x: 235, y: 260, width: 92, height: 203)
                self.buttonSingleDevice.frame = CGRect.init(x: 35, y: 489, width: 118, height: 73)
                self.buttonDualDevice.frame = CGRect.init(x: 222, y: 489, width: 118, height: 73)
                self.backButton.frame = CGRect.init(x: 22, y: 60, width: 70, height: 44)
            })
        }
    }
    
    func outAnimateSelectionDevice(){
        iconSingleDevice.frame = CGRect.init(x: 48, y: 260, width: 92, height: 203)
        iconDualDevice.frame = CGRect.init(x: 235, y: 260, width: 92, height: 203)
        buttonSingleDevice.frame = CGRect.init(x: 35, y: 489, width: 118, height: 73)
        buttonDualDevice.frame = CGRect.init(x: 222, y: 489, width: 118, height: 73)
        bgRed.frame = CGRect.init(x: 187, y: 0, width: 375, height: 812)
        bgBlue.frame = CGRect.init(x: -188, y: 0, width: 375, height: 812)
        backButton.frame = CGRect.init(x: 22, y: 60, width: 70, height: 44)
//        bgRed.alpha = 1
//        bgBlue.alpha = 1
//
       
        buttonMain.isEnabled = true
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.iconSingleDevice.frame = CGRect.init(x: -105, y: 260, width: 90, height: 203)
            self.iconDualDevice.frame = CGRect.init(x: 388, y: 260, width: 92, height: 203)
            self.buttonSingleDevice.frame = CGRect.init(x: -118, y: 489, width: 118, height: 73)
            self.buttonDualDevice.frame = CGRect.init(x: 375, y: 489, width: 118, height: 73)
            self.backButton.frame = CGRect.init(x: -70, y: 60, width: 70, height: 44)
        }) { (true) in
            UIView.animate(withDuration: 0.5, animations: {
                self.bgRed.frame = CGRect.init(x: 375, y: 0, width: 375, height: 812)
                self.bgBlue.frame = CGRect.init(x: -375, y: 0, width: 375, height: 812)
//                self.bgRed.alpha = 0
//                self.bgBlue.alpha = 0
                self.backButton.isEnabled = false
                self.buttonSingleDevice.isEnabled = false
                self.buttonDualDevice.isEnabled = false
            })
        }
    }
    
    func didLoadAnimate(){
        buttonMain.alpha = 0
        mainMenuIcon.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.buttonMain.alpha = 1
            self.mainMenuIcon.alpha = 0.5
        }) { (true) in
            UIView.animate(withDuration: 0.5, animations: {
                self.mainMenuIcon.alpha = 1
            })
        }
        
    }
    
    
}
