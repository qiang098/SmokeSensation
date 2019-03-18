//
//  Telephone.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/3.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

class Telephone: CustomBackButton {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "tel:"+"4000-123-123")!, options: [:], completionHandler: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
