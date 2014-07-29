//
//  MyPurseViewController.m
//  ManyCode
//
//  Created by lichengfei on 14-7-26.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "MyPurseViewController.h"
#import "PCPieChart.h"
#import "PayMoneyViewController.h"
#import "UINavigationItem+Items.h"
#import "UIImageView+WebCache.h"

@interface MyPurseViewController ()
{
    UIScrollView *mainScrollView_;
    UIButton *photoBtn_;
}

@end

@implementation MyPurseViewController

#pragma mark - systemFunction

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
    self.view.backgroundColor  = COLOR(229, 228, 225);
    self.title = @"我的钱包";
    
    if (IOS7) {
        [self setExtendedLayoutIncludesOpaqueBars:NO];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    //返回按钮
    UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHome.frame = CGRectMake(0, 0.f, 50, 28.f);
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

    
    UIView *headView = [self headerViewForCosumptionList];
    mainScrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, kCurrentWindowHeight - kTopImageHeight)];
    [self.view addSubview:mainScrollView_];
    
    [mainScrollView_ addSubview:headView];
    
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(0, 110, 320, 150)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:150];
    [pieChart setSameColorLabel:NO];
    [pieChart setShowArrow:NO];
    [mainScrollView_ addSubview:pieChart];
    
    NSMutableArray *components = [NSMutableArray array];
    for (int i=0; i< 3; i++)
    {
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:@"账户余额" value:25.0];
        [components addObject:component];
        
        if (i==0)
        {
            [component setColour:[UIColor whiteColor]];
        }
        else if (i==1)
        {
            [component setColour:COLOR(64, 163, 104)];
        }
        else if (i==2)
        {
            [component setColour:COLOR(226, 90, 60)];
        }
    }
    [pieChart setComponents:components];
    
    UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 280, 320, 20)];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text = @"账户余额    34元";
    titleLable.font = FONT(17);
    titleLable.textColor = COLOR(120, 105, 90);
    titleLable.textAlignment = NSTextAlignmentCenter;
    [mainScrollView_ addSubview:titleLable];
    
    [self loadUserInfo];
    
}


#pragma mark - 返回按钮

- (void)backClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取数据

- (void)loadUserInfo
{
    [[Hud defaultInstance] loading:self.view];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountid] forKey:@"userid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession] forKey:@"sessionid"];
    
    [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getUserBalance" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
        [[Hud defaultInstance] hide:self.view];
        
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

#pragma mark - 列表头
- (UIView *)headerViewForCosumptionList {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 90)];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    backImage.image = [UIImage  imageNamed:@"payMoneyTitleImage.png"];
    [headView addSubview:backImage];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(25,10,75, 75)];
    titleImage.image = [UIImage  imageNamed:@"示意头像 描边.png"];
    titleImage.userInteractionEnabled = YES;
    [headView addSubview:titleImage];
    
   UIImageView * photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    photoImage.backgroundColor = [UIColor clearColor];
    [photoImage setImageWithURL:HEADIMG placeholderImage:[UIImage imageNamed:@"示意头像 图片.png"]];
    [titleImage addSubview:photoImage];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 25, 150, 20)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = FONT(18);
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = ACCOUNTNAME;
    [headView addSubview:nameLabel];
    
    UIButton  *priceBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 50, 150, 20)];
    priceBtn.backgroundColor = [UIColor clearColor];
    [priceBtn setTitle:BALANCE forState:UIControlStateNormal];
    priceBtn.titleLabel.font = FONT(18);
    [priceBtn addTarget:self action:@selector(chargeMoneyClick:) forControlEvents:UIControlEventTouchUpInside];
    priceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [headView addSubview:priceBtn];
    
    return headView;
}


- (void)chargeMoneyClick:(UIButton *)button
{
    PayMoneyViewController *viewCtr = [[PayMoneyViewController alloc] init];
    [self.navigationController pushViewController:viewCtr animated:YES];
}

@end
