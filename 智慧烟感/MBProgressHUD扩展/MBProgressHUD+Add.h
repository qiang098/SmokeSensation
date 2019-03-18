//
//  MBProgressHUD+Add.h
//  YNYJ
//
//  Created by mjz on 16-8-01.
//  Copyright (c) 2016年 JiuHangKeJi. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)

//MJ_MBProgressHUD
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;

/**
 *  JZ_MBProgressHUD转圈加载
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view doBlock:(void (^)())dosomething;

/**
 *  JZ_MBProgressHUD提示
 */
+ (void )showInfoWithStatus:(NSString *)message toView:(UIView *)view;


@end
