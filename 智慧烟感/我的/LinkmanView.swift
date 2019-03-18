//
//  LinkmanView.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/20.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit
import ContactsUI
import DGElasticPullToRefresh

class LinkmanView: UIViewController, CNContactPickerDelegate, CNContactViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tabView: UITableView!
    
    var placeId: String?
    var isAddPlace = false
    var listData = [[String: Any]]() {
        didSet {
            tabView.reloadData()
        }
    }
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        if isAddPlace {
            backMultilayer(2)
        } else {
            backMultilayer()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getListData()
        
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
        if placeId != nil {
            DataRequestManager().getPersonList(withPlaceId: placeId, success: { (results) in
                self.tabView.dg_stopLoading()
                let result = results as! [String: Any]
                if result["isSuccess"] as! String == "1" {
                    if (result["personList"] as! [[String: Any]]).count != 0 {
                        self.listData = result["personList"] as! [[String: Any]]
                        self.tabView.hideCell(self.listData.count)
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
    
    @objc func linkmanClick(_ button: UIButton) {
        let contacts = CNContactPickerViewController.init()
        contacts.delegate = self
        self.present(contacts, animated: true, completion: nil)
        CNContactStore.authorizationStatus(for: .contacts)
    }
    
    @objc func sureCancel(_ button: UIButton) {
        if button.tag == 0 {
            if linkPopView?.name.text == "" || linkPopView?.telephone.text == "" {
                MBProgressHUD.showInfo(withStatus: "请将信息填写完整", to: UIApplication.shared.keyWindow)
                return
            } else {
                DataRequestManager().addPerson(withPlaceId: placeId, personName: linkPopView?.name.text!, personTel: linkPopView?.telephone.text!, success: { (results) in
                    let result = results as! [String: Any]
                    if result["isSuccess"] as! String == "1" {
                        self.getListData()
                        MBProgressHUD.showInfo(withStatus: result["errorText"] as! String, to: self.navigationController?.view)
                    } else {
                        MBProgressHUD.showInfo(withStatus: result["errorText"] as! String, to: self.navigationController?.view)
                    }
                }, failure: { (error) in
                    MBProgressHUD.showInfo(withStatus: "网络异常，请检查网络", to: self.navigationController?.view)
                })
            }
        }
        linkPopView?.removeFromSuperview()
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let name = String(format: "%@%@", contact.familyName, contact.givenName)
        linkPopView?.name.text = name
        let phoneNumbers = contact.phoneNumbers
        if phoneNumbers.count != 0 {
            linkPopView?.telephone.text = phoneNumbers.first?.value.stringValue.removeAllSapce
        } else {
            MBProgressHUD.showInfo(withStatus: "没有联系电话", to: self.navigationController?.view)
        }
    }
    
    let height: CGFloat = 40
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        header.backgroundColor = UIColor("f5f5f5")
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height-1))
        button.setTitle("添加联系人", for: .normal)
        button.setTitleColor(UIColor("999999"), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(addLinkman(_:)), for: .touchUpInside)
        header.addSubview(button)
        return header
    }
    
    var linkPopView: LinkPopView?
    @objc func addLinkman(_ button: UIButton) {
        linkPopView = Bundle.main.loadNibNamed("LinkPopView", owner: nil, options: nil)?.first as? LinkPopView
        linkPopView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        linkPopView?.cancel.addTarget(self, action: #selector(sureCancel(_:)), for: .touchUpInside)
        linkPopView?.sure.addTarget(self, action: #selector(sureCancel(_:)), for: .touchUpInside)
        linkPopView?.linkman.addTarget(self, action: #selector(linkmanClick(_:)), for: .touchUpInside)
        self.navigationController?.view.addSubview(linkPopView!)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabView.dequeueReusableCell(withIdentifier: "cell") as! LinkmanCell
        cell.name.text = listData[indexPath.row]["personName"] as? String
        cell.telephone.text = listData[indexPath.row]["personTel"] as? String
        cell.delete.tag = indexPath.row
        cell.delete.addTarget(self, action: #selector(deleteClick(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteClick(_ button: UIButton) {
        alertShow("提示", "确认删除", "确认", true) {
            DataRequestManager().delPerson(withPlaceId: "\(self.listData[button.tag]["placeId"] as! Int)", personTel: self.listData[button.tag]["personTel"] as! String, success: { (results) in
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
