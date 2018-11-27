//
//  ExplainViewController.swift
//  MC 3
//
//  Created by Kennyzi Yusuf on 16/11/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import UIKit

class ExplainViewController: UIViewController {
    var text = 0
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var cobaLabel: UILabel!
    var imageArray = [UIImage]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mainScrollView.frame = view.frame
        switch text {
        case 1:
            imageArray = [#imageLiteral(resourceName: "BG Splash & Main Menu - ungu"),#imageLiteral(resourceName: "BG Duo"),#imageLiteral(resourceName: "BG Solo")]
        case 2:
            imageArray = [#imageLiteral(resourceName: "BG Duo"),#imageLiteral(resourceName: "BG Splash & Main Menu - ungu"),#imageLiteral(resourceName: "BG Solo Ipad")]
        case 3:
            imageArray = [#imageLiteral(resourceName: "BG Solo Ipad"),#imageLiteral(resourceName: "BG Duo")]
        default:
            break
        }
    
        for i in 0..<imageArray.count{
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            imageView.contentMode = .scaleAspectFit
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height)
            
            mainScrollView.contentSize.width = mainScrollView.frame.width * CGFloat(i + 1)
            mainScrollView.addSubview(imageView)
        }
        let labelTulis = String(text)
        cobaLabel.text = labelTulis
    }

    @IBAction func backToTentang(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
