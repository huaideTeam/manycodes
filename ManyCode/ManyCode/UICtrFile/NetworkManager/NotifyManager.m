//
//  NotifyManager.m
//  FishingJoy
//
//  Created by expro on 14-1-9.
//  Copyright (c) 2014年 expro. All rights reserved.
//

#import "NotifyManager.h"

@implementation NotifyManager

+ (instancetype) instanceManager
{
    static NotifyManager *_instanceMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instanceMgr = [[NotifyManager alloc] init];
        [_instanceMgr initCenter];
    });
    
    return _instanceMgr;
}

- (id) init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}


- (void)initCenter
{
    NSString *errorCodePath = [[NSBundle mainBundle] pathForResource:@"ErrCode" ofType:@"plist"];
    errorCodeDict = [NSDictionary dictionaryWithContentsOfFile:errorCodePath];
    if (!errorCodeDict) {
        [SVProgressHUD stopWithError:@"未能获得状态码表"];
    }
}

- (void)showAlertWithStatusCode:(NSNumber *)statusCode withAlertView:(BOOL)showAlertView
{
    errorType_ = [statusCode integerValue];
    NSString *errorCodeString = [NSString stringWithFormat:@"%@",statusCode];
    NSString *errorMsg = errorCodeDict[errorCodeString];
    if (!errorMsg) return;
    [self showMsg:errorMsg WithAlertView:showAlertView];
}

- (void)showHttpResponseErrorWith:(NSError *)error WithAlertView:(BOOL)showAlertView
{
    NSString *errorMsg = error.localizedDescription;
    [self showMsg:errorMsg WithAlertView:showAlertView];
}

- (void)showMsg:(NSString *)msg WithAlertView:(BOOL)showAlertView
{
    if (showAlertView) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [SVProgressHUD stop];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD stopWithError:msg];
        });
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (errorType_ == 401) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushLoginView" object:nil];
    }
}
@end
