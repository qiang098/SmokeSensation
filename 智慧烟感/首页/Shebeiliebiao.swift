//
//  Shebeiliebiao.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/17.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class Shebeiliebiao: CustomBackButton, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tabView: UITableView!
    
    var data: [String: Any]?
    var listData = [[String: Any]]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //下拉刷新
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = .white
        tabView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.getListData()
            }, loadingView: loadingView)
        tabView.dg_setPullToRefreshFillColor(.black)
        tabView.dg_setPullToRefreshBackgroundColor(tabView.backgroundColor!)
    }
    
    func getListData() {
        if data != nil {
            DataRequestManager().getDeviceList(withPlaceId: data!["placeId"] as! String, page: "1", rows: "1000", success: { (results) in
                self.tabView.dg_stopLoading()
                self.listData.removeAll()
                let result = results as! [String: Any]
                if result["isSuccess"] as! String == "1" {
                    if (result["getDeviceList"] as! [[String: Any]]).count != 0 {
                        self.listData = result["getDeviceList"] as! [[String: Any]]
                        self.tabView.hideCell(self.listData.count)
                    } else {
                        MBProgressHUD.showInfo(withStatus: "暂无数据", to: self.view)
                    }
                    self.tabView.reloadData()
                } else {
                    MBProgressHUD.showInfo(withStatus: result["errorText"] as! String, to: self.navigationController?.view)
                }
            }, failure: { (error) in
                MBProgressHUD.showInfo(withStatus: "网络异常，请检查网络", to: self.navigationController?.view)
            })
        } else {
            DataRequestManager().getAllDeviceList(("loginResult".get as! [String: Any])["loginNo"] as! String, page: "1", rows: "1000", success: { (results) in
                self.tabView.dg_stopLoading()
                let result = results as! [String: Any]
                if result["isSuccess"] as! String == "1" {
                    if (result["getDeviceList"] as! [[String: Any]]).count != 0 {
                        self.listData = result["getDeviceList"] as! [[String: Any]]
                        self.tabView.hideCell(self.listData.count)
                    } else {
                        MBProgressHUD.showInfo(withStatus: "暂无数据", to: self.view)
                    }
                    self.tabView.reloadData()
                } else {
                    MBProgressHUD.showInfo(withStatus: result["errorText"] as! String, to: self.navigationController?.view)
                }
            }, failure: { (error) in
                MBProgressHUD.showInfo(withStatus: "网络异常，请检查网络", to: self.navigationController?.view)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if listData[indexPath.row]["deviceStatus"] as! String == "火警" && (listData[indexPath.row]["producer"] as! String == "0" || listData[indexPath.row]["producer"] as! String == "2" || listData[indexPath.row]["producer"] as! String == "3") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! ShebeiliebiaoCell2
            cell.title.text = listData[indexPath.row]["deviceType"] as? String
            cell.address.text = listData[indexPath.row]["installAddr"] as? String
            cell.mute.tag = indexPath.row
            cell.muteBig.tag = indexPath.row
            cell.mute.addTarget(self, action: #selector(muteClick(_:)), for: .touchUpInside)
            cell.muteBig.addTarget(self, action: #selector(muteClick(_:)), for: .touchUpInside)
            switch listData[indexPath.row]["deviceStatus"] as! String {
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
            cell.state.text = listData[indexPath.row]["deviceStatus"] as? String
            cell.delete.tag = indexPath.row
            cell.delete.addTarget(self, action: #selector(deleteClick(_:)), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ShebeiliebiaoCell
            cell.title.text = listData[indexPath.row]["deviceType"] as? String
            cell.address.text = listData[indexPath.row]["installAddr"] as? String
            switch listData[indexPath.row]["deviceStatus"] as! String {
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
            cell.state.text = listData[indexPath.row]["deviceStatus"] as? String
            cell.delete.tag = indexPath.row
            cell.delete.addTarget(self, action: #selector(deleteClick(_:)), for: .touchUpInside)
            return cell
        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ShebeiliebiaoCell
//        cell.title.text = listData[indexPath.row]["deviceType"] as? String
//        cell.address.text = listData[indexPath.row]["installAddr"] as? String
//        switch listData[indexPath.row]["deviceStatus"] as! String {
//        case "火警":
//            cell.state.textColor = .red
//            break
//        case "离线":
//            cell.state.textColor = UIColor("999999")
//            break
//        case "故障":
//            cell.state.textColor = .orange
//            break
//        case "正常":
//            cell.state.textColor = .green
//            break
//        default:
//            cell.state.textColor = .black
//            break
//        }
//        cell.state.text = listData[indexPath.row]["deviceStatus"] as? String
//        cell.delete.tag = indexPath.row
//        cell.delete.addTarget(self, action: #selector(deleteClick(_:)), for: .touchUpInside)
//        return cell
    }
    
    @objc func muteClick(_ sender: UIButton) {
        alertShow("提示", "是否消音？", "确定", true) {
            DataRequestManager().getMufflingWithDeviceId(self.listData[sender.tag]["deviceId"] as! String, producer: self.listData[sender.tag]["producer"] as! String, success: { (results) in
                let result = results as! [String: Any]
                if result["isSuccess"] as! String == "1" {
                    self.getListData()
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
            DataRequestManager().delDevice(withDeviceId: self.listData[button.tag]["deviceId"] as! String, producer: self.listData[button.tag]["producer"] as! String, success: { (results) in
                let result = results as! [String: Any]
                if result["isSuccess"] as! String == "1" {
                    self.listData.remove(at: button.tag)
                    self.tabView.reloadData()
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
        select = indexPath.row
        if listData[indexPath.row]["producer"] as! String == "1" {
            performSegue(withIdentifier: "detail2", sender: self)
        } else {
            performSegue(withIdentifier: "detail", sender: self)
        }
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let vc = segue.destination as! SheBeiDetailView
            vc.data = listData[select]
        }
        if segue.identifier == "detail2" {
            let vc = segue.destination as! SheBeiDetailView2
            vc.data = listData[select]
        }
    }
    
    @IBAction func addClick(_ sender: UIBarButtonItem) {
        //
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
