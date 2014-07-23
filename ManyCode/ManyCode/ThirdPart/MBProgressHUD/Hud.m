//
//  Hud.m
//  Pantheon
//
//  Created by 常 屹 on 14/6/11.
//  Copyright (c) 2014年 常 屹. All rights reserved.
//

#import "Hud.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@implementation Hud

static Hud *instance = nil;

+ (instancetype)defaultInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Hud alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        UINavigationController *navController = (UINavigationController *)[AppDelegate appDelegate].window.rootViewController;
        mbProgressHUD = [[MBProgressHUD alloc] initWithView:navController.view];
    }
    
    return self;
}


- (void)showMessage:(NSString *)message
{
    [self showMessage:message withHud:NO];
}

- (void)showMessage:(NSString *)message withHud:(BOOL)flag
{
    if (!flag) {
        [[AppDelegate appDelegate].window addSubview:mbProgressHUD];
        [mbProgressHUD show:YES];
    }
    
    mbProgressHUD.mode = MBProgressHUDModeText;
    mbProgressHUD.labelText = @"";
    mbProgressHUD.detailsLabelText = message;
    mbProgressHUD.margin = 10.f;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        
        mbProgressHUD.yOffset = 80.f;
        
    }
    else {
        if (IPHONE5) {
            mbProgressHUD.yOffset = 200.f;
        }
        else {
            mbProgressHUD.yOffset = 150.f;
        }
    }
    

    
    mbProgressHUD.removeFromSuperViewOnHide = YES;
    [mbProgressHUD hide:YES afterDelay:2.f];
}

- (void)loading:(UIView *)view
{
    [self loading:view withText:@"加载中，请稍后..."];
}

- (void)loading:(UIView *)view withText:(NSString *)text
{
    mbProgressHUD.margin = 20.f;
    mbProgressHUD.labelText = text;
    mbProgressHUD.detailsLabelText = @"";
    mbProgressHUD.mode = MBProgressHUDModeIndeterminate;
    mbProgressHUD.yOffset = 0.f;
    
    [view addSubview:mbProgressHUD];
    [mbProgressHUD show:YES];
}

- (void)hide:(UIView *)view
{
    //[MBProgressHUD hideHUDForView:[AppDelegate appDelegate].window animated:YES];
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
