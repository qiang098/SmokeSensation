//
//  DataRequestManager.m
//  OpenNewLife
//
//  Created by qiangge on 2018/12/7.
//  Copyright © 2018年 shiqiang. All rights reserved.
//

#import "DataRequestManager.h"
#import <JPUSHService.h>
//#ifdef DEBUG
//static NSString *url = @"http://124.126.15.101:8810/xfyun/";
//#else
static NSString *url = @"http://42.101.44.234:8810/xfyun/";
//#endif

@implementation DataRequestManager

+ (id)manager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}
- (UIWindow *)window{
    return [UIApplication sharedApplication].delegate.window;
}
- (void)jpushSetAlias:(NSString *)alias{
    [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:1990];
}
#pragma mark - 发送验证码
- (void)sendVcodeWithTel:(NSString *)tel success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    NSDictionary *parameters = @{@"telphone":tel};
    [self downloadDataForName:@"sendVcode" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 发送登录
- (void)loginWithTel:(NSString *)tel password:(NSString *)password success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    
    NSDictionary *parameters = @{@"telphone":tel, @"password":password};
    [self downloadDataForName:@"appLogin" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 新用户注册
- (void)userLogonWithName:(NSString *)cust_name telphone:(NSString *)telphone cert_id:(NSString *)cert_id password:(NSString *)password Vcode:(NSString *)Vcode success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    NSDictionary *parameters = @{@"cust_name":cust_name,@"telphone":telphone,@"cert_id":cert_id, @"password":password,@"Vcode":Vcode};
    [self downloadDataForName:@"userLogon" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 修改密码
- (void)updatePassWithPhoneNo:(NSString *)phoneNo password:(NSString *)password vcode:(NSString *)vcode success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    NSDictionary *parameters = @{@"phoneNo":phoneNo,@"passWord":password,@"vcode":vcode};
    [self downloadDataForName:@"updatePass" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 场所列表
- (void)getPlaceListWithTel:(NSString *)telphone page:(NSString *)page rows:(NSString *)rows success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    if (!page){
        page = @"1";
    }
    if (!rows){
        rows = @"100";
    }
    NSDictionary *parameters = @{@"telphone":telphone,@"page":page,@"rows":rows};
    [self downloadDataForName:@"getPlaceList" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}

#pragma mark - 新建场所
- (void)addPlaceWithParameters:(NSDictionary *)parameters success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    [self downloadDataForName:@"addPlace" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 删除场所
- (void)deletePlaceWithPlaceId:(NSString *)placeId success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    NSDictionary *parameters = @{@"placeId":placeId};
    [self downloadDataForName:@"deletePlace" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 场所所有设备列表
- (void)getAllDeviceList:(NSString *)telphone page:(NSString *)page rows:(NSString *)rows success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    if (!page){
        page = @"1";
    }
    if (!rows){
        rows = @"100";
    }
    NSDictionary *parameters = @{@"telphone":telphone,@"page":page,@"rows":rows};
    
    [self downloadDataForName:@"getDeviceList" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 场所设备列表
- (void)getDeviceListWithPlaceId:(NSString *)placeId page:(NSString *)page rows:(NSString *)rows success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    if (!page){
        page = @"1";
    }
    if (!rows){
        rows = @"100";
    }
    NSDictionary *parameters = @{@"placeId":placeId,@"page":page,@"rows":rows};
    
    [self downloadDataForName:@"getDeviceList" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 设备消息查询
- (void)getDeviceWarnInfoListWithTel:(NSString *)telphone type:(NSString *)type  page:(NSString *)page rows:(NSString *)rows success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    NSDictionary *parameters = @{@"telphone":telphone,@"type":type,@"rows":rows,@"page":page};
    [self downloadDataForName:@"getDeviceWarnInfoList" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 获取推送历史消息
- (void)getPushListWithPhoneNo:(NSString *)phoneNo success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    NSDictionary *parameters = @{@"phoneNo":phoneNo};
    [self downloadDataForName:@"getPushList" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 更改联系人
- (void)updateEmergenPersonWithParameters:(NSDictionary *)parameters success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    [self downloadDataForName:@"updateEmergenPerson" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 设备新增
- (void)addDeviceWithDeviceId:(NSString *)deviceId deviceAddr:(NSString *)deviceAddr placeId:(NSString *)placeId producer:(NSString *)producer success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    NSDictionary *parameters = @{@"deviceId":deviceId,@"deviceAddr":deviceAddr,@"placeId":placeId,@"producer":producer};
    [self downloadDataForName:@"addDevice" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 设备新增设备删除
- (void)delDeviceWithDeviceId:(NSString *)deviceId producer:(NSString *)producer success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    NSDictionary *parameters = @{@"deviceId":deviceId,@"producer":producer};
    [self downloadDataForName:@"delDevice" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 设备修改
- (void)updateDeviceWithDeviceId:(NSString *)deviceId deviceAddr:(NSString *)deviceAddr placeId:(NSString *)placeId success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    NSDictionary *parameters = @{@"deviceId":deviceId,@"installAddr":deviceAddr,@"placeId":placeId};
    [self downloadDataForName:@"updateDevice" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 获取用户下设备是否有火警
- (void)ifFireWithPhoneNo:(NSString *)phoneNo success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    NSDictionary *parameters = @{@"phoneNo":phoneNo};
    [self downloadDataForName:@"ifFire" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 添加联系人
- (void)addPersonWithPlaceId:(NSString *)placeId personName:(NSString *)personName   personTel:(NSString *)personTel  success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    NSDictionary *parameters = @{@"placeId":placeId,@"personName":personName,@"personTel":personTel};
    [self downloadDataForName:@"addPerson" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 获取联系人
- (void)getPersonListWithPlaceId:(NSString *)placeId success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    NSDictionary *parameters = @{@"placeId":placeId};
    [self downloadDataForName:@"getPersonList" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}

#pragma mark -  删除联系人
- (void)delPersonWithPlaceId:(NSString *)placeId personTel:(NSString *)personTel success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    NSDictionary *parameters = @{@"placeId":placeId,@"personTel":personTel};
    [self downloadDataForName:@"delPerson" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 消音
- (void)getMufflingWithDeviceId:(NSString *)deviceId producer:(NSString *)producer success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    NSDictionary *parameters = @{@"deviceId":deviceId,@"producer":producer};
    [self downloadDataForName:@"getMuffling" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 状态修改
- (void)updateFireStateWithId:(NSString *)Id type:(NSString *)type success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    NSDictionary *parameters = @{@"id":Id,@"type":type};
    [self downloadDataForName:@"updateFireState" parameters:parameters success:^(id responseObject) {
        successRequestCompletionn(responseObject);
    } failure:^(NSError *error) {
        failureRequestCompletionn(error);
    }];
}
#pragma mark - 请求数据
- (void)downloadDataForName:(NSString *)name parameters:(NSDictionary *)parameters success:(successRequestCompletionn)successRequestCompletionn failure:(failureRequestCompletionn)failureRequestCompletionn{
    [MBProgressHUD showHUDAddedTo:[self window] animated:YES];
    // 请求头
    NSString *urlString =[NSString stringWithFormat:@"%@%@",url,name];
    //初始化一个AFHTTPSessionManager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求体数据为json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置响应体数据为json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:[self window] animated:YES];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            successRequestCompletionn(responseObject);
        }else{
            successRequestCompletionn([self getDictionaryWithJson:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:[self window] animated:YES];
        failureRequestCompletionn(error);
    }];
}
- (id)getDictionaryWithJson:(NSString *)jsonString{
    
    NSError *parseError = nil;
    if (jsonString) {
        NSData *JsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        id JsonDic = [NSJSONSerialization JSONObjectWithData:JsonData options:NSJSONReadingMutableLeaves error:&parseError];
        
        return JsonDic;
    }else{
        return [NSNull null];
    }
}
@end
