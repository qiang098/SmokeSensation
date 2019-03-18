//  Created by Mr.yang on 2018/12/7.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

extension UITableView {
    
    //MARK: 隐藏多余cell
    /// 隐藏多余cell
    func hideCell(_ count: Int, _ color: UIColor? = nil) {
        
        if count != 0 {
            if color != nil {
                self.separatorColor = color
            }
            self.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            let views = UIView()
            views.backgroundColor = UIColor.clear
            self.tableFooterView = views
        }else{
            self.separatorStyle = UITableViewCellSeparatorStyle.none
        }
    }
    
}


