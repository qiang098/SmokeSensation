//
//  SheBeiDetailView.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/19.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

class SheBeiDetailView: CustomBackButton, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var edit: UIBarButtonItem!
    @IBOutlet weak var device: UILabel!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var producer: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var electric: UILabel!
    @IBOutlet weak var signal: UILabel!
    @IBOutlet weak var IMEI: UILabel!
    @IBOutlet weak var place: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var position: UITextField!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var mute: UIButton!
    
    var data: [String: Any]?
    var placeData = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        device.text = data!["deviceType"] as? String
        num.text = data!["deviceId"] as? String
        producer.text = ["海信", "中消云", "日海", "大华"][Int(data!["producer"] as! String)!]
        state.text = data!["deviceStatus"] as? String
        electric.text = data!["eletrict"] as? String
        signal.text = data!["device_signal"] as? String
        IMEI.text = data!["imei"] as? String
        place.setTitle(data!["placeName"] as? String, for: .normal)
        position.text = data!["installAddr"] as? String
        time.text = data!["installDate"] as? String
        
        if data!["deviceStatus"] as! String == "火警" && (data!["producer"] as! String == "0" || data!["producer"] as! String == "2") {
            mute.isHidden = false
        }
    }
    
    var changsuoliebiao: Changsuoliebiao?
    var placeSelect: Int?
    @IBAction func placeClick(_ sender: UIButton) {
        self.view.endEditing(true)
        changsuoliebiao = Bundle.main.loadNibNamed("Changsuoliebiao", owner: nil, options: nil)!.first as? Changsuoliebiao
        changsuoliebiao?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        changsuoliebiao?.tabView.delegate = self
        changsuoliebiao?.tabView.dataSource = self
        changsuoliebiao?.title.text = (sender.tag == 0 ? "场所列表" : "型号列表")
        changsuoliebiao?.cancel.addTarget(self, action: #selector(sureCloseClick(_:)), for: .touchUpInside)
        changsuoliebiao?.sure.addTarget(self, action: #selector(sureCloseClick(_:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(changsuoliebiao!)
        
        placeIndexPath = placeSelect
        
        DataRequestManager().getPlaceList(withTel: ("loginResult".get as! [String: Any])["loginNo"] as! String, page: "", rows: "", success: { (results) in
            let result = results as! [String: Any]
            if result["isSuccess"] as! String == "1" {
                if (result["getPlaceList"] as! [[String: Any]]).count != 0 {
                    self.placeData = result["getPlaceList"] as! [[String: Any]]
                    self.changsuoliebiao?.tabView.reloadData()
                    self.changsuoliebiao?.tabView.hideCell(self.placeData.count)
                } else {
                    MBProgressHUD.showInfo(withStatus: "暂无数据", to: self.view)
                }
            } else {
                MBProgressHUD.showInfo(withStatus: result["errorText"] as! String, to: self.navigationController?.view)
            }
        }) { (error) in
            MBProgressHUD.showInfo(withStatus: "网络异常，请检查网络", to: self.navigationController?.view)
        }
    }
    
    @objc func sureCloseClick(_ button: UIButton) {
        self.view.endEditing(true)
        if button.tag == 1 {
            if placeIndexPath != nil {
                placeSelect = placeIndexPath
                place.setTitleColor(.black, for: .normal)
                place.setTitle(placeData[placeIndexPath!]["placeName"] as? String, for: .normal)
            }
        }
        changsuoliebiao?.removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeData.count
    }
    
    var placeIndexPath: Int?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SheBeiCell", owner: nil, options: nil)!.first as! SheBeiCell
        cell.title.text = placeData[indexPath.row]["placeName"] as? String
        cell.address.text = placeData[indexPath.row]["placeAddr"] as? String
        if indexPath.row == placeIndexPath {
            cell.img.image = #imageLiteral(resourceName: "选中")
        } else {
            cell.img.image = #imageLiteral(resourceName: "未选中拷贝")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        placeIndexPath = indexPath.row
        tableView.reloadData()
        return indexPath
    }
    
    @IBAction func editClick(_ sender: UIBarButtonItem) {
        img.isHidden = !img.isHidden
        place.isEnabled = !place.isEnabled
        place.layer.cornerRadius = 5
        if sender.tag == 0 {
            sender.title = "确认"
            sender.tag = 1
            
            place.contentHorizontalAlignment = .center
            place.backgroundColor = UIColor("F5F5F5")
            position.isEnabled = true
            position.borderStyle = .roundedRect
        } else {
            sender.title = "编辑"
            sender.tag = 0
            
            place.contentHorizontalAlignment = .left
            place.backgroundColor = .white
            position.isEnabled = false
            position.borderStyle = .none
            if placeSelect != nil || data!["installAddr"] as? String != position.text {
                DataRequestManager().updateDevice(withDeviceId: data!["deviceId"] as! String, deviceAddr: position.text!, placeId: (placeSelect != nil ? placeData[placeSelect!]["placeId"] as! String : data!["placeId"] as! String), success: { (results) in
                    let result = results as! [String: Any]
                    if result["isSuccess"] as! String == "1" {
                        MBProgressHUD.showInfo(withStatus: "修改成功", to: self.navigationController?.view)
                    } else {
                        MBProgressHUD.showInfo(withStatus: result["errorText"] as! String, to: self.navigationController?.view)
                    }
                }, failure: { (error) in
                    MBProgressHUD.showInfo(withStatus: "网络异常，请检查网络", to: self.navigationController?.view)
                })
            }
        }
    }
    
    @IBAction func muteClick(_ sender: UIButton) {
        alertShow("提示", "是否消音？", "确定", true) {
            DataRequestManager().getMufflingWithDeviceId(self.data!["deviceId"] as? String, producer: self.data!["producer"] as! String, success: { (results) in
                let result = results as! [String: Any]
                if result["isSuccess"] as! String == "1" {
                    self.mute.isHidden = true
                    MBProgressHUD.showInfo(withStatus: result["errorText"] as! String, to: self.navigationController?.view)
                } else {
                    MBProgressHUD.showInfo(withStatus: result["errorText"] as! String, to: self.navigationController?.view)
                }
            }) { (error) in
                MBProgressHUD.showInfo(withStatus: "网络异常，请检查网络", to: self.navigationController?.view)
            }
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
