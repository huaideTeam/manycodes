//
//  ParkDetailViewController.m
//  ManyCode
//
//  Created by lichengfei on 14-7-22.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "ParkDetailViewController.h"
#import "UINavigationItem+Items.h"
#import "StartParkViewController.h"
#import "MapFootView.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "UIImageView+WebCache.h"

@interface ParkDetailViewController ()
{
    UIScrollView *mainScrollView_;
}

@end

@implementation ParkDetailViewController

#pragma mark - system function

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadFunctionView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - use define

- (void)loadFunctionView
{
    if (IOS7) {
        [self setExtendedLayoutIncludesOpaqueBars:NO];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.title = [_parkInfoDic objectForKey:@"carparkname"];
    
    self.view.backgroundColor = COLOR(235.0, 237.0, 240.0);
    //返回按钮
    UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHome.frame = CGRectMake(0, 0.f, 30, 21.f);
    [btnHome setBackgroundColor:[UIColor clearColor]];
    [btnHome setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnHome setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateHighlighted];
    [btnHome addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    if (IOS7) {
        [self.navigationItem setRightBarButtonItemInIOS7:[[UIBarButtonItem alloc] initWithCustomView:btnHome]];
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnHome];
    }

    
    mainScrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, kCurrentWindowHeight)];
    mainScrollView_.backgroundColor =[UIColor clearColor];
    [self.view addSubview:mainScrollView_];
    
    UIView *titleView = [self creatTitleView];
    [mainScrollView_ addSubview:titleView];
    
    UIView *middleView = [self creatMiddleView];
     [mainScrollView_ addSubview:middleView];
    
    
}


- (void)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 自定义的view

- (UIView *)creatTitleView
{
   MapFootView *  titleView = [[MapFootView alloc] initWithFrame:CGRectMake(0, 10, 320, 100)];
    titleView.parkingName.text = [_parkInfoDic objectForKey:@"carparkname"];
    titleView.parkingDistance.text = [_parkInfoDic objectForKey:@"distance"];
    titleView.parkingAddress.text = [_parkInfoDic objectForKey:@"address"];
    titleView.backgroundColor = [UIColor clearColor];
    [titleView.parkingNavigation addTarget:self action:@selector(startNav:) forControlEvents:UIControlEventTouchUpInside];
    [titleView.parkingMyCar addTarget:self action:@selector(startParking:) forControlEvents:UIControlEventTouchUpInside];
    titleView.detailButton.hidden = YES;
    return titleView;
}


- (UIView *)creatMiddleView
{
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(10, 150, 300, 100)];
    middleView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImage = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 10, 85, 75)];
    iconImage.backgroundColor = [UIColor clearColor];
    [iconImage setImageWithURL:[_parkInfoDic objectForKey:@"images"] placeholderImage:[UIImage imageNamed:@""]];
    [middleView addSubview:iconImage];
    
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 180, 30)];
    nameLable.backgroundColor = [UIColor clearColor];
    nameLable.text = [_parkInfoDic objectForKey:@"address"];
    nameLable.font = FONT(15);
    [middleView addSubview:nameLable];
    
    UILabel *detailLable = [[UILabel alloc] initWithFrame:CGRectMake(110, 45, 180, 30)];
    detailLable.backgroundColor = [UIColor clearColor];
    detailLable.text = [_parkInfoDic objectForKey:@"address"];
    detailLable.font = FONT(15);
    [middleView addSubview:detailLable];
    return middleView;
}

#pragma mark - 停车

//开始导航
- (void)startNav:(UIButton *)button
{
    CLLocationCoordinate2D endPoint;
    endPoint.latitude = [[_parkInfoDic objectForKey:@"gps_lat"] doubleValue];
    endPoint.longitude = [[_parkInfoDic objectForKey:@"gps_lon"] doubleValue];
    AppDelegate *app = [AppDelegate appDelegate];
    [app startNavi:[[NetworkCenter instanceManager] currentPoint] end:endPoint];
}


- (void)startParking:(UIButton *)button
{

}
@end
