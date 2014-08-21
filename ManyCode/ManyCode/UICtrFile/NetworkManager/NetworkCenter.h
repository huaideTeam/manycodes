//
//  NetworkCenter.h
//  ManyCode
//
//  Created by lichengfei on 14-7-22.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>


static NSString *const EPHttpApiBaseURL = @"http://www.manycode.com.cn/switch.php/User/";


/**
 *  请求成功后的数据简单处理后的回调
 *
 *  @param resultDic 返回的字典对象
 */
typedef void (^HttpResponseSucBlock) (NSDictionary *resultDic);
/**
 *  请求失败后的响应及错误实例
 *
 *  @param operation 响应
 *  @param erro      错误实例
 */
typedef void (^HttpResponseErrBlock) (AFHTTPRequestOperation *operation,NSError *error);


@class ExproHttpClient;
@class NotifyManager;

@interface NetworkCenter : NSObject<CBCentralManagerDelegate>

@property (nonatomic, assign) ExproHttpClient *httpClient;
@property (nonatomic, assign) NotifyManager *notiCenter;
@property (nonatomic, assign) CLLocationCoordinate2D currentPoint;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) NSArray *devroadArray;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) CBCentralManager *manager;


+ (instancetype)instanceManager;

/**
 *  请求网络接口,返回请求的响应接口,并作初期数据处理
 *
 *  @param webApi        网络请求的接口
 *  @param para          请求所带的参数
 *  @param completeBlock 成功请求后得到的响应,此响应包括服务器业务逻辑异常结果,只接收服务器业务逻辑状态码为200的结果
 *  @param errorBlock    服务器响应不正常,网络连接失败返回的响应结果
 */
- (void)requestWebWithParaWithURL:(NSString*)webApi Parameter:(NSDictionary *)para Finish:(HttpResponseSucBlock)completeBlock Error:(HttpResponseErrBlock)errorBlock;



@end


@interface ExproHttpClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

@end

