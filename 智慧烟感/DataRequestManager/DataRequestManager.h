//
//  DataRequestManager.h
//  OpenNewLife
//
//  Created by qiangge on 2018/12/7.
//  Copyright © 2018年 shiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"

typedef void (^successRequestCompletionn)(id responseObject);
typedef void (^failureRequestCompletionn)(NSError *error);

@interface DataRequestManager : NSObject
//初始化
+ (instancetype)manager;
#pragma mark - 极光推送绑定用户手机号码
/**
 * 极光推送绑定用户手机号码
 alias:手机号
 */
- (void)jpushSetAlias:(NSString *)alias;
#pragma mark - 发送验证码、登录、注册、修改密码
/**
 * 发送验证码
 tel:手机号
 */
- (void)sendVcodeWithTel:(NSString *)tel success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;

/**
 * 登录
 * telphone    String        不可空    手机号(登陆工号)
 * password    String        不可空    密码
 */
- (void)loginWithTel:(NSString *)tel password:(NSString *)password success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;
/**
 * 新用户注册
 * cust_name    String        不可空    用户名
 * telphone    String        不可空    手机号(登陆工号)
 * cert_id    String        不可空    身份证号
 * password    String        不可空    密码
 * Vcode    String        不可空    验证码
 */
- (void)userLogonWithName:(NSString *)cust_name telphone:(NSString *)telphone cert_id:(NSString *)cert_id password:(NSString *)password Vcode:(NSString *)Vcode success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;

/**
 * 密码修改
 phoneNo:手机号
 password:密码
 vcode:验证码
 */
- (void)updatePassWithPhoneNo:(NSString *)phoneNo password:(NSString *)password vcode:(NSString *)vcode success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;
#pragma mark - 增、删、改场所和设备
/*场所列表
 telphone:手机号(登陆工号)
 page 页数
 rows 一页几条
 */
- (void)getPlaceListWithTel:(NSString *)telphone page:(NSString *)page rows:(NSString *)rows success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;

/*添加场所
 placeName;//    场所名称
 placeAddr;//    场所位置
 regionCode;//    区域
 longitude;//    经度
 latitude;//纬度
 custId;//所属用户
 manager;//负责人
 managerPhone;//    负责人电话
 */
- (void)addPlaceWithParameters:(NSDictionary *)parameters success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;
/**
 * 删除场所
 placeId
 */
- (void)deletePlaceWithPlaceId:(NSString *)placeId success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;

/*所有设备
 telphone:用户电话
 page 页数
 rows 一页几条
 */
- (void)getAllDeviceList:(NSString *)telphone page:(NSString *)page rows:(NSString *)rows success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;

/*设备列表
    placeId:场所编码
    page 页数
    rows 一页几条
 */
- (void)getDeviceListWithPlaceId:(NSString *)placeId page:(NSString *)page rows:(NSString *)rows success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;

/*设备新增
    deviceId:设备编码
    deviceAddr:设备地址
    placeId:场所编码
    producer:设备厂家
    设备厂家
     * 中消云
     * id="1"
     * Name="JTY-GF-TX3190-NB"
     * <p>
     * 日海
     * Id="2";
     * Name="JD-SD51"
     * <p>
     * 海信
     * Id="0"
     * Name="JTYJ-GD-HS90/BW"
     * 大华
     * Id="3"
     * Name="DH-HY-SA-K923-EN"
 */
- (void)addDeviceWithDeviceId:(NSString *)deviceId deviceAddr:(NSString *)deviceAddr placeId:(NSString *)placeId producer:(NSString *)producer success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;

/*设备删除
    deviceId:设备编码
    producer:设备
 */
- (void)delDeviceWithDeviceId:(NSString *)deviceId producer:(NSString *)producer success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;

/*设备修改
     deviceId:设备编码
     deviceAddr:设备地址(安装位置)
     placeId:场所编码
 */
- (void)updateDeviceWithDeviceId:(NSString *)deviceId deviceAddr:(NSString *)deviceAddr placeId:(NSString *)placeId success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;
#pragma mark - 增、删联系人
/*添加联系人
 placeId:场所编码
 personName:联系人姓名
 personTel:联系人电话
 */
- (void)addPersonWithPlaceId:(NSString *)placeId personName:(NSString *)personName  personTel:(NSString *)personTel  success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;

/*获取联系人
 placeId:场所编码
 */
- (void)getPersonListWithPlaceId:(NSString *)placeId success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;

/**
 * 删除联系人
 * */
- (void)delPersonWithPlaceId:(NSString *)placeId personTel:(NSString *)personTel success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;

#pragma mark - 消息界面
#pragma mark - 问题 type？
/*设备消息查询
 telephone:手机号码
 type:类型
     火警
     type = 1;
     其他
     type = 2;
 */
- (void)getDeviceWarnInfoListWithTel:(NSString *)telphone type:(NSString *)type  page:(NSString *)page rows:(NSString *)rows success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;

/**
 *  获取推送历史消息
 */
- (void)getPushListWithPhoneNo:(NSString *)phoneNo success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;

/*获取用户下设备是否有火警
    phoneNo:用户手机号
 */
- (void)ifFireWithPhoneNo:(NSString *)phoneNo success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;

/**
 * 状态修改
 id:消息id
 type:火警确认、火警错误、火警测试对应的 1、2、3
 */
#pragma mark - type? id?
- (void)updateFireStateWithId:(NSString *)Id type:(NSString *)type success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;

/**
 * 消音
 deviceId:设备id
 producer:厂家
 */
- (void)getMufflingWithDeviceId:(NSString *)deviceId producer:(NSString *)producer success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn;

@end
