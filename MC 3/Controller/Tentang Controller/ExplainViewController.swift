//
//  ExplainViewController.swift
//  MC 3
//
//  Created by Kennyzi Yusuf on 16/11/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import UIKit

class ExplainViewController: UIViewController, UIScrollViewDelegate {
    
    var text = 0
    var imageArray = [UIImage]()
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var cobaLabel: UILabel!
    @IBOutlet weak var pageControll: UIPageControl!
    
    var tutorialText = ["satu","dua","tiga","empat", "lima"]
    override func viewDidLoad() {
        
        super.viewDidLoad()
        pageControll.layer.cornerRadius = 10
//        mainScrollView.frame = view.frame
        switch text {
        case 1:
            imageArray = [#imageLiteral(resourceName: "1p step 1"),#imageLiteral(resourceName: "1p step 2"),#imageLiteral(resourceName: "1p step 3"),#imageLiteral(resourceName: "1p step 4"),#imageLiteral(resourceName: "1p step 5")]
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
            let xPosition = mainScrollView.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height)
            
            mainScrollView.contentSize.width = mainScrollView.frame.width * CGFloat(i + 1)
            mainScrollView.addSubview(imageView)
        }
        pageControll.numberOfPages = imageArray.count
        self.mainScrollView.delegate = self
        let labelTulis = String(text)
        cobaLabel.text = labelTulis
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControll.currentPage = Int(pageNumber)
        
        switch pageNumber
        {
        case 0:
            cobaLabel.text = tutorialText[0]
            break
        case 1:
            cobaLabel.text = tutorialText[1]
            break
        case 2:
            cobaLabel.text = tutorialText[2]
            break
        case 3:
            cobaLabel.text = tutorialText[3]
            break
        case 4:
            cobaLabel.text = tutorialText[4]
            break
        default:
            break
        }
        
    }


    @IBAction func backToTentang(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
