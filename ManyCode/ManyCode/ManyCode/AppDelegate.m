//
//  AppDelegate.m
//  ManyCode
//
//  Created by lichengfei on 14-7-21.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"eS2DDfOx9pHjosb4bBmGMLK0" generalDelegate:nil];
    if (!ret) {
        NSLog(@"Baidu Map start failed");
    }

    [self commonSetting];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    MainViewController *viewCtr =   [[MainViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewCtr];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
 
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - seting

- (void)commonSetting
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar.png"] forBarMetrics:UIBarMetricsDefault];
    //设置通用UINavigationContrlloer title属性的颜色和字体
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], UITextAttributeTextColor,
                                                          [UIColor blackColor], UITextAttributeTextShadowColor,
                                                          [UIFont boldSystemFontOfSize:20.f],UITextAttributeFont,nil]];
    [[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, 1.0) forBarMetrics:UIBarMetricsDefault];
}


#pragma mark -
+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
