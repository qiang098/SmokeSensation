//  Created by Mr.yang on 2018/12/7.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

public extension Int {
    
    //定义了Int类型的别名为：Feet
    typealias Feet = Int
    
    ///  Int类型随机数
    public static func random(_ lower: Int = 0, _ upper: Int = Int.max) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    ///  Int类型随机数 [0..<2]
    public static func random(_ range: Range<Int>) -> Int {
        return random(range.lowerBound, range.upperBound)
    }
    
}


