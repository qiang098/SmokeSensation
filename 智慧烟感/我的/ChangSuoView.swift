//
//  ChangSuoView.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/20.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class ChangSuoView: CustomBackButton, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tabView: UITableView!
    
    var listData = [[String: Any]]() {
        didSet {
            self.tabView.reloadData()
        }
    }
    
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
        DataRequestManager().getPlaceList(withTel: ("loginResult".get as! [String: Any])["loginNo"] as! String, page: "1", rows: "1000", success: { (results) in
            self.tabView.dg_stopLoading()
            let result = results as! [String: Any]
            if result["isSuccess"] as! String == "1" {
                if (result["getPlaceList"] as! [[String: Any]]).count != 0 {
                    self.listData = result["getPlaceList"] as! [[String: Any]]
                    self.tabView.hideCell(self.listData.count)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MainViewCell
        let data = listData[indexPath.row]
        cell.title.text = data["placeName"] as? String
        cell.address.text = data["placeAddr"] as? String
        switch data["statusp"] as! String {
        case "1":
            cell.state.textColor = .red
            cell.state.text = "火警"
            break
        case "2":
            cell.state.textColor = .orange
            cell.state.text = "故障"
            break
        case "3":
            cell.state.textColor = .green
            cell.state.text = "正常"
            break
        default:
            cell.state.textColor = UIColor("999999")
            cell.state.text = "离线"
            break
        }
        cell.delete.tag = indexPath.row
        cell.delete.addTarget(self, action: #selector(deleteClick(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteClick(_ button: UIButton) {
        alertShow("提示", "确认删除该场所", "确认", true) {
            DataRequestManager().deletePlace(withPlaceId: self.listData[button.tag]["placeId"] as! String, success: { (results) in
                let result = results as! [String: Any]
                if result["isSuccess"] as! String == "1" {
                    self.listData.remove(at: button.tag)
                    MBProgressHUD.showInfo(withStatus: "删除成功", to: self.navigationController?.view)
                } else {
                    MBProgressHUD.showInfo(withStatus: result["errorText"] as! String, to: self.navigationController?.view)
                }
            }) { (error) in
                MBProgressHUD.showInfo(withStatus: "网络异常，请检查网络", to: self.navigationController?.view)
            }
        }
    }
    
    var tempSelect = Int()
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tempSelect = indexPath.row
        performSegue(withIdentifier: "detail", sender: self)
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let vc = segue.destination as! PlaceDetail
            vc.data = listData[tempSelect]
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
