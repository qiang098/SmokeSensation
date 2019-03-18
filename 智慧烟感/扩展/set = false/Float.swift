//  Created by Mr.yang on 2018/12/7.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

public extension Float {
    
    //MARK: Float类型随机数
    /// Float类型随机数
    public static func random(_ lower: Float = 0, _ upper: Float = 100) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
    
    //MARK: 保留小数点后几位 默认保留1位
    /// 保留小数点后几位 默认保留1位
    func keepDecimal(_ num: Int = 1) -> Float {
        return Float(String(format: "%.\(num)f", self))!
    }
    
}


