//
//  ViewController.swift
//  MC 3
//
//  Created by Yosua Hoo on 14/08/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import GoogleMobileAds

class ViewController: UIViewController, UITextFieldDelegate,MCBrowserViewControllerDelegate, UIScrollViewDelegate, GADInterstitialDelegate {
    
    @IBOutlet var CreditView: UIView!
    @IBOutlet weak var visualEffectOutlet: UIVisualEffectView!
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
    @IBOutlet weak var tentangButton: UIButton!
    
    //Constraint
    
    //BG Purple, Icon, Main Button
    
    @IBOutlet weak var bgPurpleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgPurpleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgPurpleTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgPurpleBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainIconTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainIconBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainButtonBottomConstraint: NSLayoutConstraint!
    
    
    //BG red & Blue
    @IBOutlet weak var bgRedLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgRedTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgBlueTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgBlueLeadingConstraint: NSLayoutConstraint!
    
    //View containt icon device and button
    @IBOutlet weak var viewHelperSingleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHelperDualTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHelperDualLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHelperSingleTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewHelperSingleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHelperSingleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHelperDualTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHelperDualBottomConstraint: NSLayoutConstraint!
    
    //Button Back & Tentang
    @IBOutlet weak var backButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tentangButtonTrailingConstraint: NSLayoutConstraint!
    
    //variable that used
    var multiPeer : MPCHandeler!
    var isServer : Bool = false
    var isMultipeer : Bool = false
    var widthDevice = UIScreen.main.bounds.width
    var heightDevice = UIScreen.main.bounds.height
    var widthScreen = UIScreen.main.bounds.width
    var heightScreen = UIScreen.main.bounds.height
    var effect:UIVisualEffect!
    
    var isInit : Bool = false
    var isSelectionDevice : Bool = false
    var isSingleDeviceSelected : Bool = false
    var isDualDeviceSelected : Bool = false
    
    // Ad View Variable
    var interstitialAd : GADInterstitial?
    
    // Ad Purpose
    func createAndLoadInterstitial() -> GADInterstitial {
        let request = GADRequest()
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-8141183117363932/2351484026")
        interstitial.delegate = self
        interstitial.load(request)
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitialAd = createAndLoadInterstitial()
    }
    
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
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.outAnimateSelectionDevice()
        }
    }
    
    
    @IBAction func singleDeviceSelected(_ sender: Any) {
        
        isMultipeer = false
        isServer = true
        DispatchQueue.main.async {
            self.selectedSingleDevice()
        }
    }
    
    @IBAction func dualDeviceSelected(_ sender: Any) {
        isMultipeer = true
        isServer = true
        DispatchQueue.main.async {
            self.selectedDualDevice()
        }
    }
    
    func animateIn(){
        visualEffectOutlet.isHidden = false
        self.view.addSubview(CreditView)
        CreditView.center = self.view.center
        
        CreditView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        CreditView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.visualEffectOutlet.effect = self.effect
            self.CreditView.alpha = 1
            self.CreditView.transform = CGAffineTransform.identity
        }
    }
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.CreditView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.CreditView.alpha = 0
            self.visualEffectOutlet.effect = nil
        }) { (succes: Bool) in
            self.CreditView.removeFromSuperview()
        }
    }
    
    @IBAction func creditButton(_ sender: Any) {
        animateIn()
    }
    @IBAction func dismisButton(_ sender: Any) {
        animateOut()
        self.visualEffectOutlet.isHidden = true
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
    
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        textField.resignFirstResponder()
    //
    //        UserDefaults.standard.set(usernameTextField.text, forKey: "Username")
    //
    //        return true
    //    }
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? GameplayViewController
        
        destination?.isServer = isServer
        destination?.isMultipeer = isMultipeer
        destination?.interstitialAd = interstitialAd
    }
    
    public class MyClass {
        static let myNotification = Notification.Name("MPC_DidChangeStateNotification")
    }
    
    public class MyClass2 {
        static let myNotification = Notification.Name("MPC_DidRecieveDataNotification")
    }
    
    func addGradientViewBelow(){
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor(red: 65/255, green: 7/255, blue: 112/255, alpha: 1).cgColor, UIColor.black.cgColor]
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.zPosition = -1
        view.layer.addSublayer(layer)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape{
            widthScreen = heightDevice
            print("landscape")
        } else {
            widthScreen = widthDevice
            print("portrait")
        }
        
        if isInit{
            DispatchQueue.main.async {
                self.initPosition()
            }
        }else if isSelectionDevice{
            DispatchQueue.main.async {
                self.positionDeviceSelection()
            }
        }else if isSingleDeviceSelected{
            DispatchQueue.main.async {
                self.positionSingleDeviceSelected()
            }
        }else if isDualDeviceSelected{
            DispatchQueue.main.async {
                self.positionDualDeviceSelected()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        NotificationCenter.default.addObserver(self, selector: #selector(moveToGameVC), name: NSNotification.Name(rawValue: "MPC_DidRecieveDataNotification"), object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(moveToGameVC), name: NSNotification.Name(rawValue: "MPC_DidChangeStateNotification"), object: nil)
        DispatchQueue.main.async {
            self.initPosition()
            self.didLoadAnimate()
        }
    }
    
    func initPosition(){
        //        bgRed.frame = CGRect.init(x: 375, y: 0, width: 375, height: 812)
        //        bgBlue.frame = CGRect.init(x: -375, y: 0, width: 375, height: 812)
        //        iconSingleDevice.frame = CGRect.init(x: -105, y: 260, width: 90, height: 203)
        //        iconDualDevice.frame = CGRect.init(x: 388, y: 260, width: 92, height: 203)
        //        buttonSingleDevice.frame = CGRect.init(x: -118, y: 489, width: 118, height: 73)
        //        buttonDualDevice.frame = CGRect.init(x: 375, y: 489, width: 118, height: 73)
        //        backButton.frame = CGRect.init(x: -70, y: 60, width: 70, height: 44)
        //
        //        bgPurple.frame = CGRect.init(x: 0, y: 0, width: 375, height: 812)
        //        mainMenuIcon.frame = CGRect.init(x: 61, y: 138, width: 253, height: 447)
        //        buttonMain.frame = CGRect.init(x: 124, y: 570, width: 127, height: 78)
        //
        
        isInit = true
        isSelectionDevice = false
        isSingleDeviceSelected = false
        isDualDeviceSelected = false
        
        bgPurpleLeadingConstraint.constant = 0
        bgPurpleTopConstraint.constant = 0
        bgPurpleBottomConstraint.constant = 0
        bgPurpleTrailingConstraint.constant = 0
        
        mainIconTopConstraint.constant = 94
        mainIconBottomConstraint.constant = 193
        
        mainButtonBottomConstraint.constant = 130
        
        backButtonLeadingConstraint.constant = -90
        tentangButtonTrailingConstraint.constant = 22
        
        bgRedLeadingConstraint.constant = widthScreen
        bgRedTrailingConstraint.constant = widthScreen
        bgBlueLeadingConstraint.constant = widthScreen
        bgBlueTrailingConstraint.constant = widthScreen
        
        viewHelperSingleLeadingConstraint.constant = -widthScreen
        viewHelperSingleTrailingConstraint.constant = widthScreen
        viewHelperDualLeadingConstraint.constant = widthScreen
        viewHelperDualTrailingConstraint.constant = -widthScreen
        
        viewHelperSingleTopConstraint.constant = 44
        viewHelperSingleBottomConstraint.constant = 34
        viewHelperDualTopConstraint.constant = 44
        viewHelperDualBottomConstraint.constant = 34
        
        view.alpha = 1
        //        let helperview = UIView()
        //        helperview.backgroundColor = UIColor.white
        //        helperview.frame = CGRect(x: bgBlueLeadingConstraint.constant, y: 0, width: 20, height: 20)
        //        view.addSubview(helperview)
        
        buttonMain.isEnabled = true
        backButton.isEnabled = false
        tentangButton.isEnabled = true
        buttonSingleDevice.isEnabled = false
        buttonDualDevice.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitialAd = createAndLoadInterstitial()
        effect = visualEffectOutlet.effect
        visualEffectOutlet.effect = nil
        visualEffectOutlet.isHidden = true
        DispatchQueue.main.async {
            self.addGradientViewBelow()
            AppUtility.lockOrientation(.portrait)
            //        Or to rotate and lock
            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
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
    
    //bgPurple x : 0 -> 28 , y : 0 -> 61 , width : 375 -> 318, height : 812 -> 690
    //mainMenuIcon x : 61 -> 78 , y : 138 -> 178, width : 253 -> 218, height : 447 -> 384
    //buttonMain x : 124 -> 142 , y : 570 -> 567 , width : 127 -> 91, height : 78 -> 56
    
    func positionDualDeviceSelected(){
        self.backButtonLeadingConstraint.constant = -100
        
        self.viewHelperDualBottomConstraint.constant = self.widthScreen * 3
        self.viewHelperDualTopConstraint.constant = self.widthScreen * 3
        self.viewHelperDualLeadingConstraint.constant = -self.widthScreen * 3
        self.viewHelperDualTrailingConstraint.constant = -self.widthScreen * 3
        self.view.layoutIfNeeded()
    }
    
    func positionSingleDeviceSelected(){
        self.backButtonLeadingConstraint.constant = -100
        
        self.viewHelperSingleTopConstraint.constant = self.widthScreen * 3
        self.viewHelperSingleBottomConstraint.constant = self.widthScreen * 3
        self.viewHelperSingleTrailingConstraint.constant = -self.widthScreen * 3
        self.viewHelperSingleLeadingConstraint.constant = -self.widthScreen * 3
        self.view.layoutIfNeeded()
    }
    
    func positionDeviceSelection(){
        self.bgPurpleTopConstraint.constant = 150
        self.bgPurpleBottomConstraint.constant = 150
        self.bgPurpleLeadingConstraint.constant = 125
        self.bgPurpleTrailingConstraint.constant = 125
        
        self.mainIconTopConstraint.constant = 160
        self.mainIconBottomConstraint.constant = 285
        
        self.mainButtonBottomConstraint.constant = 250
        self.tentangButtonTrailingConstraint.constant = -90
        
        self.bgRedLeadingConstraint.constant = self.widthScreen/2
        self.bgRedTrailingConstraint.constant = self.widthScreen/2
        
        self.bgBlueLeadingConstraint.constant = self.widthScreen/2
        self.bgBlueTrailingConstraint.constant = self.widthScreen/2
        
        self.viewHelperSingleLeadingConstraint.constant = 0
        self.viewHelperSingleTrailingConstraint.constant = self.widthScreen/2
        self.viewHelperDualLeadingConstraint.constant = self.widthScreen/2
        self.viewHelperDualTrailingConstraint.constant = 0
        self.backButtonLeadingConstraint.constant = 22
        
        self.view.layoutIfNeeded()
    }
    
    func selectedDualDevice(){
        
        
        isInit = false
        isSelectionDevice = false
        isSingleDeviceSelected = false
        isDualDeviceSelected = true
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.backButtonLeadingConstraint.constant = -90
            
            self.bgBlueLeadingConstraint.constant = -self.widthScreen
            self.bgBlueTrailingConstraint.constant = self.widthScreen
            self.viewHelperSingleLeadingConstraint.constant = -self.widthScreen/2
            self.viewHelperSingleTrailingConstraint.constant = self.widthScreen
            
            
            self.bgRedLeadingConstraint.constant = 0
            self.bgRedTrailingConstraint.constant = 0
            self.viewHelperDualLeadingConstraint.constant = 0
            self.viewHelperDualTrailingConstraint.constant = 0
            
            self.view.layoutIfNeeded()
            
            
            
            
        }) { (true) in
            UIView.animate(withDuration: 1.5, animations: {
                self.backButtonLeadingConstraint.constant = -100
                self.view.layoutIfNeeded()
            }, completion: { (true) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.viewHelperDualBottomConstraint.constant = self.widthScreen * 3
                    self.viewHelperDualTopConstraint.constant = self.widthScreen * 3
                    self.viewHelperDualLeadingConstraint.constant = -self.widthScreen * 3
                    self.viewHelperDualTrailingConstraint.constant = -self.widthScreen * 3
                    self.view.layoutIfNeeded()
                }, completion: { (true) in
                    self.performSegue(withIdentifier: "menuToGame", sender: self)
                })
            })
        }
    }
    
    
    func selectedSingleDevice(){
        
        isInit = false
        isSelectionDevice = false
        isDualDeviceSelected = false
        isSingleDeviceSelected = true
        
        UIView.animate(withDuration: 0.5, animations: {
            
            
            self.backButtonLeadingConstraint.constant = -90
            
            self.bgRedLeadingConstraint.constant = self.widthScreen
            self.bgRedTrailingConstraint.constant = self.widthScreen
            self.viewHelperDualLeadingConstraint.constant = self.widthScreen
            self.viewHelperDualTrailingConstraint.constant = -self.widthScreen/2
            
            self.bgBlueLeadingConstraint.constant = 0
            self.bgBlueTrailingConstraint.constant = 0
            self.viewHelperSingleLeadingConstraint.constant = 0
            self.viewHelperSingleTrailingConstraint.constant = 0
            
            self.view.layoutIfNeeded()
            
        }) { (true) in
            UIView.animate(withDuration: 1.5, animations: {
                self.backButtonLeadingConstraint.constant = -100
                self.view.layoutIfNeeded()
            }, completion: { (true) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.viewHelperSingleTopConstraint.constant = self.widthScreen * 3
                    self.viewHelperSingleBottomConstraint.constant = self.widthScreen * 3
                    self.viewHelperSingleTrailingConstraint.constant = -self.widthScreen * 3
                    self.viewHelperSingleLeadingConstraint.constant = -self.widthScreen * 3
                    self.view.layoutIfNeeded()
                }, completion: { (true) in
                    self.performSegue(withIdentifier: "menuToGame", sender: self)
                })
            })
        }
    }
    
    
    func inAnimateSelectionDevice(){
        //autolayout
        
        backButton.isEnabled = true
        buttonDualDevice.isEnabled = true
        buttonSingleDevice.isEnabled = true
        
        isInit = false
        isSelectionDevice = true
        isSingleDeviceSelected = false
        isDualDeviceSelected = false
        
        UIView.animate(withDuration: 0.5, animations: {
            
            
            self.bgPurpleTopConstraint.constant = 150
            self.bgPurpleBottomConstraint.constant = 150
            self.bgPurpleLeadingConstraint.constant = 125
            self.bgPurpleTrailingConstraint.constant = 125
            
            self.mainIconTopConstraint.constant = 160
            self.mainIconBottomConstraint.constant = 285
            
            self.mainButtonBottomConstraint.constant = 250
            self.tentangButtonTrailingConstraint.constant = -90
            
            self.bgRedLeadingConstraint.constant = self.widthScreen/2
            self.bgRedTrailingConstraint.constant = self.widthScreen/2
            
            self.bgBlueLeadingConstraint.constant = self.widthScreen/2
            self.bgBlueTrailingConstraint.constant = self.widthScreen/2
            
            
            
            self.view.layoutIfNeeded()
            
            self.bgPurple.alpha = 0.5
            self.mainMenuIcon.alpha = 0.5
            self.buttonMain.alpha = 0.5
            //            self.bgRed.alpha = 1
            //            self.bgBlue.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: 0.5, animations: {
                self.viewHelperSingleLeadingConstraint.constant = 0
                self.viewHelperSingleTrailingConstraint.constant = self.widthScreen/2
                self.viewHelperDualLeadingConstraint.constant = self.widthScreen/2
                self.viewHelperDualTrailingConstraint.constant = 0
                self.backButtonLeadingConstraint.constant = 22
                
                self.view.layoutIfNeeded()
                
                
                
                self.buttonMain.isEnabled = false
                self.tentangButton.isEnabled = false
            })
        }
    }
    
    func outAnimateSelectionDevice(){
        
        bgPurple.alpha = 0.75
        mainMenuIcon.alpha = 0.75
        buttonMain.alpha = 0.75
        
        isInit = true
        isSelectionDevice = false
        isSingleDeviceSelected = false
        isDualDeviceSelected = false
        
        //        bgRed.alpha = 1
        //        bgBlue.alpha = 1
        //
        
        buttonMain.isEnabled = true
        tentangButton.isEnabled = true
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.viewHelperSingleLeadingConstraint.constant = -self.widthScreen
            self.viewHelperSingleTrailingConstraint.constant = self.widthScreen
            self.viewHelperDualLeadingConstraint.constant = self.widthScreen
            self.viewHelperDualTrailingConstraint.constant = -self.widthScreen
            self.backButtonLeadingConstraint.constant = -90
            
            self.view.layoutIfNeeded()
            
        }) { (true) in
            UIView.animate(withDuration: 0.5, animations: {
                
                self.bgRedLeadingConstraint.constant = self.widthScreen
                self.bgRedTrailingConstraint.constant = self.widthScreen
                self.bgBlueLeadingConstraint.constant = self.widthScreen
                self.bgBlueTrailingConstraint.constant = self.widthScreen
                
                self.bgPurpleLeadingConstraint.constant = 0
                self.bgPurpleTopConstraint.constant = 0
                self.bgPurpleBottomConstraint.constant = 0
                self.bgPurpleTrailingConstraint.constant = 0
                
                self.mainIconTopConstraint.constant = 94
                self.mainIconBottomConstraint.constant = 193
                
                self.mainButtonBottomConstraint.constant = 130
                self.tentangButtonTrailingConstraint.constant = 22
                
                
                self.view.layoutIfNeeded()
                
                self.bgPurple.alpha = 1
                self.mainMenuIcon.alpha = 1
                self.buttonMain.alpha = 1
                
                self.buttonMain.isEnabled = true
                self.backButton.isEnabled = false
                self.buttonSingleDevice.isEnabled = false
                self.buttonDualDevice.isEnabled = false
            })
        }
    }
    
    func didLoadAnimate(){
        buttonMain.alpha = 0
        mainMenuIcon.alpha = 0
        bgPurple.alpha = 1
        
        UIView.animate(withDuration: 0.5, animations: {
            self.buttonMain.alpha = 1
            self.mainMenuIcon.alpha = 0.5
        }) { (true) in
            UIView.animate(withDuration: 0.5, animations: {
                self.mainMenuIcon.alpha = 1
            })
        }
        
    }
    // Home Bar
    override func preferredScreenEdgesDeferringSystemGestures() -> UIRectEdge {
        return UIRectEdge.bottom
    }
}
