//
//  NotifyManager.h
//  FishingJoy
//
//  Created by expro on 14-1-9.
//  Copyright (c) 2014年 expro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotifyManager : NSObject
{
@private
    NSDictionary *errorCodeDict;
    NSInteger errorType_;
}

+ (instancetype)instanceManager;

- (void)showAlertWithStatusCode:(NSNumber *)statusCode withAlertView:(BOOL)showAlertView;

- (void)showHttpResponseErrorWith:(NSError *)error WithAlertView:(BOOL)showAlertView;

- (void)showMsg:(NSString *)msg WithAlertView:(BOOL)showAlertView;


@end
