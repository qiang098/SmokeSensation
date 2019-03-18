//
//  LinkmanCell.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/21.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

class LinkmanCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var telephone: UILabel!
    @IBOutlet weak var delete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
