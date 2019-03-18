//
//  ShebeiliebiaoCell2.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/26.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

class ShebeiliebiaoCell2: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var mute: UIButton!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var muteBig: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
