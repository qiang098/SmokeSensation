//
//  SheBeiView.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/17.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

class SheBeiView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var placeList: UITableView!
    @IBOutlet weak var deviceList: UITableView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var add: UIBarButtonItem!
    @IBOutlet weak var qipao: UIView!
    
    var listData = [[String: Any]]() {
        didSet {
            self.placeList.reloadData()
        }
    }
    
    var data = [[String: Any]]() {
        didSet {
            self.number.text = "场所设备总数: \(self.data.count)"
            self.deviceList.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func getData() {
        DataRequestManager().getPlaceList(withTel: ("loginResult".get as! [String: Any])["loginNo"] as! String, page: "1", rows: "1000", success: { (results) in
            let result = results as! [String: Any]
            if result["isSuccess"] as! String == "1" {
                if (result["getPlaceList"] as! [[String: Any]]).count != 0 {
                    self.listData = result["getPlaceList"] as! [[String: Any]]
                    self.placeList.hideCell(self.listData.count, .white)
                    self.placeSelect = 0
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
    
    @IBAction func addClick(_ sender: UIBarButtonItem) {
        if sender.tag == 0 {
            qipao.isHidden = false
            sender.tag = 1
        } else {
            qipao.isHidden = true
            sender.tag = 0
        }
    }
    
    @IBAction func sheBeiChangSuo(_ sender: UIButton) {
        
        if sender.tag == 0 {
            performSegue(withIdentifier: "shebei", sender: self)
        } else {
            performSegue(withIdentifier: "changsuo", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == placeList {
            return 50
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == placeList {
            return listData.count
        } else {
            return data.count
        }
    }
    
    var placeSelect = 0 {
        didSet {
            placeList.reloadData()
            placeName.text = listData[placeSelect]["placeName"] as? String
            
            DataRequestManager().getDeviceList(withPlaceId: listData[placeSelect]["placeId"] as! String, page: "1", rows: "1000", success: { (results) in
                self.data.removeAll()
                let result = results as! [String: Any]
                if result["isSuccess"] as! String == "1" {
                    if (result["getDeviceList"] as! [[String: Any]]).count != 0 {
                        self.data = result["getDeviceList"] as! [[String: Any]]
                        self.deviceList.hideCell(self.data.count)
                    } else {
                        MBProgressHUD.showInfo(withStatus: "暂无数据", to: self.view)
                    }
                } else {
                    MBProgressHUD.showInfo(withStatus: result["errorText"] as! String, to: self.navigationController?.view)
                }
            }, failure: { (error) in
                MBProgressHUD.showInfo(withStatus: "网络异常，请检查网络", to: self.navigationController?.view)
            })
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == placeList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PlaceListCell
            cell.place.text = listData[indexPath.row]["placeName"] as? String
            if indexPath.row == placeSelect {
                cell.backgroundColor = .white
                cell.place.textColor = UIColor("3B96FC")
            } else {
                cell.backgroundColor = UIColor("DCDDDE")
                cell.place.textColor = UIColor("666666")
            }
            return cell
        } else {
            if data[indexPath.row]["deviceStatus"] as! String == "火警" && (data[indexPath.row]["producer"] as! String == "0" || data[indexPath.row]["producer"] as! String == "2" || data[indexPath.row]["producer"] as! String == "3") {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! ShebeiliebiaoCell2
                cell.title.text = data[indexPath.row]["deviceType"] as? String
                cell.address.text = data[indexPath.row]["installAddr"] as? String
                cell.mute.tag = indexPath.row
                cell.muteBig.tag = indexPath.row
                cell.mute.addTarget(self, action: #selector(muteClick(_:)), for: .touchUpInside)
                cell.muteBig.addTarget(self, action: #selector(muteClick(_:)), for: .touchUpInside)
                switch data[indexPath.row]["deviceStatus"] as! String {
                case "火警":
                    cell.state.textColor = .red
                    break
                case "离线":
                    cell.state.textColor = UIColor("999999")
                    break
                case "故障":
                    cell.state.textColor = .orange
                    break
                case "正常":
                    cell.state.textColor = .green
                    break
                default:
                    cell.state.textColor = .black
                    break
                }
                cell.state.text = data[indexPath.row]["deviceStatus"] as? String
                cell.delete.tag = indexPath.row
                cell.delete.addTarget(self, action: #selector(deleteClick(_:)), for: .touchUpInside)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ShebeiliebiaoCell
                cell.title.text = data[indexPath.row]["deviceType"] as? String
                cell.address.text = data[indexPath.row]["installAddr"] as? String
                switch data[indexPath.row]["deviceStatus"] as! String {
                case "火警":
                    cell.state.textColor = .red
                    break
                case "离线":
                    cell.state.textColor = UIColor("999999")
                    break
                case "故障":
                    cell.state.textColor = .orange
                    break
                case "正常":
                    cell.state.textColor = .green
                    break
                default:
                    cell.state.textColor = .black
                    break
                }
                cell.state.text = data[indexPath.row]["deviceStatus"] as? String
                cell.delete.tag = indexPath.row
                cell.delete.addTarget(self, action: #selector(deleteClick(_:)), for: .touchUpInside)
                return cell
            }
        }
    }
    
    @objc func muteClick(_ sender: UIButton) {
        alertShow("提示", "是否消音？", "确定", true) {
            DataRequestManager().getMufflingWithDeviceId(self.data[sender.tag]["deviceId"] as! String, producer: self.data[sender.tag]["producer"] as! String, success: { (results) in
                let result = results as! [String: Any]
                if result["isSuccess"] as! String == "1" {
                    self.getData()
                    MBProgressHUD.showInfo(withStatus: result["errorText"] as! String, to: self.navigationController?.view)
                } else {
                    MBProgressHUD.showInfo(withStatus: result["errorText"] as! String, to: self.navigationController?.view)
                }
            }) { (error) in
                MBProgressHUD.showInfo(withStatus: "网络异常，请检查网络", to: self.navigationController?.view)
            }
        }
    }
    
    @objc func deleteClick(_ button: UIButton) {
        alertShow("提示", "确认删除该设备", "确认", true) {
            DataRequestManager().delDevice(withDeviceId: self.data[button.tag]["deviceId"] as! String, producer: self.data[button.tag]["producer"] as! String, success: { (results) in
                let result = results as! [String: Any]
                if result["isSuccess"] as! String == "1" {
                    self.data.remove(at: button.tag)
                    MBProgressHUD.showInfo(withStatus: "删除成功", to: self.navigationController?.view)
                } else {
                    MBProgressHUD.showInfo(withStatus: result["errorText"] as! String, to: self.navigationController?.view)
                }
            }) { (error) in
                MBProgressHUD.showInfo(withStatus: "网络异常，请检查网络", to: self.navigationController?.view)
            }
        }
    }
    
    var select = 0
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView == placeList {
            placeSelect = indexPath.row
        } else {
            select = indexPath.row
            if data[indexPath.row]["producer"] as! String == "1" {
                performSegue(withIdentifier: "detail2", sender: self)
            } else {
                performSegue(withIdentifier: "detail", sender: self)
            }
        }
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let vc = segue.destination as! SheBeiDetailView
            vc.data = self.data[select]
        }
        if segue.identifier == "detail2" {
            let vc = segue.destination as! SheBeiDetailView2
            vc.data = self.data[select]
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        qipao.isHidden = true
        add.tag = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        qipao.isHidden = true
        add.tag = 0
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
