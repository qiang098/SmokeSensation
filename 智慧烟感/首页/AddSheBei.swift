//
//  AddSheBei.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/3.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit
import swiftScan
import Photos

class AddSheBei: CustomBackButton, UITableViewDataSource, UITableViewDelegate, LBXScanViewControllerDelegate {
    
    @IBOutlet weak var place: UIButton!
    @IBOutlet weak var model: UIButton!
    @IBOutlet weak var num: UITextField!
    @IBOutlet weak var position: UITextField!
    
    var placeData = [[String: Any]]()
    var modelData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelData = ["海信(JTYJ-GD-HS90BW/NB)", "中消云(JTY-GF-TX3190-NB)", "日海（JD-SD51)","大华(DH-HY-SA-K723-EN)"]
        DataRequestManager().getPlaceList(withTel: ("loginResult".get as! [String: Any])["loginNo"] as! String, page: "", rows: "", success: { (results) in
            let result = results as! [String: Any]
            if result["isSuccess"] as! String == "1" {
                if (result["getPlaceList"] as! [[String: Any]]).count != 0 {
                    self.placeData = result["getPlaceList"] as! [[String: Any]]
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var changsuoliebiao: Changsuoliebiao?
    var tempTag = 0
    @IBAction func btnClick(_ sender: UIButton) {
        self.view.endEditing(true)
        changsuoliebiao = Bundle.main.loadNibNamed("Changsuoliebiao", owner: nil, options: nil)!.first as? Changsuoliebiao
        changsuoliebiao?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        changsuoliebiao?.tabView.delegate = self
        changsuoliebiao?.tabView.dataSource = self
        changsuoliebiao?.title.text = (sender.tag == 0 ? "场所列表" : "型号列表")
        changsuoliebiao?.cancel.addTarget(self, action: #selector(closeWindow(_:)), for: .touchUpInside)
        tempTag = sender.tag
        changsuoliebiao?.sure.addTarget(self, action: #selector(sureClick(_:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(changsuoliebiao!)
        
        placeIndexPath = placeSelect
        modelIndexPath = modelSelect
        self.changsuoliebiao?.tabView.reloadData()
        self.changsuoliebiao?.tabView.hideCell(sender.tag == 0 ? self.placeData.count : self.modelData.count)
    }
    
    var placeSelect: Int?
    var modelSelect: Int?
    @objc func sureClick(_ button: UIButton) {
        if tempTag == 0 {
            if placeIndexPath != nil {
                placeSelect = placeIndexPath
                place.setTitleColor(.black, for: .normal)
                place.setTitle(placeData[placeIndexPath!]["placeName"] as? String, for: .normal)
            }
        } else {
            if modelIndexPath != nil {
                modelSelect = modelIndexPath
                model.setTitleColor(.black, for: .normal)
                model.setTitle(modelData[modelIndexPath!], for: .normal)
            }
        }
        changsuoliebiao?.removeFromSuperview()
    }
    
    @objc func closeWindow(_ button: UIButton) {
        changsuoliebiao?.removeFromSuperview()
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if num.text == "" || position.text == "" || placeSelect == nil || modelSelect == nil {
            MBProgressHUD.showInfo(withStatus: "请将信息填写完整", to: self.navigationController?.view)
        } else {
            DataRequestManager().addDevice(withDeviceId: num.text!, deviceAddr: position.text!, placeId: placeData[placeSelect!]["placeId"] as! String, producer: "\(modelSelect!)", success: { (results) in
                let result = results as! [String: Any]
                if result["isSuccess"] as! String == "1" {
                    self.alertShow("提示", result["errorText"] as? String, "知道了") {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    MBProgressHUD.showInfo(withStatus: result["errorText"] as! String, to: self.navigationController?.view)
                }
            }, failure: { (error) in
                MBProgressHUD.showInfo(withStatus: "网络异常，请检查网络", to: self.navigationController?.view)
            })
        }
    }
    
    @IBAction func scan(_ sender: UIButton) {
        
        InnerStyle()
    }
    
    // MARK: - ---无边框，内嵌4个角 -----
    func InnerStyle() {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner
        style.photoframeLineW = 3
        style.photoframeAngleW = 18
        style.photoframeAngleH = 18
        style.isNeedShowRetangle = false
        
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove
        
        //qq里面的线条图片
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_light_green")
        
        let vc = LBXScanViewController()
        vc.scanStyle = style
        vc.scanResultDelegate = self
        vc.isOpenInterestRect = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        num.text = scanResult.strScanned
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tempTag == 0 {
            return 70
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tempTag == 0 {
            return placeData.count
        } else {
            return modelData.count
        }
    }
    
    var placeIndexPath: Int?
    var modelIndexPath: Int?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tempTag == 0 {
            let cell = Bundle.main.loadNibNamed("SheBeiCell", owner: nil, options: nil)!.first as! SheBeiCell
            cell.title.text = placeData[indexPath.row]["placeName"] as? String
            cell.address.text = placeData[indexPath.row]["placeAddr"] as? String
            if indexPath.row == placeIndexPath {
                cell.img.image = #imageLiteral(resourceName: "选中")
            } else {
                cell.img.image = #imageLiteral(resourceName: "未选中拷贝")
            }
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("ModelCell", owner: nil, options: nil)!.first as! ModelCell
            if indexPath.row == modelIndexPath {
                cell.select.text = "✔"
            } else {
                cell.select.text = ""
            }
            cell.modelNum.text = modelData[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tempTag == 0 {
            placeIndexPath = indexPath.row
        } else {
            modelIndexPath = indexPath.row
        }
        tableView.reloadData()
        return indexPath
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
