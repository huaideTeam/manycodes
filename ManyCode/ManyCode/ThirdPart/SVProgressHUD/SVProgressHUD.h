//
//  SVProgressHUD.h
//  HUD
//
//  Created by christ on 12-12-29.
//  Copyright (c) 2012年 christ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVProgressHUD : UIView

//开始
+(void)startIsEnabled:(BOOL)isEnabled;
//开始+提示信息
+(void)startWithStatus:(NSString *)status isEnabled:(BOOL)isEnabled;
//开始 + 提示信息 + 无图片
+(void)startWithoutActivityIndicatorViewWithStatus:(NSString *)status duration:(NSTimeInterval)duration;

//结束
+(void)stop;
//结束+成功提示信息+默认时间1秒
+(void)stopWithSuccess:(NSString *)successString;
//结束+成功提示信息+消失时间
+(void)stopWithSuccess:(NSString *)successString duration:(NSTimeInterval)duration;

//结束+错误信息+默认时间1秒
+(void)stopWithError:(NSString *)errorString;
//结束+错误信息+消失时间
+(void)stopWithError:(NSString *)errorString duration:(NSTimeInterval)duration;


@end
