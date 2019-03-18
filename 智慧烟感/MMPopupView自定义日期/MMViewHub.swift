//
//  MMViewHub.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/7.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

//MARK: 自定义alert
/// 自定义alert
func alertCustom(_ title: String, _ detail: String?, _ btnName: [[String?]], _ target: ((_ indexs: NSInteger) -> Void)?) {
    let block: MMPopupItemHandler = { (index: NSInteger) in
        target?(index)
    }
    var item = [MMPopupItem]()
    for index in 0..<btnName.count {
        let type: MMItemType = (btnName[index].count == 1 ? .normal : .highlight)
        item.append(MMItemMake(btnName[index][0], type, block))
    }
    
    let details = (detail == nil ? "" : detail)
    let alertView = MMAlertView(title: title, detail: details, items: item)
    //设置alert以外部分的背景是否透明
    alertView?.attachedView.mm_dimBackgroundBlurEnabled = false
    alertView?.attachedView.mm_dimBackgroundBlurEffectStyle = .light
    alertView?.show()
}

//MARK: 自定义时间alert
/// 自定义时间alert
func alertDate(_ date: Date, _ target: @escaping ((_ date: String, _ time: String) -> Void)) {
    let dateView = MMDateView()
    dateView.datePicker.datePickerMode = .date
    dateView.datePicker.setDate(date, animated: true)
    dateView.datePicker.minimumDate = Date()
    //    dateView.datePicker.maximumDate = (Date().dateToString(nil)+" 00:00:00").stringToDate(nil)?.timeDifference(86400*2)
    dateView.show()
    dateView.dateBlock = {(date: Date?) in
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dates = dateFormatter.string(from: date!)
        dateFormatter.dateFormat = "HH:mm"
        let times = dateFormatter.string(from: date!)
        target(dates, times)
    }
}

//MARK: 自定义picker
/// 自定义picker
func alertPicker(_ array: [Any], _ selectIndex: NSInteger, _ target: @escaping ((_ select: NSInteger) -> Void)) {
    let picker = MMPickerView()
    picker.array = array
    picker.setSelect(selectIndex)
    picker.indexBlock = {(index: NSInteger) in
        target(index)
    }
    picker.show()
}

//MARK: 自定义pickerView
/// 自定义pickerView
func alertPickerView(_ row1: NSInteger, _ row2: NSInteger, _ target: @escaping ((_ string: String, _ row1: Int, _ row2: Int) -> Void)) {
    let picker = MPickerView()
    picker.setSelect(row1, row2)
    picker.stringBlock = {(string: String?, row1: Int, row2: Int) in
        target(string!, row1, row2)
    }
    picker.show()
}


