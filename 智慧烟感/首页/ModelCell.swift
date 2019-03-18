//
//  ModelCell.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/19.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

class ModelCell: UITableViewCell {

    @IBOutlet weak var modelNum: UILabel!
    @IBOutlet weak var select: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
