//
//  ModelViewController.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/25/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "ModelViewController.h"
#import "UINavigationItem+Items.h"

@interface ModelViewController ()

@end

@implementation ModelViewController

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
    if (IOS7) {
        [self setExtendedLayoutIncludesOpaqueBars:NO];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatueHeight, 320, 44)];
    topView.backgroundColor = [UIColor clearColor];
    topView.userInteractionEnabled = YES;
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:topView.bounds];
    backImage.image = [UIImage imageNamed:@"tabbar.png"];
    [topView addSubview:backImage];
    [self.view addSubview:topView];
    
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 150, 20)];
    self.titleLable.backgroundColor = [UIColor clearColor];
    self.titleLable.textColor = [UIColor whiteColor];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    self.titleLable.center = backImage.center;
    [topView addSubview:self.titleLable];
    
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(8, 7.f, 45, 27.f);
    [_leftButton setBackgroundColor:[UIColor clearColor]];
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"返回按钮效果.png"] forState:UIControlStateNormal];
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"返回按钮常态.png"] forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    _leftButton.titleEdgeInsets = UIEdgeInsetsMake(0,5, 0, 0);
    [_leftButton setTitle:@"返回" forState:UIControlStateNormal];
    _leftButton.titleLabel.font = FONT(12);
    [topView addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(283, 7.f, 27, 27.f);
    [_rightButton setBackgroundColor:[UIColor clearColor]];
    [_rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.titleLabel.font = FONT(12);
    _rightButton.hidden = YES;
    [topView addSubview:_rightButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 返回按钮
- (void)backClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightClick:(UIButton *)button
{
    
}

@end
