//
//  StartNavitationViewController.h
//  ManyCode
//
//  Created by lichengfei on 14-7-23.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface StartNavitationViewController : UIViewController

@property (nonatomic, assign) CLLocationCoordinate2D startPoint;

@property (nonatomic, assign) CLLocationCoordinate2D endPoint;

@end
