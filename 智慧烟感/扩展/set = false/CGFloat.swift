//  Created by Mr.yang on 2018/12/7.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

public extension CGFloat {
    
    //MARK: CGFloat类型随机数
    /// CGFloat类型随机数
    public static func random(_ lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
    
}


