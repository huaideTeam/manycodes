//
//  MainViewController.m
//  ManyCode
//
//  Created by lichengfei on 14-7-21.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "MainViewController.h"
#import "UINavigationItem+Items.h"
#import "PersonalCenterViewController.h"
#import "ParkDetailViewController.h"
#import "HomeListView.h"

@interface MainViewController ()<UITextFieldDelegate>
{
    UITextField *searchText_;
    HomeMapView *mapView_;
    HomeListView *listView_;
    NSMutableArray *dataArray_;
}

@end

@implementation MainViewController

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

#pragma mark - usedefine

- (void)loadFunctionView
{
    if (IOS7) {
        [self setExtendedLayoutIncludesOpaqueBars:NO];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.title = @"抢车位";
    self.view.backgroundColor = [UIColor blueColor];
    
    dataArray_ = [[NSMutableArray alloc] initWithCapacity:12];
    
    //返回按钮
    UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHome.frame = CGRectMake(0, 0.f, 24, 25.f);
    [btnHome setBackgroundColor:[UIColor clearColor]];
    [btnHome setImage:[UIImage imageNamed:@"personButton.png"] forState:UIControlStateNormal];
    [btnHome setImage:[UIImage imageNamed:@"personButton.png"] forState:UIControlStateHighlighted];
    [btnHome addTarget:self action:@selector(showLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    if (IOS7) {
        [self.navigationItem setRightBarButtonItemInIOS7:[[UIBarButtonItem alloc] initWithCustomView:btnHome]];
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnHome];
    }
    
    //搜索界面
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    headView.backgroundColor = [UIColor clearColor];
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:headView.bounds];
    backImage.backgroundColor = COLOR(197.0, 206.0, 195.0);
    [headView addSubview:backImage];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 25, 25)];
    searchButton.backgroundColor = [UIColor redColor];
    [headView addSubview:searchButton];
    searchText_ = [[UITextField alloc]  initWithFrame:CGRectMake(40, 5, 200, 30)];
    searchText_.borderStyle = UITextBorderStyleNone;
    searchText_.delegate = self;
    [headView addSubview:searchText_];
    
    UIButton *changeButton = [[UIButton alloc] initWithFrame:CGRectMake(275, 5, 37, 30)];
    [changeButton setBackgroundImage:[UIImage imageNamed:@"listButton.png"] forState:UIControlStateNormal];
    [changeButton setBackgroundImage:[UIImage imageNamed:@"listButtonclick.png"] forState:UIControlStateHighlighted];
    [changeButton addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
    changeButton.tag = 100;
    [headView addSubview:changeButton];
    
    mapView_ = [[HomeMapView alloc] initWithFrame:CGRectMake(0, 0, 320, kCurrentWindowHeight-kTopImageHeight)];
    mapView_.delegate = self;
    [self.view addSubview:mapView_];
    
    listView_ = [[HomeListView alloc] initWithFrame:CGRectMake(0, 0, 320, kCurrentWindowHeight-kTopImageHeight)];
    listView_.hidden = YES;
    [self.view addSubview:listView_];
    
    [self.view addSubview:headView];
    
}


- (void)showLeftClick:(UIButton *)button
{
    PersonalCenterViewController *viewCtr = [[PersonalCenterViewController alloc] init];
    //    ParkDetailViewController *viewCtr = [[ParkDetailViewController alloc] init];
    [self.navigationController pushViewController:viewCtr animated:YES];
    
}


- (void)changeClick:(UIButton *)button
{
    switch (button.tag) {
        case 100:
        {
            button.tag = 101;
            
            [UIView beginAnimations:@"animation" context:nil];
            [UIView setAnimationDuration:1.0f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
            mapView_.hidden = YES;
            listView_.hidden = NO;
            [UIView commitAnimations];
           
            [button setBackgroundImage:[UIImage imageNamed:@"mapButton.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"mapButtonclick.png"] forState:UIControlStateHighlighted];
            break;
        }
        case 101:
        {
            button.tag = 100;
            [UIView beginAnimations:@"animation" context:nil];
            [UIView setAnimationDuration:1.0f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
            listView_.hidden = YES;
            mapView_.hidden = NO;
            [UIView commitAnimations];
            [button setBackgroundImage:[UIImage imageNamed:@"listButton.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"listButtonclick.png"] forState:UIControlStateHighlighted];
            break;
        }
        default:
            break;
    }
}

#pragma mark - load data

//定位成功后刷新数据，或者定时刷新数据
- (void)LoadCurrentInfo:(CLLocationCoordinate2D)currentPoint
{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    [tempDic setObject:[NSNumber numberWithDouble:currentPoint.latitude] forKey:@"user_lat"];
    [tempDic setObject:[NSNumber numberWithDouble:currentPoint.longitude] forKey:@"user_lon"];
    [tempDic setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    
    [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getNearCarparkList" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
        NSLog(@"1233");
        NSArray *array = [resultDic objectForKey:@"carparklist"];
        [dataArray_ addObjectsFromArray:array];
        [mapView_ updateAnimationView:dataArray_];
        [listView_ refreshParkingList:dataArray_];
        
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

@end
