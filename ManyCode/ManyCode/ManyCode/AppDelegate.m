//
//  AppDelegate.m
//  ManyCode
//
//  Created by lichengfei on 14-7-21.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "BNCoreServices.h"
#import "BNaviSoundManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if (IOS7) {
        [[UITableViewCell appearance] setSeparatorInset:UIEdgeInsetsZero];
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:[[NSUserDefaults standardUserDefaults] boolForKey:kAllowIdleTimerInvalid]];
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"eS2DDfOx9pHjosb4bBmGMLK0" generalDelegate:nil];
    if (!ret) {
        NSLog(@"Baidu Map start failed");
    }

    // 初始化导航SDK引擎
    [BNCoreServices_Instance initServices:@"eS2DDfOx9pHjosb4bBmGMLK0"];
    
    //开启引擎，传入默认的TTS类
    [BNCoreServices_Instance startServicesAsyn:nil fail:nil SoundService:[BNaviSoundManager getInstance]];
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
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor greenColor]];
    [[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, 1.0) forBarMetrics:UIBarMetricsDefault];
}


#pragma mark -
+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


#pragma mark - stat nav

- (void)startNavi:(CLLocationCoordinate2D)startPoint end:(CLLocationCoordinate2D)endPoint
{
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
    //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    startNode.pos.x = startPoint.longitude;
    startNode.pos.y = startPoint.latitude;
    startNode.pos.eType = BNCoordinate_OriginalGPS;
    [nodesArray addObject:startNode];
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = endPoint.longitude;
    endNode.pos.y = endPoint.latitude;
    endNode.pos.eType = BNCoordinate_OriginalGPS;
    [nodesArray addObject:endNode];
    
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
    
    
}


#pragma mark - BNNaviRoutePlanDelegate
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    
    //路径规划成功，开始导航
    [BNCoreServices_UI showNaviUI:BN_NaviTypeReal delegete:self isNeedLandscape:YES];
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"算路失败");
    if ([error code] == BNRoutePlanError_LocationFailed) {
        NSLog(@"获取地理位置失败");
    }
    else if ([error code] == BNRoutePlanError_LocationServiceClosed)
    {
        NSLog(@"定位服务未开启");
    }
}

//算路取消回调
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    NSLog(@"算路取消");
}

#pragma mark - BNNaviUIManagerDelegate

//退出导航回调
-(void)onExitNaviUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出导航");

}

//退出导航声明页面回调
- (void)onExitexitDeclarationUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出导航声明页面");
}


@end
