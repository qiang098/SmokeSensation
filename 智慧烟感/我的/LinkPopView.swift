//
//  LinkPopView.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/21.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

class LinkPopView: UIView {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var telephone: UITextField!
    @IBOutlet weak var linkman: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var sure: UIButton!
    
    @IBAction func tapClick(_ sender: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
