//
//  ParkDetailViewController.m
//  ManyCode
//
//  Created by lichengfei on 14-7-22.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "ParkDetailViewController.h"
#import "UINavigationItem+Items.h"

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
    self.title = @"抢车位";
    
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
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
    
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 240, 30)];
    nameLable.backgroundColor = [UIColor clearColor];
    nameLable.text = @"绘制大厦停车场";
    nameLable.font = FONT(18);
    [titleView addSubview:nameLable];
    
    UILabel *disLable = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 50, 30)];
    disLable.backgroundColor = [UIColor clearColor];
    disLable.text = @"231米";
    disLable.font = FONT(13);
    [titleView addSubview:disLable];
    
    UILabel *detailLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 35, 270, 30)];
    detailLable.backgroundColor = [UIColor clearColor];
    detailLable.text = @"宁栓路28号";
    detailLable.font = FONT(13);
    [titleView addSubview:detailLable];
    
    return titleView;
}


- (UIView *)creatMiddleView
{
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(10, 150, 300, 100)];
    middleView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImage = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 10, 85, 75)];
    iconImage.backgroundColor = [UIColor redColor];
    [middleView addSubview:iconImage];
    
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 180, 30)];
    nameLable.backgroundColor = [UIColor clearColor];
    nameLable.text = @"雨花台区";
    nameLable.font = FONT(15);
    [middleView addSubview:nameLable];
    
    UILabel *detailLable = [[UILabel alloc] initWithFrame:CGRectMake(110, 45, 180, 30)];
    detailLable.backgroundColor = [UIColor clearColor];
    detailLable.text = @"宁栓路28号";
    detailLable.font = FONT(15);
    [middleView addSubview:detailLable];
    return middleView;
}
@end
