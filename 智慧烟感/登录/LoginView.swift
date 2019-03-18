//
//  LoginView.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/7.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

class LoginView: HideNavigation, UITextFieldDelegate {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var lab_login: UILabel!
    @IBOutlet weak var lab_register: UILabel!
    
    var tempBtn = UIButton()
    var loginView: Login?
    var registerView: Register?
    
    var timer: Timer?
    var times = Int(){
        didSet{
            registerView?.btn_verification.isEnabled = (times == 0)
            if times != 0 {
                registerView?.lab_verification.text = "\(times)秒后重试"
            }else{
                timer?.invalidate()
                registerView?.lab_verification.text = "获取验证码"
            }
        }
    }
    
    func startTimer(_ times: Int) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.time), userInfo: nil, repeats: true)
        self.times = times
    }
    
    @objc func time() {
        times -= 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempBtn = login
    }
    
    var draw = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if draw {
            initLogin()
            draw = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender != tempBtn {
            sender.setTitleColor(.white, for: .normal)
            tempBtn.setTitleColor(UIColor("9CCEFC"), for: .normal)
            tempBtn = sender
            lab_login.isHidden = (sender.tag == 0 ? false : true)
            lab_register.isHidden = (sender.tag == 1 ? false : true)
            
            self.view.endEditing(true)
            
            if sender.tag == 0 {
                initLogin()
            } else {
                initRegister() 
            }
        }
    }
    
    func initLogin() {
        if loginView != nil {
            loginView?.isHidden = false
            registerView?.isHidden = true
        } else {
            loginView = Bundle.main.loadNibNamed("Login", owner: nil, options: nil)?.first as? Login
            loginView?.frame = CGRect(x: 0, y: img.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-img.frame.maxY)
            loginView?.account.delegate = self
            loginView?.password.delegate = self
            loginView?.forgetPassword.addTarget(self, action: #selector(forgetClick(_:)), for: .touchUpInside)
            loginView?.btn_login.addTarget(self, action: #selector(loginClick(_:)), for: .touchUpInside)
            self.view.addSubview(loginView!)
        }
        loginView?.account.text = "account".get as? String
        loginView?.password.text = "password".get as? String
    }
    
    @objc func forgetClick(_ button: UIButton) {
        performSegue(withIdentifier: "forget", sender: self)
    }
    
    @objc func loginClick(_ button: UIButton) {
        if loginView?.account.text != "" && loginView?.password.text != "" {
            DataRequestManager().login(withTel: loginView?.account.text!, password: loginView?.password.text!, success: { (result) in
                if (result as! [String: Any])["isSuccess"] as! String == "1" {
                    "loginResult".set(result as! [String: Any])
                    "account".set(self.loginView?.account.text!)
                    "password".set(self.loginView?.password.text!)
                DataRequestManager().jpushSetAlias(self.loginView?.account.text!)
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    UIApplication.shared.keyWindow?.rootViewController = storyBoard.instantiateViewController(withIdentifier: "main") as! UITabBarController
                } else {
                    MBProgressHUD.showInfo(withStatus: (result as! [String: Any])["errorText"] as! String, to: self.navigationController?.view)
                }
                
            }, failure: { (error) in
                MBProgressHUD.showInfo(withStatus: "网络异常，请检查网络", to: self.navigationController?.view)
            })
        } else {
            MBProgressHUD.showInfo(withStatus: "请将信息填写完整", to: self.navigationController?.view)
        }
    }
    
    func initRegister() {
        if registerView != nil {
            registerView?.isHidden = false
            loginView?.isHidden = true
        } else {
            registerView = Bundle.main.loadNibNamed("Register", owner: nil, options: nil)?.first as? Register
            registerView?.frame = CGRect(x: 0, y: img.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-img.frame.maxY)
            registerView?.name.delegate = self
            registerView?.telephone.delegate = self
            registerView?.verificationCode.delegate = self
            registerView?.password.delegate = self
            registerView?.againPassword.delegate = self
            registerView?.btn_register.addTarget(self, action: #selector(registerClick(_:)), for: .touchUpInside)
            registerView?.btn_verification.addTarget(self, action: #selector(verificationClick(_:)), for: .touchUpInside)
            self.view.addSubview(registerView!)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == registerView?.telephone {
            return textField.text!.lessThan(11, string) && string.allowInput()
        }
        if textField == registerView?.verificationCode {
            return string.allowInput()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginView?.account { loginView?.password.becomeFirstResponder() }
        if textField == loginView?.password {
            loginView?.password.resignFirstResponder()
            loginClick(UIButton())
        }
        
        if textField == registerView?.name { registerView?.telephone.becomeFirstResponder() }
        if textField == registerView?.telephone { registerView?.verificationCode.becomeFirstResponder() }
        if textField == registerView?.verificationCode { registerView?.password.becomeFirstResponder() }
        if textField == registerView?.password { registerView?.againPassword.becomeFirstResponder() }
        if textField == registerView?.againPassword {
            registerView?.againPassword.resignFirstResponder()
            registerClick(UIButton())
        }
        return true
    }
    
    @objc func verificationClick(_ button: UIButton) {
        self.view.endEditing(true)
        if (registerView?.telephone.text?.isTelephone)! {
            DataRequestManager().sendVcode(withTel: registerView?.telephone.text!, success: { (result) in
                if (result as! [String: Any])["isSuccess"] as! String == "1" {
                    //开始计时
                    self.startTimer(120)
                    //FIXME: 待处理
//                    self.registerView?.verificationCode.text = (result as! [String: Any])["vcode"] as? String
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
    
    @objc func registerClick(_ button: UIButton) {
        if registerView?.name.text == "" || registerView?.telephone.text == "" || registerView?.verificationCode.text == "" || registerView?.password.text == "" || registerView?.againPassword.text == "" {
            MBProgressHUD.showInfo(withStatus: "请将信息填写完整", to: self.navigationController?.view)
        } else {
            if registerView?.againPassword.text != registerView?.password.text {
                registerView?.againPassword.text = ""
                registerView?.againPassword.becomeFirstResponder()
                MBProgressHUD.showInfo(withStatus: "两次输入密码不一致", to: self.navigationController?.view)
            } else {
                DataRequestManager().userLogon(withName: registerView?.name.text!, telphone: registerView?.telephone.text!, cert_id: "", password: registerView?.password.text!, vcode: registerView?.verificationCode.text!, success: { (result) in
                    if (result as! [String: Any])["isSuccess"] as! String == "1" {
                        "account".set(self.registerView?.telephone.text!)
                        "password".set(self.registerView?.password.text!)
                        self.btnClick(self.login)
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
