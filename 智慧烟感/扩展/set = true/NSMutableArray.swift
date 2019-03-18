//  Created by Mr.yang on 2018/12/7.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

extension NSMutableArray {
    
    //MARK: 存plist
    /// 存plist
    func writeData(_ name: String) {
        let home = NSHomeDirectory() as NSString
        let homePath = home.appendingPathComponent("Documents") as NSString
        let filePath = homePath.appendingPathComponent("\(name).plist")
        self.write(toFile: filePath, atomically: true)
    }
    
}


