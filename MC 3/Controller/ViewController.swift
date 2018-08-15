//
//  ViewController.swift
//  MC 3
//
//  Created by Yosua Hoo on 14/08/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuSlider: UIPageControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var ikutButtonOutlet: UIButton!
    @IBOutlet weak var mainButtonOutlet: UIButton!
    
    @IBAction func ikutButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "menuToLobby", sender: self)
    }
    
    @IBAction func mainButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "menuToGame", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("berhasil")
        print("test rhesa push")
        print("test rhesa commit")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

