//  Created by Mr.yang on 2018/12/7.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

extension Date {
    
    //MARK: 时间转字符串
    /// 时间转字符串
    func dateToString(_ string: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = string
        let string = dateFormatter.string(from: self)
        return string
    }
    
    //MARK: 当前时区时间
    /// 当前时区时间
    var toUTCDate: Date {
        let sourceTimeZone = NSTimeZone.local//获取当前时区
        let sourceGMTOffset = Double(sourceTimeZone.secondsFromGMT(for: Date()))
        let utcDate = Date(timeInterval: sourceGMTOffset, since: self)
        return utcDate
    }
    
}
