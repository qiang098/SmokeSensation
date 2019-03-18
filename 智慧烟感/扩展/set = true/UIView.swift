//  Created by Mr.yang on 2018/12/7.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

extension UIView {
    
    
    //MARK: 添加到window
    /// 添加到window
    func windows() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    //MARK: 查找UIView及其子类的根父视图控制器
    /// 查找UIView及其子类的根父视图控制器
    func rootViewController() -> UIViewController? {
        var next = self.next;
        
        while next != nil {
            if next is UIViewController {
                return next as? UIViewController;
            }
            next = next?.next;
        }
        
        return nil;
    }
    
    //MARK: 切换动画
    /// 切换动画
    func switchAnimation(_ type: String, _ subtype: String, _ duration: CFTimeInterval) {
        let animation = CATransition()
        //设置动画的变化方法
        animation.duration = duration
        //设置运动速度
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        //设置运动类型
        animation.type = type
        //设置运动方向
        animation.subtype = subtype
        self.layer.add(animation, forKey: "reveal")
    }
    
    //MARK: 回转动画
    /// 回转动画
    func reboundAnimation(_ transition: UIViewAnimationTransition) {
        UIView.animate(withDuration: 0.75) {
            UIView.setAnimationCurve(.easeInOut)
            UIView.setAnimationTransition(transition, for: self, cache: true)
        }
    }
}
