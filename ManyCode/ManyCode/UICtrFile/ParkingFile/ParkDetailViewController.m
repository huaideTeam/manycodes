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
#import "LoginViewController.h"

@interface ParkDetailViewController ()
{
    UIScrollView *mainScrollView_;
    NSMutableDictionary *mainDic_;
    UILabel *smallDayPrice_;   //小行车白天
    UILabel *smallPrice_;     //小型车黑天
    UILabel *bigDayPrice_;  //大车白天
    UILabel *bigPrice_; //大车黑天

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
    
    UIView *footView = [self creatFootView];
    [mainScrollView_ addSubview:footView];
    
    mainScrollView_.contentSize = CGSizeMake(320,CGRectGetMaxY(footView.frame));
    [self loadDataWithId];
    
}


- (void)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 加载数据

- (void)loadDataWithId
{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    [tempDic setObject:[_parkInfoDic objectForKey:@"carparkid"] forKey:@"carparkid"];
    [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getCarparkInfo" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
        NSLog(@"1233");
        mainDic_ = [NSMutableDictionary dictionaryWithDictionary:resultDic];
        smallDayPrice_.text = [mainDic_ objectForKey:@"morstandard_car"];
        smallPrice_.text = [mainDic_ objectForKey:@"nightstandard_car"];
        bigDayPrice_.text = [mainDic_ objectForKey:@"morstandard_bus"];
        bigPrice_.text = [mainDic_ objectForKey:@"nightstandard_bus"];
        
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

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
    titleView.nameButton.hidden = YES;
    return titleView;
}


- (UIView *)creatMiddleView
{
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(10, 130, 300, 100)];
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

- (UIView *)creatFootView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 280, 320, 300)];
    footView.backgroundColor = [UIColor clearColor];
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textColor =COLOR(97, 97, 97);
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = @"停车收费标准";
    titleLable.font = FONT(30);
    [footView addSubview:titleLable];
    
    UIImageView *mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 45, 280, 200)];
    mainImage.image = [UIImage imageNamed:@"tingchechangkuang.png"];
    [footView addSubview:mainImage];
    
    UILabel *dayLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 93, 30)];
    dayLable.text = @"白天时段";
    dayLable.textAlignment = NSTextAlignmentCenter;
    dayLable.font = FONT(20);
    dayLable.textColor =COLOR(75, 75, 75);
    [mainImage addSubview:dayLable];
    
    UILabel *dayLable1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 93, 30)];
    dayLable1.text = @"(元/15分钟)";
    dayLable1.textAlignment = NSTextAlignmentCenter;
    dayLable1.textColor =COLOR(75, 75, 75);
    [mainImage addSubview:dayLable1];
    
    
    UILabel *darkLable = [[UILabel alloc] initWithFrame:CGRectMake(192, 20, 93, 30)];
    darkLable.text = @"夜间时段";
    darkLable.textAlignment = NSTextAlignmentCenter;
    darkLable.font = FONT(20);
    darkLable.textColor =COLOR(75, 75, 75);
    [mainImage addSubview:darkLable];

    
    UILabel *darkLable1 = [[UILabel alloc] initWithFrame:CGRectMake(192, 50, 93, 30)];
    darkLable1.text = @"(元/小时)";
    darkLable1.textAlignment = NSTextAlignmentCenter;
    darkLable1.textColor =COLOR(75, 75, 75);
    [mainImage addSubview:darkLable1];
    
    smallDayPrice_ = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 93, 30)];
    smallDayPrice_.textAlignment = NSTextAlignmentCenter;
    smallDayPrice_.font = FONT(20);
    smallDayPrice_.textColor =COLOR(75, 75, 75);
    [mainImage addSubview:smallDayPrice_];
    
    
    smallPrice_ = [[UILabel alloc] initWithFrame:CGRectMake(192, 20, 93, 30)];
    smallPrice_.textAlignment = NSTextAlignmentCenter;
    smallPrice_.textColor =COLOR(75, 75, 75);
    [mainImage addSubview:smallPrice_];
    
    bigDayPrice_ = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 93, 30)];
    bigDayPrice_.textAlignment = NSTextAlignmentCenter;
    bigDayPrice_.font = FONT(20);
    bigDayPrice_.textColor =COLOR(75, 75, 75);
    [mainImage addSubview:bigDayPrice_];
    
    
    bigPrice_ = [[UILabel alloc] initWithFrame:CGRectMake(192, 20, 93, 30)];
    bigPrice_.textAlignment = NSTextAlignmentCenter;
    bigPrice_.textColor =COLOR(75, 75, 75);
    [mainImage addSubview:bigPrice_];
    
    return footView;
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
    if ([NetworkCenter instanceManager].isLogin) {
        NSArray *array = [NetworkCenter instanceManager].devroadArray;
        if (array.count>0) {
            NSDictionary *dic = [array objectAtIndex:0];
            NSString *msg = [NSString stringWithFormat:@"当前所在停车场：%@",dic[@"carparkname"]];
            if ([dic[@"devroadstatus"] isEqualToString:_parkInfoDic[@"devroadstatus"]]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }else
            {
                StartParkViewController *viewCtr = [[StartParkViewController alloc] init];
                [self.navigationController pushViewController:viewCtr animated:YES];
            }
        }else
        {
            StartParkViewController *viewCtr = [[StartParkViewController alloc] init];
            viewCtr.isComeIn = YES;
            [self.navigationController pushViewController:viewCtr animated:YES];
        }
    }else
    {
        LoginViewController *viewCtr = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:viewCtr animated:YES];
    }
}
@end
