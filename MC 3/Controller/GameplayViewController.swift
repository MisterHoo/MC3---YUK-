//
//  GameplayViewController.swift
//  MC 3
//
//  Created by Rhesa Febrin Saputra on 8/15/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import UIKit

class GameplayViewController: UIViewController {

    @IBOutlet weak var backButtonOutlet: UIButton!
    
    @IBAction func backButtonAction(_ sender: UIButton)
    {
        performSegue(withIdentifier: "gameToMenu", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
