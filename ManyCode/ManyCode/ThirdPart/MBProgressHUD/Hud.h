//
//  Hud.h
//  Pantheon
//
//  Created by 常 屹 on 14/6/11.
//  Copyright (c) 2014年 常 屹. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBProgressHUD;

@interface Hud : NSObject{
    MBProgressHUD   *mbProgressHUD;
}

+ (instancetype)defaultInstance;
- (void)showMessage:(NSString *)message;
- (void)loading:(UIView *)view;
- (void)loading:(UIView *)view withText:(NSString *)text;
- (void)hide:(UIView *)view;
- (void)showMessage:(NSString *)message withHud:(BOOL)flag;

@end
