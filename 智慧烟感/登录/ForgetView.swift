//
//  ForgetView.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/17.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

class ForgetView: CustomBackButton, UITextFieldDelegate {

    @IBOutlet weak var telephone: UITextField!
    @IBOutlet weak var verificationCode: UITextField!
    @IBOutlet weak var btn_verification: Button!
    @IBOutlet weak var lab_verification: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var againPassword: UITextField!
    @IBOutlet weak var submit: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var timer: Timer?
    var times = Int(){
        didSet{
            btn_verification.isEnabled = (times == 0)
            if times != 0 {
                lab_verification.text = "\(times)秒后重试"
            }else{
                timer?.invalidate()
                lab_verification.text = "获取验证码"
            }
        }
    }
    
    @IBAction func verification(_ sender: UIButton) {
        self.view.endEditing(true)
        if (telephone.text?.isTelephone)! {
            DataRequestManager().sendVcode(withTel: telephone.text!, success: { (result) in
                if (result as! [String: Any])["isSuccess"] as! String == "1" {
                    //开始计时
                    self.startTimer(120)
                    //FIXME: 待处理
//                    self.verificationCode.text = (result as! [String: Any])["vcode"] as? String
                } else {
                    MBProgressHUD.showInfo(withStatus: (result as! [String: Any])["errorText"] as! String, to: self.navigationController?.view)
                }
            }, failure: { (error) in
                MBProgressHUD.showInfo(withStatus: "网络异常，请检查网络", to: self.navigationController?.view)
            })
        } else {
            MBProgressHUD.showInfo(withStatus: "请输入正确的手机号", to: self.navigationController?.view)
        }
    }
    
    func startTimer(_ times: Int) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.time), userInfo: nil, repeats: true)
        self.times = times
    }
    
    @objc func time() {
        times -= 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == telephone { verificationCode.becomeFirstResponder() }
        if textField == verificationCode { password.becomeFirstResponder() }
        if textField == password { againPassword.becomeFirstResponder() }
        if textField == againPassword {
            againPassword.resignFirstResponder()
            submit(Button())
        }
        return true
    }
    
    @IBAction func submit(_ sender: Button) {
        if telephone.text == "" || verificationCode.text == "" || password.text == "" || againPassword.text == "" {
            MBProgressHUD.showInfo(withStatus: "请将信息填写完整", to: self.navigationController?.view)
        } else {
            if againPassword.text != password.text {
                againPassword.text = ""
                againPassword.becomeFirstResponder()
                MBProgressHUD.showInfo(withStatus: "两次输入密码不一致", to: self.navigationController?.view)
            } else {
                DataRequestManager().updatePass(withPhoneNo: telephone.text!, password: password.text!, vcode: verificationCode.text!, success: { (result) in
                    if (result as! [String: Any])["isSuccess"] as! String == "1" {
                        "account".set(self.telephone.text!)
                        "password".set(self.password.text!)
                        self.alertShow("提示", "密码修改成功", "知道了") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        MBProgressHUD.showInfo(withStatus: (result as! [String: Any])["errorText"] as! String, to: self.navigationController?.view)
                    }
                }, failure: { (error) in
                    MBProgressHUD.showInfo(withStatus: "网络异常，请检查网络", to: self.navigationController?.view)
                })
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
