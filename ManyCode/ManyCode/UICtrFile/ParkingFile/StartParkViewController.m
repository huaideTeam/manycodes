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
#import "PayMoneyViewController.h"

#define PIE_HEIGHT 200

@interface StartParkViewController ()<UIAlertViewDelegate>
{
    NSInteger hourNumber1_;
    NSInteger hourNumber2_;
    NSInteger hourNumber3_;
    NSInteger hourNumber4_;
    NSDate *currentDate_;
    UIScrollView *mainScrollView_;
    UIButton *openDoorBtn_;
    NSMutableArray *currentWifiArray_;
    NSTimer * wifiTime_;
    NSTimer *hourTime_;
    NSDictionary *deviceDic_;
    
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

- (void)viewWillAppear:(BOOL)animated
{
    hourTime_ =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTimeView) userInfo:nil repeats:YES];
    
    wifiTime_ = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(wifiInfo) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [hourTime_ invalidate];
    [wifiTime_ invalidate];
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
    if (self.isComeIn) {
        [self getUserBalanceInfo];
        openDoorBtn_.tag = 100;
    }else
    {
        [self loadCalculateChargeInfo];
        openDoorBtn_.tag = 101;
    }
    
}

#pragma mark - 下载数据 

//获取账余额
- (void)getUserBalanceInfo
{
    [[Hud defaultInstance] loading:self.view];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountid] forKey:@"userid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession] forKey:@"sessionid"];
    
    [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getUserBalance" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
        [[Hud defaultInstance] hide:self.view];
        if ([[resultDic objectForKey:@"balance"] floatValue]>0) {
            
        }else
        {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"你的账户余额不足" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
            alert.tag = 1000;
            [alert show];
        }
        
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code == 217) {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"你的账户余额不足" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
            alert.tag = 1000;
            [alert show];
        }
    }];

}

- (void)loadCalculateChargeInfo
{
    [[Hud defaultInstance] loading:self.view];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountid] forKey:@"userid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession] forKey:@"sessionid"];
    
    [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getCalculateCharge" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
        [[Hud defaultInstance] hide:self.view];
        
        
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

#pragma mark - 点击开闸
- (void)openClick:(UIButton *)button
{
    if (button.tag ==  100) {
        [self comeInPark:@"0"];
    }else
    {
         [self comeInPark:@"1"];
    }

}


//进入停车场
- (void)comeInPark:(NSString *)passkind
{
    [[Hud defaultInstance] loading:self.view];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    [tempDic setObject:[_parkDic objectForKey:@"carparkid"] forKey:@"carparkid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountid] forKey:@"userid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession] forKey:@"sessionid"];
    if ([[deviceDic_ objectForKey:@"devid"] length]>0 && [[deviceDic_ objectForKey:@"deviceid"] length]>0) {
        [tempDic setObject:[deviceDic_ objectForKey:@"devid"] forKey:@"devid"];
        [tempDic setObject:[deviceDic_ objectForKey:@"deviceid"] forKey:@"deviceid"];
    }else
    {
        [[Hud defaultInstance] showMessage:@"当前设备不存在"];
    }
    [tempDic setObject:passkind forKey:@"passkind"];
    
    [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"openDevRoadNum" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
        [self getDeviceStatue:resultDic[@"sourceid"] devId:[deviceDic_ objectForKey:@"devid"]];
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


//获取设备的开启状态
- (void)getDeviceStatue:(NSString *)sourceid  devId:(NSString *)deviceId
{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    [tempDic setObject:[_parkDic objectForKey:@"carparkid"] forKey:@"carparkid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountid] forKey:@"userid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession] forKey:@"sessionid"];
    [tempDic setObject:sourceid forKey:@"sourceid"];
    [tempDic setObject:deviceId forKey:@"devid"];
    
    [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getUserDevRoadStatus" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
        [[Hud defaultInstance] hide:self.view];
        
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

#pragma mark - 获取设备信息
// 获取停车场的wifi列表
- (void)wifiInfo
{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    [tempDic setObject:[_parkDic objectForKey:@"carparkid"] forKey:@"carparkid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountid] forKey:@"userid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession] forKey:@"sessionid"];
    [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getCarparkWiFi" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
        if (!currentWifiArray_) {
            if ([resultDic[@"wifiinfo"] count]>0) {
                currentWifiArray_ = [[NSMutableArray alloc] initWithArray:resultDic[@"wifiinfo"]];
            }
        }else
        {
            NSArray * array = resultDic[@"wifiinfo"];
            for (int k = 0; k<currentWifiArray_.count; k++) {
                NSDictionary *dic = [currentWifiArray_ objectAtIndex:k];
                for (int j = 0; j < array.count; j++) {
                    NSDictionary *tempDic = [array objectAtIndex:k];
                    if([dic[@"wifibssid"] isEqualToString:tempDic[@"wifibssid"]])
                    {
                        [self getDeviceInfo:array];
                        return ;
                    }
                }
            }
        }
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

//获取当前设备信息
- (void)getDeviceInfo:(NSArray *)wifiArray
{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    [tempDic setObject:[_parkDic objectForKey:@"carparkid"] forKey:@"carparkid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountid] forKey:@"userid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession] forKey:@"sessionid"];
    [tempDic setObject:wifiArray forKey:@"wifiinfo"];
    [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getDevRoadNum" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
        deviceDic_ = resultDic;
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
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
        [_clockTickerViewHour2 setBackView:[SBTickView tickViewWithTitle:[NSString stringWithFormat:@"%ld",(long)hourNumber2_]  fontSize:45.]];
        [_clockTickerViewHour2 tick:SBTickerViewTickDirectionDown animated:YES completion:nil];
    }
    
    if (((minuteNum - minuteNum%10)/10)!=hourNumber3_) {
        hourNumber3_ = ((minuteNum - minuteNum%10)/10);
        [_clockTickerViewMinute1 setBackView:[SBTickView tickViewWithTitle:[NSString stringWithFormat:@"%ld",(long)hourNumber3_]  fontSize:45.]];
        [_clockTickerViewMinute1 tick:SBTickerViewTickDirectionDown animated:YES completion:nil];
    }
    
    if ((minuteNum%10)!=hourNumber4_) { //小时个位数
        hourNumber4_ = (minuteNum%10);
        [_clockTickerViewMinute2 setBackView:[SBTickView tickViewWithTitle:[NSString stringWithFormat:@"%ld",(long)hourNumber4_]  fontSize:45.]];
        [_clockTickerViewMinute2 tick:SBTickerViewTickDirectionDown animated:YES completion:nil];
    }
    
    if (((hourNum - hourNum%10)/10)!=hourNumber1_) {
        hourNumber1_ = ((hourNum - hourNum%10)/10);
        [_clockTickerViewHour1 setBackView:[SBTickView tickViewWithTitle:[NSString stringWithFormat:@"%ld",(long)hourNumber1_]  fontSize:45.]];
        [_clockTickerViewHour1 tick:SBTickerViewTickDirectionDown animated:YES completion:nil];
    }

}

#pragma mark - alert Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            
            break;
        }
        case 1:
        {
            PayMoneyViewController *viewCtr= [[PayMoneyViewController alloc] init];
            [self.navigationController pushViewController:viewCtr animated:YES];
            break;
        }
            
        default:
            break;
    }
}
@end
