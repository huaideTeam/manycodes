//
//  HomeMapView.h
//  ManyCode
//
//  Created by lichengfei on 14-7-23.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@protocol HomeMapDelegate <NSObject>

@optional

- (void)LoadCurrentInfo:(CLLocationCoordinate2D)currentPoint;

@end

@interface HomeMapView : UIView

@property (nonatomic, assign)id<HomeMapDelegate>delegate;

// 刷新界面上停车场的位置信息
- (void)updateAnimationView:(NSMutableArray *)array;

@end
