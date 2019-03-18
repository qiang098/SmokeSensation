//  Created by Mr.yang on 2018/12/7.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

public extension Double {
    
    //MARK: Double类型随机数
    /// Double类型随机数
    public static func random(_ lower: Double = 0, _ upper: Double = 100) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
    
}


