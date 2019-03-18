//
//  AddChangSuo.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/20.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddChangSuo: CustomBackButton, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var telephone: UILabel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let result = "loginResult".get as! [String: Any]
        owner.text = result["loginName"] as? String
        telephone.text = result["loginNo"] as? String
        
        mapview.showsUserLocation = true
        
//        //获取当前坐标位置并且初始化地图
//        LocationManager.shareManager.creatLocationManager().startLocation { (location, address, error) in
//            if location != nil {
//
//                //添加大头针
//                self.addAnnotation(location!.coordinate)
//
//                //将当前的显示跨度缩小一倍(*0.5)放大一倍（*2）
//                let la=self.mapview.region.span.latitudeDelta*0.0015
//                let lo=self.mapview.region.span.longitudeDelta*0.0015
//                self.mapview.setRegion(MKCoordinateRegion(center: location!.coordinate, span: MKCoordinateSpan(latitudeDelta: la, longitudeDelta: lo)), animated: true)
//            }
//        }
    }
    
    var isFirst = false
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //添加大头针
//        self.addAnnotation(userLocation.coordinate)
        
        if isFirst { return }
        isFirst = true
        tempCoordinate = userLocation.coordinate
        LongLatToCity(userLocation.coordinate)
        //将当前的显示跨度缩小一倍(*0.5)放大一倍（*2）
        let la=self.mapview.region.span.latitudeDelta*0.001
        let lo=self.mapview.region.span.longitudeDelta*0.001
        self.mapview.setRegion(MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: la, longitudeDelta: lo)), animated: true)
    }
    
    var annotation: MKPointAnnotation?
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        //1. 获取点击的点
        let point:CGPoint=(touches.first?.location(in:mapview))!

        if self.mapview.layer.contains(point) {
            //2. 将点转换成经纬度
            let coordinate:CLLocationCoordinate2D=(mapview?.convert(point, toCoordinateFrom: mapview))!

            addAnnotation(coordinate)
        }
    }

    var tempCoordinate: CLLocationCoordinate2D?
    //添加大头针并使其为屏幕中心
    func addAnnotation(_ coordinate: CLLocationCoordinate2D) {

        tempCoordinate = coordinate

        if annotation != nil {
            mapview.removeAnnotation(annotation!)
        }

        annotation = MKPointAnnotation.init()

        annotation?.coordinate=coordinate

        mapview?.addAnnotation(annotation!)

        mapview.setCenter(coordinate, animated: true)

        LongLatToCity(coordinate)
    }

    ///经纬度逆编
    func LongLatToCity(_ coordinate: CLLocationCoordinate2D) {

        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemark, error) -> Void in
            if(error == nil){
                let firstPlaceMark = placemark!.first

                var areas = String()
                //市
                if let locality = firstPlaceMark?.locality {
                    areas += locality
                }
                //区
                if let subLocality = firstPlaceMark?.subLocality {
                    areas += ","+subLocality
                }

                self.area.text = areas

            }else{
                print(error as Any)
            }
        }
    }
    
    var placeId: String?
    @IBAction func sureClick(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        if name.text == "" || address.text == "" || area.text == "" {
            MBProgressHUD.showInfo(withStatus: "请将信息填写完整", to: self.view)
        } else {
            let loginResult = "loginResult".get as! [String: Any]
            let coordinate = JZLocationConverter.gcj02(toBd09: tempCoordinate!)
            let paramenters = ["placeName": name.text!, "placeAddr": address.text!, "regionCode": area.text!, "longitude": coordinate.longitude, "latitude": coordinate.latitude, "custId": loginResult["custId"] as! String, "manager": loginResult["loginName"] as! String, "managerPhone": loginResult["loginNo"] as! String] as [String : Any]
            DataRequestManager().addPlace(withParameters: paramenters, success: { (result) in
                if (result as! [String: Any])["isSuccess"] as! String == "1" {
                    self.alertShow("提示", "场所添加成功，是否添加联系人？", "添加", {
                        self.placeId = (result as! [String: Any])["placeId"] as? String
                        self.performSegue(withIdentifier: "linkman", sender: self)
                    }, {
                        self.navigationController?.popViewController(animated: true)
                    })
                } else {
                    MBProgressHUD.showInfo(withStatus: (result as! [String: Any])["errorText"] as! String, to: self.navigationController?.view)
                }
            }, failure: { (error) in
                MBProgressHUD.showInfo(withStatus: "网络异常，请检查网络", to: self.navigationController?.view)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "linkman" {
            let vc = segue.destination as! LinkmanView
            vc.placeId = self.placeId
            vc.isAddPlace = true
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
