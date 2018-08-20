//
//  ViewController.swift
//  MC 3
//
//  Created by Yosua Hoo on 14/08/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        UserDefaults.standard.set(usernameTextField.text, forKey: "Username")
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let username = UserDefaults.standard.value(forKey: "Username") as? String{
            usernameTextField.text = username
        }
        usernameTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

