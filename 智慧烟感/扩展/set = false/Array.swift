//  Created by Mr.yang on 2018/12/7.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

extension Array {
    
    //MARK: 改变元素位置(TableView排序用)
    /// 改变元素位置(TableView排序用)
    mutating func changePosition(_ source: Int, _ destination: Int) {
        let object = self[source]
        self.remove(at: source)
        self.insert(object, at: destination)
    }
    
    //MARK: 元素位置互换
    /// 元素位置互换
    mutating func exchangePosition(_ source: Int, _ destination: Int) {
        NSMutableArray(array: self).exchangeObject(at: source, withObjectAt: destination)
    }
    
}
