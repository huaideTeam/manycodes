//
//  MyPurseViewController.m
//  ManyCode
//
//  Created by lichengfei on 14-7-26.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "MyPurseViewController.h"
#import "PCPieChart.h"

@interface MyPurseViewController ()
{
    UIScrollView *mainScrollView_;
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
    UIView *headView = [self headerViewForCosumptionList];
    mainScrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, kCurrentWindowHeight - kTopImageHeight)];
    [self.view addSubview:mainScrollView_];
    
    [mainScrollView_ addSubview:headView];
    
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(0, 110, 320, 150)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:150];
    [pieChart setSameColorLabel:NO];
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
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:headView.bounds];
    backImage.image = [UIImage  imageNamed:@""];
    [headView addSubview:backImage];
    
    UIImageView *circleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19.f, 12, 74.f, 74.f)];
    circleImageView.layer.cornerRadius = 37.f;
    circleImageView.layer.borderWidth = 1.f;
    circleImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    circleImageView.clipsToBounds = YES;
    [circleImageView setBackgroundColor:[UIColor clearColor]];
    [headView addSubview:circleImageView];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(25,20,60, 60)];
    titleImage.center = circleImageView.center;
    titleImage.layer.cornerRadius = 30.f;
    titleImage.clipsToBounds = YES;
    [titleImage setBackgroundColor:[UIColor greenColor]];
    titleImage.image = [UIImage  imageNamed:@""];
    [headView addSubview:titleImage];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(circleImageView.frame) + 10.f, CGRectGetMidY(circleImageView.frame) - 20.f, 150, 20)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kAccountMobile];
    [headView addSubview:nameLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame), CGRectGetWidth(nameLabel.frame), CGRectGetHeight(nameLabel.frame))];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.text = @"当前余额：34元";
    [headView addSubview:priceLabel];
    return headView;
}


@end
