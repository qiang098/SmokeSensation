//  Created by Mr.yang on 2018/12/7.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

public extension Bool {
    
    //MARK: Bool类型随机数
    /// Bool类型随机数
    public static func random() -> Bool {
        return Int.random(0, 1) == 0
    }
    
}
