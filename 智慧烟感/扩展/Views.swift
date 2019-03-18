
//
//  Created by Mr.yang on 2018/11/20.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit
class View: UIView {

    //圆角
    @IBInspectable var cornerRadius:CGFloat = 0.0 { didSet { self.layer.cornerRadius = cornerRadius } }
    //边界
    @IBInspectable var masksToBounds: Bool = false { didSet { self.layer.masksToBounds = masksToBounds } }
    //边框宽度
    @IBInspectable var borderWidth:CGFloat = 0.0 { didSet { self.layer.borderWidth = borderWidth } }
    //边框颜色
    @IBInspectable var borderColor:UIColor? = nil { didSet { self.layer.borderColor = borderColor?.cgColor } }

}

class Button: UIButton {
    
    //圆角
    @IBInspectable var cornerRadius:CGFloat = 0.0 { didSet { self.layer.cornerRadius = cornerRadius } }
    //边界
    @IBInspectable var masksToBounds: Bool = false { didSet { self.layer.masksToBounds = masksToBounds } }
    //边框宽度
    @IBInspectable var borderWidth:CGFloat = 0.0 { didSet { self.layer.borderWidth = borderWidth } }
    //边框颜色
    @IBInspectable var borderColor:UIColor? = nil { didSet { self.layer.borderColor = borderColor?.cgColor } }
}

class Label: UILabel {
    
    //圆角
    @IBInspectable var cornerRadius:CGFloat = 0.0 { didSet { self.layer.cornerRadius = cornerRadius } }
    //边界
    @IBInspectable var masksToBounds: Bool = false { didSet { self.layer.masksToBounds = masksToBounds } }
    //边框宽度
    @IBInspectable var borderWidth:CGFloat = 0.0 { didSet { self.layer.borderWidth = borderWidth } }
    //边框颜色
    @IBInspectable var borderColor:UIColor? = nil { didSet { self.layer.borderColor = borderColor?.cgColor } }
}

class NavigationController: UINavigationController {
    
    //设置导航栏图片背景
    @IBInspectable var barBackgroundImage: UIImage? = nil { didSet { self.navigationBar.setBackgroundImage(barBackgroundImage, for: .default) } }
    //去掉导航栏分割线
    @IBInspectable var removeSeparator: Bool = false { didSet { if removeSeparator { self.navigationBar.shadowImage = UIImage() } } }
}

class HideNavigation: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}

class CustomBackButton: UIViewController {
    
    override func viewDidLoad() {
        let leftBatBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "返回"), style: .plain, target: self, action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBatBtn
        self.navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.navigationController?.popViewController(animated: true)
    }
}

class ImageView: UIImageView {
    
    //圆角
    @IBInspectable var cornerRadius:CGFloat = 0.0 { didSet { self.layer.cornerRadius = cornerRadius } }
    //边界
    @IBInspectable var masksToBounds: Bool = false { didSet { self.layer.masksToBounds = masksToBounds } }
    //边框宽度
    @IBInspectable var borderWidth:CGFloat = 0.0 { didSet { self.layer.borderWidth = borderWidth } }
    //边框颜色
    @IBInspectable var borderColor:UIColor? = nil { didSet { self.layer.borderColor = borderColor?.cgColor } }
    //图片点击放大
    @IBInspectable var enlarge: Bool = false {
        didSet { buildView(enlarge) }
    }
    
    func buildView(_ isAdd: Bool) {
        if isAdd {
            self.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectImage))
            tapGesture.numberOfTapsRequired = 1
            self.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func selectImage() {
        let window = UIApplication.shared.keyWindow
        let backgroundView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        backgroundView.bouncesZoom = true
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.5
        
        let imageView = UIImageView(frame: self.frame)
        imageView.image = self.image
        imageView.tag = 1
        backgroundView.addSubview(imageView)
        window?.addSubview(backgroundView)
        
        //点击图片缩小的手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideImage(_:)))
        backgroundView.addGestureRecognizer(tap)
        UIView.animate(withDuration: 0.3) {
            imageView.frame = CGRect(x: 0, y: (UIScreen.main.bounds.height-self.image!.size.height*UIScreen.main.bounds.width/self.image!.size.width)/2, width: UIScreen.main.bounds.width, height: self.image!.size.height*UIScreen.main.bounds.width/self.image!.size.width)
            backgroundView.alpha = 1
            backgroundView.contentSize = imageView.frame.size
        }
    }
    
    @objc func hideImage(_ tap: UITapGestureRecognizer) {
        let backgroundView = tap.view
        let imageView = tap.view?.viewWithTag(1)
        UIView.animate(withDuration: 0.3, animations: {
            imageView?.frame = self.frame
            backgroundView?.alpha = 0
        }) { (finished) in
            backgroundView?.removeFromSuperview()
        }
    }
    
}


