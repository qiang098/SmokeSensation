//
//  MyView.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/3.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

class MyView: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        let result = "loginResult".get as! [String: Any]
        name.text = result["loginName"] as? String
        tel.text = result["loginNo"] as? String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender.tag == 2 {
            self.tabBarController?.selectedIndex = 2
        }
        if sender.tag == 4 {
            getIsUpdate()
        }
    }
    
    func getIsUpdate() {
        let query = AVQuery(className: "AppVersion")
        query.findObjectsInBackground { (objects, error) in
            if objects != nil {
                let object = objects!.first as! AVObject
                if (object["isUpdate"] as! Bool) && (object["version"] as! String) != (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String) {
                    let alertView = UIAlertController(title: "⚠️警告", message: "为了不影响您的使用，请前往AppStore更新", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "前往", style: .default, handler: { (action) in
                        UIApplication.shared.open(URL(string: object["url"] as! String)!, options: [:], completionHandler: nil)
                    })
                    alertView.addAction(ok)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
                } else {
                    MBProgressHUD.showInfo(withStatus: "已是最新版本", to: self.navigationController?.view)
                }
            }
        }
    }
    
    @IBAction func exitLogin(_ sender: UIButton) {
        "loginResult".set(nil)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        UIApplication.shared.keyWindow?.rootViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! UINavigationController
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
