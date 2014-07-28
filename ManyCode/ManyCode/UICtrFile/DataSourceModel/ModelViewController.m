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
    self.view.backgroundColor = COLOR(233, 232, 230);
    
    UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHome.frame = CGRectMake(0, 0.f, 50, 30.f);
    [btnHome setBackgroundColor:[UIColor clearColor]];
    [btnHome setBackgroundImage:[UIImage imageNamed:@"返回按钮常态.png"] forState:UIControlStateNormal];
    [btnHome setBackgroundImage:[UIImage imageNamed:@"返回按钮效果.png"] forState:UIControlStateHighlighted];
    [btnHome addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnHome setTitle:@"返回" forState:UIControlStateNormal];
    btnHome.titleLabel.font = FONT(12);
    if (IOS7) {
        [self.navigationItem setLeftBarButtonItemInIOS7:[[UIBarButtonItem alloc] initWithCustomView:btnHome]];
    }
    else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnHome];
    }
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

@end
