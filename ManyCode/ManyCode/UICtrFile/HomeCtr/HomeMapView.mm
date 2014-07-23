//
//  HomeMapView.m
//  ManyCode
//
//  Created by lichengfei on 14-7-23.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "HomeMapView.h"
#import "BMapKit.h"
#import "BMKUserLocation.h"
#import "ExproAnnotation.h"
#import "BMKTypes.h"


@interface HomeMapView ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKLocationService *locationManager_;
    BMKMapView *mymapkit_;
    BMKUserLocation * location_;
}

@end

@implementation HomeMapView

#pragma mark - system function

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadFunctionView ];
    }
    return self;
}

#pragma mark - use define

- (void)loadFunctionView
{
    self.backgroundColor = [UIColor whiteColor];
    mymapkit_ = [[BMKMapView alloc] initWithFrame:self.bounds];
    mymapkit_.delegate = self;
    mymapkit_.showsUserLocation = NO;//先关闭显示的定位图层
    mymapkit_.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    mymapkit_.showsUserLocation = YES;//显示定位图层
    [self addSubview:mymapkit_];
    
    locationManager_ = [[BMKLocationService alloc]init];
    locationManager_.delegate = self;
    [locationManager_ startUserLocationService];

}




#pragma mark - map delegate

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    location_ = userLocation;
    [mymapkit_ updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    
    if (userLocation.location) {
        location_ = userLocation;
        BMKCoordinateSpan theSpan;
        
        theSpan.latitudeDelta=0.01;
        
        theSpan.longitudeDelta=0.01;
        BMKCoordinateRegion theRegion;
        
        theRegion.center= location_.location.coordinate;
        theRegion.span = theSpan;
        
        [mymapkit_ setRegion:theRegion];
        //        [mymapkit_ updateLocationData:userLocation];
        [locationManager_ stopUserLocationService];
    }
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


@end
