//
//  AppDelegate.h
//  ManyCode
//
//  Created by lichengfei on 14-7-21.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKMapManager.h"
#import "BMapKit.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) BMKMapManager *mapManager;

+ (AppDelegate *)appDelegate;

@end
