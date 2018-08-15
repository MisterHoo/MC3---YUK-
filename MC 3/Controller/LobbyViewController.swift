//
//  LobbyViewController.swift
//  MC 3
//
//  Created by Rhesa Febrin Saputra on 8/15/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var backgroundButton: UIImageView!
    @IBOutlet weak var ikutButtonOutlet: UIButton!
    @IBOutlet weak var batalButtonOutlet: UIButton!
    
    
    @IBAction func ikutButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "lobbyToGame", sender: self)
    }
    
    
    @IBAction func batalButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "lobbyToMenu", sender: self)
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
