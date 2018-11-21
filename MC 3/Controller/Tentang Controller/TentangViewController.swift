//
//  TentangViewController.swift
//  MC 3
//
//  Created by Kennyzi Yusuf on 16/11/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import UIKit

class TentangViewController: UIViewController {
    var angka = 0
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func backToMainMenu(_ sender: Any) {
        performSegue(withIdentifier: "backToMain", sender: self)
    }
    @IBAction func satuPerangkat(_ sender: Any) {
        angka = 1
        performSegue(withIdentifier: "Explanation", sender: self)
    }
    @IBAction func duaPerangkat(_ sender: Any) {
        angka = 2
        performSegue(withIdentifier: "Explanation", sender: self)
    }
    @IBAction func tentangKami(_ sender: Any) {
        angka = 3
        performSegue(withIdentifier: "Explanation", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Explanation" {
            if let explain = segue.destination as? ExplainViewController {
                explain.text = angka
            }
        }
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
