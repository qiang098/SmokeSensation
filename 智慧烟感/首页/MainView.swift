//
//  MainView.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/3.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class MainView: HideNavigation, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var stateBackground: ImageView!
    @IBOutlet weak var tabView: UITableView!
    @IBOutlet weak var qipao: UIView!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var state: UILabel!
    
    var listData = [[String: Any]]() {
        didSet {
            self.tabView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fireStates()
        page = 1
        listData.removeAll()
        getListData()
        
    }
    func fireStates() {
        DataRequestManager().ifFire(withPhoneNo: ("loginResult".get! as! [String: Any])["loginNo"] as! String, success: { (results) in
            let result = results as! [String: Any]
            if result["isSuccess"] as! String == "1" {
                switch result["isFire"] as! String {
                case "1":
                    self.stateBackground.image = #imageLiteral(resourceName: "5")
                    self.state.text = "火警"
                    break
                case "2":
                    self.stateBackground.image = #imageLiteral(resourceName: "4")
                    self.state.text = "故障"
                    break
                case "0":
                    self.stateBackground.image = #imageLiteral(resourceName: "6")
                    self.state.text = "正常"
                    break
                default:
                    self.stateBackground.image = #imageLiteral(resourceName: "3")
                    self.state.text = "离线"
                    break
                }
            } else {
                MBProgressHUD.showInfo(withStatus: result["errorText"] as! String, to: self.navigationController?.view)
            }
        }) { (error) in
            MBProgressHUD.showInfo(withStatus: "网络异常，请检查网络", to: self.navigationController?.view)
        }
    }
    var page = 1
    func getListData() {
        DataRequestManager().getPlaceList(withTel: ("loginResult".get as! [String: Any])["loginNo"] as! String, page: "\(page)", rows: "10", success: { (results) in
            self.tabView.mj_footer.endRefreshing()
            self.tabView.refreshControl?.endRefreshing()
//            self.tabView.dg_stopLoading()
            let result = results as! [String: Any]
            if result["isSuccess"] as! String == "1" {
                if (result["getPlaceList"] as! [[String: Any]]).count != 0 {
                    self.listData += result["getPlaceList"] as! [[String: Any]]
                    self.tabView.hideCell(self.listData.count)
                    self.page += 1
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //下拉刷新
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMethod), for: .valueChanged)
        tabView.refreshControl = refreshControl
        
//        //下拉刷新
//        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
//        loadingView.tintColor = UIColor("48C4EE")
//        tabView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
//
//            self?.page = 1
//            self?.listData.removeAll()
//            self?.getListData()
//
//            }, loadingView: loadingView)
//        tabView.dg_setPullToRefreshFillColor(.white)
//        tabView.dg_setPullToRefreshBackgroundColor(tabView.backgroundColor!)
        
        //上拉刷新
        tabView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
            self.getListData()
            self.fireStates()
        })
    }
    
    @objc func refreshMethod() {
        page = 1
        listData.removeAll()
        getListData()
        fireStates()
    }
    
    @IBAction func addClick(_ sender: UIButton) {
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
        performSegue(withIdentifier: "shebeiliebiao", sender: self)
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shebeiliebiao" {
            let vc = segue.destination as! Shebeiliebiao
            vc.data = listData[tempSelect]
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
