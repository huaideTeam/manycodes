//
//  HomeEventDelegate.h
//  ManyCode
//
//  Created by lichengfei on 14-7-25.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol HomeEventDelegate <NSObject>

@optional

//点击导航数据
- (void)currentNavView:(UIView *)ctView clickIndex:(NSInteger)index;

//点击停车数据
- (void)currentParkView:(UIView *)ctView clickIndex:(NSInteger)index;

//进入停车场详情界面
- (void)pushToParkDetailView:(UIView *)ctView clickIndex:(NSInteger)index;

//地理位置更新 ，刷新数据
- (void)LoadCurrentInfo:(CLLocationCoordinate2D)currentPoint;

@end
