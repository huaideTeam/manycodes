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

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *mainTableView_;
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
    
//    mainTableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, 320, kCurrentWindowHeight - 80)];
//    mainTableView_.delegate = self;
//    mainTableView_.dataSource = self;
//    mainTableView_.backgroundColor = [UIColor clearColor];
//    mainTableView_.backgroundView = nil;
//    [mainTableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [self.view addSubview:mainTableView_];

}


- (void)showLeftClick:(UIButton *)button
{
    PersonalCenterViewController *viewCtr = [[PersonalCenterViewController alloc] init];
    [self.navigationController pushViewController:viewCtr animated:YES];
    
}

#pragma mark - table delegate

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 3;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *homeId = @"cellid";
//    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:homeId];
//    if (cell == nil) {
//        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeId];
//    }
//    
//    [cell.detailButton addTarget:self action:@selector(detailClick:) forControlEvents:UIControlEventTouchUpInside];
//    cell.detailButton.tag = indexPath.row;
//    cell.titleLabel.text = @"1233";
//    cell.distanceLabel.text = @"233";
//    cell.parkLabel.text = @"ddgf";
//    cell.backgroundColor = [UIColor clearColor];
//    
//    return cell;
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    MainDetailViewController *viewCtr = [[MainDetailViewController alloc] init];
//    [self.navigationController pushViewController:viewCtr animated:YES];
//}
//
//#pragma mark - detail click
//
//- (void)detailClick:(UIButton *)button
//{
//    MapViewController *viewCtr = [[MapViewController alloc] init];
//    UINavigationController *nav = self.navigationController;
//    [nav pushViewController:viewCtr animated:YES];
//}
@end
