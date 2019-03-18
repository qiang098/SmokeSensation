//
//  NewView.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/3.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class NewView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tabView: UITableView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    
    var tempBtn = UIButton() {
        didSet {
            tabView.reloadData()
        }
    }
    var lab_select: UILabel?
    
    var listData12 = [[String: Any]]() {
        didSet {
            tabView.reloadData()
        }
    }
    
    var listData3 = [[String: Any]]() {
        didSet {
            tabView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tempBtn = btn1
        
        lab_select = UILabel(frame: CGRect(x: 0, y: btn1.frame.maxY, width: UIScreen.main.bounds.width/3, height: 2))
        lab_select?.backgroundColor = UIColor("057AFF")
        self.view.addSubview(lab_select!)
        
        tabView.hideCell(5)
        
        //下拉刷新
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = .white
        tabView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.getDataMethod((self?.tempBtn.tag)!)
            }, loadingView: loadingView)
        tabView.dg_setPullToRefreshFillColor(.black)
        tabView.dg_setPullToRefreshBackgroundColor(tabView.backgroundColor!)
        
        self.getDataMethod(tempBtn.tag)
    }
    
    @IBAction func allBtnClick(_ sender: UIButton) {
        if sender != tempBtn {
            sender.setTitleColor(UIColor("0579FB"), for: .normal)
            tempBtn.setTitleColor(.black, for: .normal)
            switch sender.tag {
            case 1:
                UIView.animate(withDuration: 0.2, animations: {
                    self.lab_select?.frame.origin.x = 0
                })
                break
            case 2:
                UIView.animate(withDuration: 0.2, animations: {
                    self.lab_select?.frame.origin.x = UIScreen.main.bounds.width/3
                })
                break
            default:
                UIView.animate(withDuration: 0.2, animations: {
                    self.lab_select?.frame.origin.x = UIScreen.main.bounds.width/3*2
                })
                break
            }
            tempBtn = sender
            
            getDataMethod(sender.tag)
        }
    }
    
    func getDataMethod(_ tag: Int) {
        let loginResult = "loginResult".get as! [String: Any]
        if tag != 3 {
            DataRequestManager().getDeviceWarnInfoList(withTel: loginResult["loginNo"] as! String, type: "\(tag)", page: "1", rows: "1000", success: { (results) in
                self.tabView.dg_stopLoading()
                self.listData12.removeAll()
                let result = results as! [String: Any]
                if result["isSuccess"] as! String == "1" {
                    if (result["getDeviceWarnInfoList"] as! [[String: Any]]).count != 0 {
                        self.listData12 = result["getDeviceWarnInfoList"] as! [[String: Any]]
                        self.tabView.hideCell(self.listData12.count)
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
            DataRequestManager().getPushList(withPhoneNo: loginResult["loginNo"] as! String, success: { (results) in
                self.tabView.dg_stopLoading()
                self.listData3.removeAll()
                let result = results as! [String: Any]
                if result["isSuccess"] as! String == "1" {
                    if (result["getPushList"] as! [[String: Any]]).count != 0 {
                        self.listData3 = result["getPushList"] as! [[String: Any]]
                        self.tabView.hideCell(self.listData3.count)
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tempBtn.tag != 3 {
            return listData12.count
        } else {
            return listData3.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NewCell
        if tempBtn.tag != 3 {
            cell.img0.image = #imageLiteral(resourceName: "19"); cell.img1.image = #imageLiteral(resourceName: "13"); cell.img2.image = #imageLiteral(resourceName: "2"); cell.img3.image = #imageLiteral(resourceName: "27"); cell.img4.image = #imageLiteral(resourceName: "10")
            cell.lab0.text = listData12[indexPath.section]["placeName"] as? String
            cell.lab1.text = listData12[indexPath.section]["devicePosition"] as? String
            cell.lab2.text = listData12[indexPath.section]["happenTime"] as? String
            cell.lab3.text = listData12[indexPath.section]["deviceName"] as? String
            cell.lab4.text = listData12[indexPath.section]["stateName"] as? String
            if listData12[indexPath.section]["stateName"] as? String == "火警" && listData12[indexPath.section]["dealResult"] as? String == nil {
                cell.btn.isHidden = false
                cell.btn.tag = indexPath.section
                cell.btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
            } else {
                cell.btn.isHidden = true
            }
            cell.lab4.textColor = .red
        } else {
            cell.img0.image = #imageLiteral(resourceName: "16"); cell.img1.image = #imageLiteral(resourceName: "1"); cell.img2.image = #imageLiteral(resourceName: "2"); cell.img3.image = #imageLiteral(resourceName: "8"); cell.img4.image = #imageLiteral(resourceName: "7")
            cell.lab0.text = listData3[indexPath.section]["num"] as? String
            cell.lab1.text = listData3[indexPath.section]["type"] as? String
            cell.lab2.text = listData3[indexPath.section]["in_date"] as? String
            cell.lab3.text = listData3[indexPath.section]["pushStatus"] as? String
            cell.lab4.text = listData3[indexPath.section]["flag"] as? String
            cell.lab4.textColor = .black
            cell.btn.isHidden = true
        }
        return cell
    }
    
    var sureState: SureState?
    var btnSelect = 0
    @objc func btnClick(_ button: UIButton) {
        btnSelect = button.tag
        sureState = Bundle.main.loadNibNamed("SureState", owner: nil, options: nil)?.first as? SureState
        sureState?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        sureState?.sureBtn.addTarget(self, action: #selector(sureErrorTest(_:)), for: .touchUpInside)
        sureState?.errorBtn.addTarget(self, action: #selector(sureErrorTest(_:)), for: .touchUpInside)
        sureState?.testBtn.addTarget(self, action: #selector(sureErrorTest(_:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        sureState?.addGestureRecognizer(tap)
        UIApplication.shared.keyWindow?.addSubview(sureState!)
    }
    
    @objc func tapClick() {
        sureState?.removeFromSuperview()
    }
    
    @objc func sureErrorTest(_ button: UIButton) {
        self.tapClick()
        DataRequestManager().updateFireState(withId: listData12[btnSelect]["logId"] as! String, type: "\(button.tag)", success: { (results) in
            let result = results as! [String: Any]
            if result["isSuccess"] as! String == "1" {
                self.getDataMethod(self.tempBtn.tag)
                MBProgressHUD.showInfo(withStatus: result["errorText"] as! String, to: self.navigationController?.view)
            } else {
                MBProgressHUD.showInfo(withStatus: result["errorText"] as! String, to: self.navigationController?.view)
            }
        }) { (error) in
            MBProgressHUD.showInfo(withStatus: "网络异常，请检查网络", to: self.navigationController?.view)
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
