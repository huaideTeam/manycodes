//
//  StartNavDelegate.h
//  ManyCode
//
//  Created by lichengfei on 14-7-24.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol StartNavDelegate <NSObject>

- (void)pushToStartNavWith:(CLLocationCoordinate2D)startPoint end:(CLLocationCoordinate2D)endPoint;

@end
