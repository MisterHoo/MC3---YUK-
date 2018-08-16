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
    @IBOutlet weak var lockButtonOutlet: UIButton!
    
    @IBAction func backButtonAction(_ sender: UIButton)
    {
        performSegue(withIdentifier: "gameToMenu", sender: self)
    }
    
    
    @IBAction func lockButtonAction(_ sender: UIButton)
    {
        if lockButtonOutlet.currentImage == UIImage(named: "Unlocked")
        {
            lockButtonOutlet.setImage(UIImage(named: "Locked"), for: .normal)
        }else{
            lockButtonOutlet.setImage(UIImage(named: "Unlocked"), for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lockButtonOutlet.setImage(UIImage(named: "Unlocked"), for: .normal)
        
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
