//
//  MainViewController.m
//  ManyCode
//
//  Created by lichengfei on 14-7-21.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "MainViewController.h"
#import "UINavigationItem+Items.h"
#import "MapViewController.h"
#import "PersonalCenterViewController.h"
#import "ParkDetailViewController.h"

@interface MainViewController ()
{
   
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
    
    //返回按钮
    UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHome.frame = CGRectMake(0, 0.f, 30, 21.f);
    [btnHome setBackgroundColor:[UIColor clearColor]];
    [btnHome setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnHome setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateHighlighted];
	[btnHome addTarget:self action:@selector(showLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    if (IOS7) {
        [self.navigationItem setRightBarButtonItemInIOS7:[[UIBarButtonItem alloc] initWithCustomView:btnHome]];
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnHome];
    }

}


- (void)showLeftClick:(UIButton *)button
{
//    PersonalCenterViewController *viewCtr = [[PersonalCenterViewController alloc] init];
    ParkDetailViewController *viewCtr = [[ParkDetailViewController alloc] init];
    [self.navigationController pushViewController:viewCtr animated:YES];
    
}

#pragma mark - table delegate


@end
