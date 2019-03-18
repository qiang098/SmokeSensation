//  Created by Mr.yang on 2018/12/7.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

extension String {
    
    //MARK: 字符串转时间
    /// 字符串转时间
    func toDate(_ string: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = string
        let date = dateFormatter.date(from: self)
        return date
    }
    
    //MARK: 手机号校验
    /// 手机号校验
    var isTelephone: Bool {
        if let _ = self.range(of: "^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(17[0-9]{1}))+\\d{8})$", options: .regularExpression, range: nil, locale: nil){
            return true //正确
        }else{
            return false //错误
        }
    }
    
    //MARK: 是否为Float
    /// 是否为Float
    var isFloat: Bool {
        if let _ = self.range(of: "^\\d+\\.\\d+$", options: .regularExpression, range: nil, locale: nil) {
            return true //正确
        }else if let _ = self.range(of: "^\\d+$", options: .regularExpression, range: nil, locale: nil) {
            return true //正确
        } else {
            return false //错误
        }
    }
    
    //MARK: 储存和获取本地数据
    /// 储存和获取本地数据
    func set(_ value: Any?) {
        UserDefaults.standard.set(value, forKey: self)
    }
    var get: Any? {
        return UserDefaults.standard.object(forKey: self)
    }
    
    //MARK: 去掉首尾空格
    /// 去掉首尾空格
    var removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    
    //MARK: 去掉首尾空格 包括后面的换行 \n
    /// 去掉首尾空格 包括后面的换行 \n
    var removeHeadAndTailSpacePro:String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    
    //MARK: 去掉所有空格
    /// 去掉所有空格
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
    //MARK: 去掉首尾空格 后 指定开头空格数
    /// 去掉首尾空格 后 指定开头空格数
    func beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0..<num {
            beginSpace += " "
        }
        return beginSpace + self.removeHeadAndTailSpacePro
    }
    
    //MARK: 密码校验 [A-Z0-9a-z]
    /// 密码校验 [A-Z0-9a-z]
    var passwordInput: Bool {
        if self == "" {
            return true
        }else{
            let emailTest = NSPredicate(format: "SELF MATCHES%@", "[A-Z0-9a-z]")
            return emailTest.evaluate(with: self)
        }
    }
    
    //MARK: 将十六进制颜色字符串转换为UIColor
    ///  将十六进制颜色字符串转换为UIColor
    var color: UIColor {
        // 存储转换后的数值
        var red:UInt32 = 0, green:UInt32 = 0, blue:UInt32 = 0
        
        // 分别转换进行转换
        Scanner(string: self[0..<2]).scanHexInt32(&red)
        Scanner(string: self[2..<4]).scanHexInt32(&green)
        Scanner(string: self[4..<6]).scanHexInt32(&blue)
        
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    
    //MAKR:String使用下标截取字符串
    ///  String使用下标截取字符串
    ///  例: "示例字符串"[0..<2] 结果是 "示例"
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    
    //MARK: 取plist
    /// 取plist
    var read: NSMutableArray? {
        let home = NSHomeDirectory() as NSString
        let homePath = home.appendingPathComponent("Documents") as NSString
        let filePath = homePath.appendingPathComponent(self+".plist")
        let data = NSMutableArray(contentsOfFile: filePath)
        return data
    }
    
    //MARK: 计算字符串所占的空间大小 (返回字符串所占用的尺寸；字体大小、最大值可以设置无限大)
    /// 计算字符串所占的空间大小 (返回字符串所占用的尺寸；字体大小、最大值可以设置无限大)
    func sizeWithFontMaxSize(font:UIFont,maxSize:CGSize) -> CGSize{
        let attrs = [NSAttributedStringKey.font : font] as NSDictionary
        
        return self.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs as? [NSAttributedStringKey : Any], context: nil).size
    }
    
    //MARK: 只允许输入 ??? 和 ""
    /// 只允许输入 ??? 和 ""
    func allowInput(_ string: String = "0123456789") -> Bool {
        let cs = NSCharacterSet(charactersIn: string).inverted
        let filtered = self.components(separatedBy: cs).joined(separator: "")
        if self == filtered {
            return true
        }else{
            return false
        }
    }
    
    //MARK: 大于num位数的中文不让输入(数字或字母: range.location < num)
    /// 大于num位数的中文不让输入(数字或字母: range.location < num)
    func lessThan(_ num: Int, _ string: String?) -> Bool {
        let length = self.lengthOfBytes(using: String.Encoding.unicode)/2
        if string == "" {
            return true
        }
        if length < num {
            return true
        }else{
            return false
        }
    }
    
}
