//
//  StartParkViewController.m
//  ManyCode
//
//  Created by lichengfei on 14-7-23.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "StartParkViewController.h"
#import "SBTickerView.h"
#import "SBTickView.h"
#import "PCPieChart.h"

#define PIE_HEIGHT 200

@interface StartParkViewController ()
{
    NSInteger hourNumber1_;
    NSInteger hourNumber2_;
    NSInteger hourNumber3_;
    NSInteger hourNumber4_;
    NSDate *currentDate_;
    UIScrollView *mainScrollView_;
    UIButton *openDoorBtn_;
    
}

@property (nonatomic, strong)  SBTickerView *clockTickerViewHour1;
@property (nonatomic, strong)  SBTickerView *clockTickerViewHour2;
@property (nonatomic, strong)  SBTickerView *clockTickerViewMinute1;
@property (nonatomic, strong)  SBTickerView *clockTickerViewMinute2;
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,strong) NSMutableArray *colorArray;

@end

@implementation StartParkViewController

#pragma mark - system Function

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


#pragma mark - use Function

- (void)loadFunctionView
{
    
    currentDate_ = [NSDate date];
    self.view.backgroundColor = [UIColor whiteColor];
    
     self.title = @"对账单";
    
    if (IOS7) {
        [self setExtendedLayoutIncludesOpaqueBars:NO];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    hourNumber1_ = 0;
    hourNumber2_ = 0;
    hourNumber3_ = 0;
    hourNumber4_ = 0;
    
    mainScrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, kCurrentWindowHeight - kTopImageHeight)];
    mainScrollView_.contentSize = CGSizeMake(320, 568);
    [self.view addSubview:mainScrollView_];
    
    
    UIView *hourView = [[UIView alloc] initWithFrame:CGRectMake(20, 30, 140, 100)];
    hourView.backgroundColor = COLOR(84, 83, 82);
    hourView.layer.masksToBounds = YES;
    hourView.layer.cornerRadius = 3.0;
    
    _clockTickerViewHour1 = [[SBTickerView alloc] initWithFrame:CGRectMake(5, 5, 60, 90)];
    [_clockTickerViewHour1 setFrontView:[SBTickView tickViewWithTitle:@"0" fontSize:45.]];
    [hourView addSubview:_clockTickerViewHour1];
    
    _clockTickerViewHour2 = [[SBTickerView alloc] initWithFrame:CGRectMake(73, 5, 60, 90)];
    [_clockTickerViewHour2 setFrontView:[SBTickView tickViewWithTitle:@"0" fontSize:45.]];
    [hourView addSubview:_clockTickerViewHour2];
    
    [mainScrollView_ addSubview:hourView];
    
    UIView *mintinueView = [[UIView alloc] initWithFrame:CGRectMake(163, 30, 140, 100)];
    mintinueView.backgroundColor = COLOR(84, 83, 82);
    mintinueView.layer.masksToBounds = YES;
    mintinueView.layer.cornerRadius = 3.0;
    
    _clockTickerViewMinute1 = [[SBTickerView alloc] initWithFrame:CGRectMake(5, 5, 60, 90)];
    [_clockTickerViewMinute1 setFrontView:[SBTickView tickViewWithTitle:@"0" fontSize:45.]];
    [mintinueView addSubview:_clockTickerViewMinute1];
    
    _clockTickerViewMinute2 = [[SBTickerView alloc] initWithFrame:CGRectMake(73, 5, 60, 90)];
    [_clockTickerViewMinute2 setFrontView:[SBTickView tickViewWithTitle:@"0" fontSize:45.]];
    [mintinueView addSubview:_clockTickerViewMinute2];
    
    [mainScrollView_ addSubview:mintinueView];
    
    [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(refreshTimeView) userInfo:nil repeats:YES];
    
    
    UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 165, 320, 20)];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text = @"账户余额";
    titleLable.font = FONT(12);
    titleLable.textAlignment = NSTextAlignmentCenter;
    [mainScrollView_ addSubview:titleLable];
    
    
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(0, 200, 320, 150)];
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
    
    openDoorBtn_ = [[UIButton alloc] initWithFrame:CGRectMake(15, 400, 290, 38)];
    [openDoorBtn_ addTarget:self action:@selector(openClick:) forControlEvents:UIControlEventTouchUpInside];
    [openDoorBtn_ setTitle:@"点击开闸" forState:UIControlStateNormal];
    [openDoorBtn_ setBackgroundImage:[UIImage imageNamed:@"点击开闸未进入常态.png"] forState:UIControlStateNormal];
    [mainScrollView_ addSubview:openDoorBtn_];
    
}

#pragma mark - 点击开闸
- (void)openClick:(UIButton *)button
{
    
}

#pragma mark - 获取分钟和小时数

- (void)refreshTimeView
{
    NSDate *date = [NSDate date];
    
    long long timeNum =  [date timeIntervalSinceDate:currentDate_];
    
    NSInteger minuteNum =(NSInteger)(timeNum - timeNum%60)/60;
    
    NSInteger hourNum = (minuteNum - minuteNum%60)/60;
    if ((hourNum%10)!=hourNumber2_) { //小时个位数
        hourNumber2_ = (hourNum%10);
        [_clockTickerViewHour2 setBackView:[SBTickView tickViewWithTitle:[NSString stringWithFormat:@"%d",hourNumber2_]  fontSize:45.]];
        [_clockTickerViewHour2 tick:SBTickerViewTickDirectionDown animated:YES completion:nil];
    }
    
    if (((minuteNum - minuteNum%10)/10)!=hourNumber3_) {
        hourNumber3_ = ((minuteNum - minuteNum%10)/10);
        [_clockTickerViewMinute1 setBackView:[SBTickView tickViewWithTitle:[NSString stringWithFormat:@"%d",hourNumber3_]  fontSize:45.]];
        [_clockTickerViewMinute1 tick:SBTickerViewTickDirectionDown animated:YES completion:nil];
    }
    
    if ((minuteNum%10)!=hourNumber4_) { //小时个位数
        hourNumber4_ = (minuteNum%10);
        [_clockTickerViewMinute2 setBackView:[SBTickView tickViewWithTitle:[NSString stringWithFormat:@"%d",hourNumber4_]  fontSize:45.]];
        [_clockTickerViewMinute2 tick:SBTickerViewTickDirectionDown animated:YES completion:nil];
    }
    
    if (((hourNum - hourNum%10)/10)!=hourNumber1_) {
        hourNumber1_ = ((hourNum - hourNum%10)/10);
        [_clockTickerViewHour1 setBackView:[SBTickView tickViewWithTitle:[NSString stringWithFormat:@"%d",hourNumber1_]  fontSize:45.]];
        [_clockTickerViewHour1 tick:SBTickerViewTickDirectionDown animated:YES completion:nil];
    }

}
@end
