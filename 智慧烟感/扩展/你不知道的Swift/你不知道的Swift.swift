//
//  你不知道的Swift.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/12/10.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit

#if DEBUG // 判断是否在测试环境下
    // TODO
#else
    // TODO
#endif


//FIXME: 函数

//MARK: 函数嵌套 (返回一个函数)
func name(name aa: Int) -> (() -> Int) {
    var num = 0
    func subtract() -> Int {
        num -= aa
        return num
    }
    return subtract
}
//例：name(name: 30) 结果：-30

//MARK: 变量参数、返回值与函数相同可操作
var add: (Int, Int) -> Int = sum
func sum(_ aa: Int, _ bb: Int) -> Int {
    return aa + bb
}
//例：add(20, 50) 结果：70

//MARK: 也可将函数作为参数传递给函数
func name(_ add: (Int, Int) -> Int, _ aa: Int, _ bb: Int) {
    //例：
    name(sum(_:_:), 20, 50)
}

//MARK: 在函数内aa和bb的值发生变化，那么原值也将跟着变化
func name(_ aa: inout Int, _ bb: inout Int) {
    //例：A、B值互换
    let temp = aa
    aa = bb
    bb = temp
}

//MARK: 可返回多个值
func name() -> (aa: Int, bb: Bool, cc: String) {
    return (1, true, "a")
}

//MARK: 参数个数不确定
func name<DDD>(_ aa: DDD...) {
    for i in aa {
        print(i)
    }
}



//FIXME: 闭包


