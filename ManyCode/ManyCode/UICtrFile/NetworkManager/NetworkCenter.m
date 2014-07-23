//
//  NetworkCenter.m
//  ManyCode
//
//  Created by lichengfei on 14-7-22.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "NetworkCenter.h"
#import "NotifyManager.h"
#import "Reachability.h"

@implementation NetworkCenter

+ (instancetype)instanceManager
{
    
    static NetworkCenter *_instanceManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instanceManager = [[NetworkCenter alloc] init];
        _instanceManager.httpClient = [ExproHttpClient sharedClient];
        _instanceManager.notiCenter = [NotifyManager instanceManager];
    });
    
    return _instanceManager;
}

- (id) init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}


/**
 *  请求网络接口,返回请求的响应接口,并作初期数据处理
 *
 *  @param webApi        网络请求的接口
 *  @param para          请求所带的参数
 *  @param completeBlock 成功请求后得到的响应,此响应包括服务器业务逻辑异常结果,只接收服务器业务逻辑状态码为200的结果
 *  @param errorBlock    服务器响应不正常,网络连接失败返回的响应结果
 */
- (void)requestWebWithParaWithURL:(NSString*)webApi Parameter:(NSDictionary *)para Finish:(HttpResponseSucBlock)completeBlock Error:(HttpResponseErrBlock)errorBlock
{
    
    [self.httpClient POST:webApi parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"URL:%@,Responese:%@",operation.request.URL,responseObject);
        NSError *parserError = nil;
        NSDictionary *resultDic = nil;
        @try {
            resultDic = (NSDictionary *)responseObject;
        }
        @catch (NSException *exception) {
            [NSException raise:@"网络接口返回数据异常" format:@"Error domain %@\n,code=%d\n,userinfo=%@",parserError.domain,parserError.code,parserError.userInfo];
            //发出消息错误的通知
        }
        @finally {
            //业务产生的状态码
            NSNumber *logicCode = resultDic[@"ResultStatus"];
            
            //成功获得数据
            if (logicCode.intValue==200) {
                completeBlock(resultDic);
            }
            else{
                //业务逻辑错误
                [[NotifyManager instanceManager] showAlertWithStatusCode:logicCode withAlertView:YES];
                NSError *error = [NSError errorWithDomain:@"服务器业务逻辑错误" code:logicCode.intValue userInfo:nil];
                errorBlock(nil,error);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (![self isExistenceNetwork]) {
            NSError *error = [NSError errorWithDomain:@"网络不可用" code:404 userInfo:nil];
            errorBlock(operation,error);
        }
        else{
            errorBlock(operation,error);
            [[NotifyManager instanceManager] showHttpResponseErrorWith:error WithAlertView:NO];
        }
        
    }];
}


- (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork;
    //    Reachability *reachAblitity = [Reachability reachabilityForInternetConnection];
    Reachability *reachAblitity = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    switch ([reachAblitity currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork=FALSE;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=TRUE;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=TRUE;
            break;
    }
    
    return isExistenceNetwork;
}

@end


@implementation ExproHttpClient

+ (instancetype)sharedClient
{
    static ExproHttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ExproHttpClient alloc] initWithBaseURL:[NSURL URLWithString:EPHttpApiBaseURL]];
        [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
    });
    
    return _sharedClient;
}
@end