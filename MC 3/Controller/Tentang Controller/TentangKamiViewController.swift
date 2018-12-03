//
//  TentangKamiViewController.swift
//  MC 3
//
//  Created by Yosua Hoo on 30/11/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import UIKit

class TentangKamiViewController: UIViewController {
    
    let tentangCongklak = "<html><body><b>Congklak</b> adalah salah satu permainan tradisional yang lumrah di Asia, khususnya di Indonesia. Dakon, Mancala, Congkak, adalah beberapa nama lain untuk permainan congklak.<br><br>Papan congklak terdiri atas 7 lubang di masing - masing sisi, yang berisi 7 biji di setiap lubang, dan 2 lubang rumah di setiap sisi pemain. Setiap pemain mengambil semua biji di salah satu lubang, dan menyebarnya satu per satu secara berurutan. Pemain dengan biji terbanyak di lubang rumahnya, menjadi pemenang.<br><br>Ada salah satu langkah yang dinamakan <b>tembak</b>, dimana jika pemain telah melewati satu putaran, dan biji terakhir jatuh di lubang yang kosong yang berada di sisi pemain tersebut, maka lubang diseberangnya atau di sisi pemain lawan, akan ditembak dan semuanya berpindah ke lubang rumah si pemain dan akan menjadi poin si pemain.<br><br><b>Congklak</b> memiliki filosofi kehidupan sehari-hari, yang dilambangkan oleh 7 lubang (menandakan 7 hari dalam seminggu), dimana langkah menyebar biji satu persatu, diartikan bahwa setiap hari memiliki jatah waktu yang sama. Ketika biji diambil dari satu lubang dan mengisi lubang yang lain, menandakan bahwa tiap hari yang kita jalani, akan mempengaruhi hari - hari selanjutnya.<br><br><b>Congklak</b> memiliki manfaat khususnya melatin aspek kognitif, emosional, dan motorik, khususnya bagi anak - anak. Sehingga permainan ini merupakan salah satu permainan yang bermanfaat dan baik untuk semua orang.<br><br><b>Congklak AR</b> memanfaatkan teknologi Augmented Reality, yang memodernisasi permainan congklak agar tetap lestari dan semakin menarik untuk dimainkan, dengan tetap mempertahankan nilai - nilai dan esensi yang ada dalam congklak.</body></html>"

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func tombolDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 25
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false

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

extension TentangKamiViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.regular && self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.regular {
            
            let sizeCell = rectForText(text: tentangCongklak, font: UIFont.systemFont(ofSize: 51), maxSize: CGSize(width: tableView.frame.width, height: 10000))
            
            print(sizeCell.height)
            
            return sizeCell.height + 1100
        }else{
            
            let sizeCell = rectForText(text: tentangCongklak, font: UIFont.systemFont(ofSize: 18), maxSize: CGSize(width: tableView.frame.width, height: 10000))
            
            print(sizeCell.height)
            
            return sizeCell.height + 550
        }
    }
    
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.font:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: rect.size.width, height: rect.size.height)//(, )
        return size
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell") as! TentangKamiTableViewCell
        
        let content = "<html><body><p style=text-align:justify><font size=40>" + tentangCongklak + "</font></p></body></html>"
        
        cell.contentView.layer.cornerRadius = 25
        cell.contentView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        cell.contentTentangKami.backgroundColor = .clear
        cell.contentTentangKami.scrollView.isScrollEnabled = false
        cell.contentTentangKami.scrollView.backgroundColor = .clear
        cell.contentTentangKami.isOpaque = false
        
        cell.contentTentangKami.loadHTMLString(content, baseURL: nil)
        
        return cell
    }
    
    
}
