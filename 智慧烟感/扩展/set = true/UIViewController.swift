//  Created by Mr.yang on 2018/12/7.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

extension UIViewController {
    
    //MARK: 返回多层
    /// 返回多层
    func backMultilayer(_ backCount: Int = 1) {
        /// backCount: 回退次数
        self.navigationController?.popToViewController((self.navigationController!.viewControllers[self.navigationController!.viewControllers.count-(backCount+1)]), animated: true)
    }
    
    //MARK: 设置系统返回键的文字和颜色
    /// 设置系统返回键的文字和颜色
    func setBackTitleAndColor() {
        //设置系统返回键文字
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        //设置系统返回键颜色
        self.navigationItem.backBarButtonItem?.tintColor = .white
        //设置导航栏背景
//        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "导航栏背景"), for: .default)
//        self.navigationController?.navigationBar.tintColor = .white
    }
    
    //MARK: 弹出地图选择
    /// 弹出地图选择
    func navigationDestination(_ latitude: Double, _ longitude: Double) {
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let alertView = UIAlertController(title: "选择地图", message: nil, preferredStyle: .actionSheet)
        
        if UIApplication.shared.canOpenURL(URL(string: "baidumap://")!) {
            let baiduMap = UIAlertAction(title: "百度地图", style: .default, handler: { (action) in
                
                let urlString = "baidumap://map/direction?origin={{我的位置}}&destination=latlng:\(latitude),\(longitude)|name:终点&mode=driving&coord_type=gcj02".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                if #available(iOS 10, *) {
                    UIApplication.shared.open(URL(string: urlString!)!, options: [:], completionHandler: nil)
                }else{
                    UIApplication.shared.openURL(URL(string: urlString!)!)
                }
            })
            alertView.addAction(baiduMap)
        }
        
        if UIApplication.shared.canOpenURL(URL(string: "iosamap://")!) {
            let gaodeMap = UIAlertAction(title: "高德地图", style: .default, handler: { (action) in
                
                let urlString = "iosamap://navi?sourceApplication=库啦啦&backScheme=kulala://&poiname=终点&lat=\(latitude)&lon=\(longitude)&dev=1&style=2".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                if #available(iOS 10, *) {
                    UIApplication.shared.open(URL(string: urlString!)!, options: [:], completionHandler: nil)
                }else{
                    UIApplication.shared.openURL(URL(string: urlString!)!)
                }
            })
            
            alertView.addAction(gaodeMap)
        }
        
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            let googleMap = UIAlertAction(title: "谷歌地图", style: .default, handler: { (action) in
                
                let urlString = "comgooglemaps://?x-source=库啦啦&x-success=kulala://&saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                if #available(iOS 10, *) {
                    UIApplication.shared.open(URL(string: urlString!)!, options: [:], completionHandler: nil)
                }else{
                    UIApplication.shared.openURL(URL(string: urlString!)!)
                }
            })
            
            alertView.addAction(googleMap)
        }
        
        if UIApplication.shared.canOpenURL(URL(string: "qqmap://")!) {
            let tencentMap = UIAlertAction(title: "腾讯地图", style: .default, handler: { (action) in
                
                let urlString = "qqmap://map/routeplan?type=drive&from=我的位置&to=终点&tocoord=\(latitude),\(longitude)&coord_type=1&policy=0&referer=demoURI".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                if #available(iOS 10, *) {
                    UIApplication.shared.open(URL(string: urlString!)!, options: [:], completionHandler: nil)
                }else{
                    UIApplication.shared.openURL(URL(string: urlString!)!)
                }
            })
            
            alertView.addAction(tencentMap)
        }
        
        /// 系统地图, 这个判断其实是不需要的
        if UIApplication.shared.canOpenURL(URL(string: "http://maps.apple.com/")!) {
            let appleMap = UIAlertAction(title: "系统地图", style: .default, handler: { (action) in
                let from = MKMapItem.forCurrentLocation()//当前位置
                
                let to = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
                to.name = "终点"
                MKMapItem.openMaps(with: [from, to], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: 1])
            })
            alertView.addAction(appleMap)
        }
        
        let webPage = UIAlertAction(title: "网页地图", style: .default, handler: { (action) in
            if let currentLatitude = "latitude".get, let currentLongitude = "longitude".get {
                let url = "http://apis.map.qq.com/uri/v1/routeplan?type=drive&from=当前位置&fromcoord=\(currentLatitude),\(currentLongitude)&to=终点&tocoord=\(latitude),\(longitude)&policy=1&referer=库啦啦"
                var allowedCharacters = CharacterSet.alphanumerics
                allowedCharacters.insert(charactersIn: ".:/,&?=")
                let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
                
                if #available(iOS 10, *) {
                    UIApplication.shared.open(URL(string: encodedUrl!)!, options: [:], completionHandler: nil)
                }else{
                    UIApplication.shared.openURL(URL(string: encodedUrl!)!)
                }
            }
        })
        alertView.addAction(webPage)
        
        let cancel = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        alertView.addAction(cancel)
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    //MARK: 引导设置
    /// 引导设置
    func bootSetting() {
        //检测是否开启定位服务并引导
        if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
            
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
                let alertCon = UIAlertController.init(title: "您还没有开启定位服务，找工匠等功能无法使用，是否去设置？", message: nil, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
                let okAction = UIAlertAction.init(title: "设置", style: .default, handler: { (action) in
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }else{
                        UIApplication.shared.openURL(appSettings)
                    }
                })
                
                alertCon.addAction(cancelAction)
                alertCon.addAction(okAction)
                self.present(alertCon, animated: true, completion: nil)
            }
        }
    }
    
    //MAKR:弹出系统Alert
    /// 弹出系统Alert
    func alertShow(_ title: String?, _ message: String?, _ okTitle: String?, _ isCancel: Bool = false, _ target: (() -> Void)?) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: okTitle, style: .destructive, handler: { (action) in
            target?()
        })
        alertView.addAction(ok)
        if isCancel {
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertView.addAction(cancel)
        }
        self.present(alertView, animated: true, completion: nil)
    }
    
    //MAKR:弹出系统Alert
    /// 弹出系统Alert
    func alertShow(_ title: String?, _ message: String?, _ okTitle: String?, _ targetOK: (() -> Void)?, _ targetCancel: (() -> Void)?) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: okTitle, style: .destructive, handler: { (action) in
            targetOK?()
        })
        alertView.addAction(ok)
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            targetCancel?()
        }
        alertView.addAction(cancel)
        self.present(alertView, animated: true, completion: nil)
    }
    
}
