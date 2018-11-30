//
//  TentangKamiTableViewCell.swift
//  MC 3
//
//  Created by Yosua Hoo on 30/11/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import UIKit
import WebKit

class TentangKamiTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var contentTentangKami: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
