//
//  PlaceDetail.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/20.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

class PlaceDetail: CustomBackButton {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var telephone: UILabel!
    @IBOutlet weak var state: UILabel!
    
    var data: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if data != nil {
            switch data!["statusp"] as! String {
            case "1":
                state.textColor = .red
                state.text = "火警"
                break
            case "2":
                state.textColor = .orange
                state.text = "故障"
                break
            case "3":
                state.textColor = .blue
                state.text = "正常"
                break
            default:
                state.textColor = UIColor("91CDEF")
                state.text = "离线"
                break
            }
            name.text = data!["placeName"] as? String
            address.text = data!["placeAddr"] as? String
            area.text = data!["regionCode"] as? String
            owner.text = data!["manager"] as? String
            telephone.text = data!["managerPhone"] as? String
        }
    }
    
    @IBAction func linkmanClick(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "linkman", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "linkman" {
            let vc = segue.destination as! LinkmanView
            vc.placeId = self.data!["placeId"] as? String
        }
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
