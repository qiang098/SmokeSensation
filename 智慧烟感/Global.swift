

//MARK:  - 标注

//TODO: - 注释还有什么功能要做

//FIXME: - 项目中有个警告，不影响程序运行，当时由于时间等一些原因，做好标记，以便之后做处理。


import UIKit
import AVFoundation

//MARK: 添加到窗口
/// 添加到窗口
func MYWindow(_ view: UIView) {
    UIApplication.shared.keyWindow?.addSubview(view)
}

//MARK: 使用系统音读文字
/// 使用系统音读文字
func playSound(_ textString: String, _ volume: Float, _ rate: Float, _ pitchMultiplier: Float) {
    let av = AVSpeechSynthesizer()
    let utterance = AVSpeechUtterance(string: textString) //需要转换的文本
    utterance.volume = volume
    utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN") //设置语言
    utterance.rate = rate
    utterance.pitchMultiplier = pitchMultiplier
    av.speak(utterance)
}

//MARK: 数据转换成AVObject
/// 数据转换成AVObject
func toAVObject(_ data: [Any]) -> [AVObject] {
    var objects = [AVObject]()
    for index in data {
        objects.append(index as! AVObject)
    }
    return objects
}

//MARK: 初始化轮播图
/// 初始化轮播图
func initJYCarousel(_ subView: UIView) -> JYCarousel {
    let carouselView = JYCarousel(frame: subView.frame, configBlock: { (configuration) -> JYConfiguration? in
        return configuration
    }) { (index) in
        print("点击了第\(index)张轮播图")
    }
    subView.addSubview(carouselView!)
    return carouselView!
}

extension UIViewController {
    
    //MARK: 支付宝支付
    /// 支付宝支付
    func alipayData(body: String, orderId: String, price: String/*, target: @escaping (_ result: [AnyHashable : Any]?) -> Void*/) {
        //生成订单信息及签名
        //将商品信息赋予AlixPayOrder的成员变量
        let order = APOrderInfo()
        // NOTE: app_id设置
        order.app_id = "2018062160345920"
        // NOTE: 支付接口名称
        order.method = "alipay.trade.app.pay"
        // NOTE: 参数编码格式
        order.charset = "utf-8"
        // NOTE: 当前时间点
        order.timestamp = Date().convertToUTCDate().dateToString("yyyy-MM-dd HH:mm:ss")
        // NOTE: 支付版本
        order.version = "1.0"
        // NOTE: sign_type 根据商户设置的私钥来决定
        order.sign_type = "RSA2"
        // NOTE: 商品数据
        order.biz_content = APBizContent()
        order.biz_content.body = body
        order.biz_content.subject = "用工帮-充值"
        order.biz_content.out_trade_no = orderId //订单ID（由商家自行制定）
        order.biz_content.timeout_express = "30m" //超时时间设置
        order.biz_content.total_amount = price //商品价格
        //将商品信息拼接成字符串
        let orderInfo = order.orderInfoEncoded(false)
        let orderInfoEncoded = order.orderInfoEncoded(true)
//        print("orderSpec = %"+orderInfo!)
        // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
        //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
        let signer = APRSASigner(privateKey: Alipay_PrivateKey)
        let signedString = signer?.sign(orderInfo, withRSA2: true)
        // NOTE: 如果加签成功，则继续执行支付
        if signedString != nil {

            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            let orderString = "\(orderInfoEncoded!)&sign=\(signedString!)"
            // NOTE: 调用支付结果开始支付

            AlipaySDK.defaultService().payOrder(orderString, fromScheme: "jiuhangkeji-yonggongbang", callback: { (resultDic) in

                if (resultDic!["resultStatus"] as! Int) == 9000 {
//                    target(resultDic)
                }else{
                    MBProgressHUD.showInfo(withStatus: "支付失败", to: self.view)
                }
            })
        }
    }
    
    //MARK: 调接口
    /// 调接口
    func methodName(_ name: String, _ dictionary: [String: Any], _ view: UIView?, _ target: ((_ json: Any?, _ error: Error?) -> Void)?) {
        if view == nil {
            MBProgressHUD.showMessag("请稍等┅", to: self.navigationController?.view)
        } else {
            MBProgressHUD.showMessag("请稍等┅", to: view)
        }
        AVCloud.callFunction(inBackground: name, withParameters: dictionary) { (results, error) in
            if view == nil {
                MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
            } else {
                MBProgressHUD.hide(for: view!, animated: true)
            }
            target!(results, error)
        }
    }

    //MARK: 数据处理
    /// 数据处理
    func dataMethod(_ className: String, _ mark: String?, _ set: ((_ query: AVQuery)->Void), _ get: @escaping ((_ objects: [Any])->Void)) {
        let query = AVQuery(className: className)
        query.order(byDescending: "createdAt")
        set(query)
        MBProgressHUD.showMessag("请稍等┅", to: self.navigationController?.view)
        query.findObjectsInBackground { (objects, error) in
            MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
            if error != nil {
                //错误处理
                MBProgressHUD.showInfo(withStatus: "网络异常", to: self.view)
            }else{
                //数据处理
                if objects?.count == 0 {
                    if mark != nil {
                        if mark == "" {
                            MBProgressHUD.showInfo(withStatus: "暂无数据", to: self.view)
                        } else {
                            MBProgressHUD.showInfo(withStatus: mark, to: self.view)
                        }
                    }
                }
                get(objects!)
            }
        }
    }

    //MARK: or查询
    /// or查询
    func orSearch(_ mark: String?, _ queryArray: [AVQuery], _ totalSet: ((_ query: AVQuery)->Void), _ get: @escaping ((_ objects: [Any])->Void)) {
        
        let query = AVQuery.orQuery(withSubqueries: queryArray)
        query.order(byDescending: "createdAt")
        totalSet(query)
        MBProgressHUD.showMessag("请稍等┅", to: self.navigationController?.view)
        query.findObjectsInBackground { (objects, error) in
            MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
            if error != nil {
                MBProgressHUD.showInfo(withStatus: "网络异常", to: self.view)
            }else{
                //数据处理
                if mark != nil {
                    if mark == "" {
                        MBProgressHUD.showInfo(withStatus: "暂无数据", to: self.view)
                    } else {
                        MBProgressHUD.showInfo(withStatus: mark, to: self.view)
                    }
                }
                get(objects!)
            }
        }
    }
}


