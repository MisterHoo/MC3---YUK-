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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var imageArray = [UIImage]()
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
//            browserViewController.delegate = self
//            self.isServer = false
//            NotificationCenter.default.post(name: Notification.Name(rawValue: "MOVE"), object: nil)
        }
    }
    
    @objc func moveToGameVC(){
        print("bener")
        self.performSegue(withIdentifier: "menuToGame", sender: self)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: false, completion: nil)
    }
    
    //VC

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
        multiPeer.hosting()
        isServer = true
        performSegue(withIdentifier: "menuToGame", sender: self)
    }
    
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
        
        multiPeer = (UIApplication.shared.delegate as! AppDelegate).multiPeer
        
        if let username = UserDefaults.standard.value(forKey: "Username") as? String{
            usernameTextField.text = username
            //multiPeer.namaPlayer = username
        }
        //multiPeer.setupPeerId()
        multiPeer.setupPeerId()
        usernameTextField.delegate = self
        
        imageArray = [UIImage(named: "AssetCongklak"),UIImage(named: "AssetGundu"),UIImage(named: "AssetGasing")] as! [UIImage]
        
        print(scrollView.frame.width)
        print(scrollView.frame.height)
        
        for i in 0..<imageArray.count
        {
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            let xPosition = self.scrollView.frame.width * CGFloat(i)
            print("\(xPosition)")
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.scrollView.bounds.width, height: self.scrollView.bounds.height)
            imageView.contentMode = .scaleAspectFit
            
            imageView.translatesAutoresizingMaskIntoConstraints = true

            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            
            scrollView.addSubview(imageView)
        }
        self.scrollView.delegate = self
       
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        
    }
    
    
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        if let location = touch?.location(in: scrollView){
//            
//        }
//        usernameTextField.resignFirstResponder()
//    }
    
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

