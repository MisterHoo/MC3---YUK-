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
    
    var tutorialTextSolo = ["Tekan Tombol Main"
        ,"Pilih “Satu Perangkat”"
        ,"Cari bidang datar, sampai muncul bidang persegi berwarna putih di layar perangkat"
        ,"Tekan Bidang tersebut untuk meletakkan papan congklak"
        , " Congklak Muncul! Selamat Bermain!"]
    var tutorialTextDuo = ["Tekan Tombol Main","Pilih “Dua Perangkat”"
        ,"Untuk bermain bersama, tekan “gabung” pada salah satu perangkat, hingga muncul jendela baru"
        ,"Cari perangkat , dan tekan nama perangkat tersebut untuk gabung dalam permainan perangkat lain"
        , "Tunggu hingga muncul tulisan connected, lalu tekan done"
        ,"Pemain yang bergabung akan menjadi P2, dan pemain lainnya akan menjadi P1"
        ," Untuk pemain P1, cari bidang datar, sampai muncul bidang persegi berwarna putih di layar perangkat."
        ,"Tekan bidang tersebut untuk meletakkan papan congklak"
        ," Untuk pemain P2, arahkan perangkat dari sudut kamera yang sama, hingga muncul papan congklak secara otomatis"
        ,"Selamat Bermain!","NB : Jika gagal dalam mencari papan congklak, silahkan ulangi dari awal"]
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
        
        if text == 1 {
            cobaLabel.text = tutorialTextSolo[Int(pageNumber)]
        }else if(text == 2) {
            cobaLabel.text = tutorialTextDuo[Int(pageNumber)]
        }
        
        
    }


    @IBAction func backToTentang(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
