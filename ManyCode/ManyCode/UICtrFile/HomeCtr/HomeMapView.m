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
#import "MapFootView.h"
#import "AppDelegate.h"

@interface HomeMapView ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKLocationService *locationManager_;
    BMKMapView *mymapkit_;
    BMKUserLocation * location_;
    MapFootView *footView_;
    NSMutableArray *anonationArray_;
    NSMutableArray *dataArray_;
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
    
    [self creatFootView];

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
    [mymapkit_ updateLocationData:userLocation];

}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation.location) {
        
        if (!location_) {
            location_ = userLocation;
            BMKCoordinateSpan theSpan;
            
            theSpan.latitudeDelta=0.01;
            
            theSpan.longitudeDelta=0.01;
            BMKCoordinateRegion theRegion;
            
            theRegion.center= location_.location.coordinate;
            theRegion.span = theSpan;
            
            [self.delegate LoadCurrentInfo:location_.location.coordinate];
            
            [mymapkit_ setRegion:theRegion];
        }else
        {
            CLLocation *current=[[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.latitude];
            //第二个坐标
            CLLocation *before=[[CLLocation alloc] initWithLatitude:location_.location.coordinate.latitude longitude:location_.location.coordinate.latitude];
            // 计算距离
            CLLocationDistance meters=[current distanceFromLocation:before];
            if (meters>500) {
                location_ = userLocation;
                [self.delegate LoadCurrentInfo:location_.location.coordinate];
            }
        }
    }
      [mymapkit_ updateLocationData:userLocation];
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

#pragma mark -  底部的停车场信息

- (void)creatFootView
{
    footView_ = [[MapFootView alloc] initWithFrame:CGRectMake(0, kCurrentWindowHeight - kTopImageHeight - 140, 320, 100)];
    footView_.parkingName.text = @"汇智大厦停车场";
    footView_.parkingDistance.text = @"231米";
    footView_.parkingAddress.text = @"宁双路28号";
    footView_.backgroundColor = [UIColor clearColor];
    [footView_.parkingNavigation addTarget:self action:@selector(startNav:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:footView_];
}

//开始导航
- (void)startNav:(UIButton *)button
{
    CLLocationCoordinate2D startPoint;
     CLLocationCoordinate2D endPoint;
    AppDelegate *app = [AppDelegate appDelegate];
    [app startNavi:startPoint end:endPoint];
}


#pragma mark - 刷新停车场上的位置信息

// 刷新界面上停车场的位置信息
- (void)updateAnimationView:(NSMutableArray *)array
{
    [mymapkit_ removeAnnotations:anonationArray_];
    
    dataArray_ = [NSMutableArray arrayWithArray:array];
    anonationArray_ = [[NSMutableArray alloc] initWithCapacity:12];
    for (int k = 0; k< [array count]; k++) {
        NSDictionary *dic = [array objectAtIndex:k];
        CLLocationCoordinate2D coor;
        coor.longitude = [[dic objectForKey:@"gps_lon"] doubleValue];
        coor.latitude = [[dic objectForKey:@"gps_lat"] doubleValue];
        
        ExproAnnotation *ann = [[ExproAnnotation alloc] init];
        ann.coordinate = coor;
        ann.tag = 100+k;
        [anonationArray_ addObject:ann];
    }
    [mymapkit_ addAnnotations:anonationArray_];
}

-(BMKAnnotationView *)mapView:(BMKMapView *)theMapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    
    BMKAnnotationView *newAnnotation=[[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
    newAnnotation.image = [UIImage imageNamed:@"HJSJ_iPhone_red.png"];
    newAnnotation.annotation = annotation;
    newAnnotation.tag = [(ExproAnnotation *)annotation tag];
    newAnnotation.canShowCallout = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectChange:)];
    [newAnnotation addGestureRecognizer:tap];
    return newAnnotation;
    
}

- (void)selectChange:(UITapGestureRecognizer *)sender
{
    NSInteger viewTag = sender.view.tag;
    NSDictionary *dic = [dataArray_ objectAtIndex:viewTag-100];
    
    footView_.parkingName.text = [dic objectForKey:@"carparkname"];
    footView_.parkingDistance.text = [dic objectForKey:@"distance"];
    footView_.parkingAddress.text = [dic objectForKey:@"address"];
    footView_.tag = viewTag;
    
}


@end
