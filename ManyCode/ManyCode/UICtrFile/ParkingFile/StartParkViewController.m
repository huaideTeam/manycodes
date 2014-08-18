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
#import "Common.h"
#import "UINavigationItem+Items.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "JSONKit.h"
#import <AVFoundation/AVFoundation.h>

static NSString * const kIdentifier = @"SomeIdentifier";

#define PIE_HEIGHT 200

@interface StartParkViewController ()<UIAlertViewDelegate,CLLocationManagerDelegate, CBPeripheralManagerDelegate>
{
    NSInteger hourNumber1_;
    NSInteger hourNumber2_;
    NSInteger hourNumber3_;
    NSInteger hourNumber4_;
    NSDate *currentDate_;
    UIScrollView *mainScrollView_;
    UIButton *openDoorBtn_;
    NSMutableArray *currentWifiArray_;
    NSTimer *hourTime_;
    NSDictionary *deviceDic_;
    UIView *centerView_;
    NSDictionary *accountInfoDic_; //账户信息
    NSDictionary *currentInfoDic_;
    long long oldTimeNum_;
    UILabel *desLabel_;
}

@property (nonatomic, strong)  SBTickerView *clockTickerViewHour1;
@property (nonatomic, strong)  SBTickerView *clockTickerViewHour2;
@property (nonatomic, strong)  SBTickerView *clockTickerViewMinute1;
@property (nonatomic, strong)  SBTickerView *clockTickerViewMinute2;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) NSMutableArray *currentBeacons;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.isComeIn) {
        
    }else
    {
         hourTime_ =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTimeView) userInfo:nil repeats:YES];
    }
    
    //获取停车场的uuid
    [self getParkUuid];
}

- (void)viewWillDisappear:(BOOL)animated{
    [hourTime_ invalidate];
}


#pragma mark - use Function

- (void)loadFunctionView
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    currentDate_ = [NSDate date];
    self.view.backgroundColor = COLOR(229, 228, 225);
    
     self.title = @"对账单";
    oldTimeNum_ = 0;
    
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
    
    
    desLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(15, 380, 290, 20)];
    desLabel_.backgroundColor = [UIColor clearColor];
    desLabel_.text = @"未到达停车场范围内，不能停车";
    desLabel_.textColor = COLOR(125, 119, 100);
    [mainScrollView_ addSubview:desLabel_];
    
    openDoorBtn_ = [[UIButton alloc] initWithFrame:CGRectMake(15, 400, 290, 38)];
    [openDoorBtn_ addTarget:self action:@selector(openClick:) forControlEvents:UIControlEventTouchUpInside];
    [openDoorBtn_ setTitle:@"点击开闸" forState:UIControlStateNormal];
    [mainScrollView_ addSubview:openDoorBtn_];
    if (self.isComeIn) {
        openDoorBtn_.tag = 100;
        [openDoorBtn_ setBackgroundImage:[UIImage imageNamed:@"点击开闸未进入常态.png"] forState:UIControlStateNormal];
    }else
    {
        openDoorBtn_.tag = 101;
        desLabel_.hidden = YES;
        [openDoorBtn_ setBackgroundImage:[UIImage imageNamed:@"点击开闸进入后.png"] forState:UIControlStateNormal];
        [openDoorBtn_ setBackgroundImage:[UIImage imageNamed:@"点击开闸点击效果.png"] forState:UIControlStateHighlighted];

    }
     [self getUserBalanceInfo];
    
}

#pragma mark - 添加饼图

- (void)addPieView:(CGFloat)surplusMoney  Consumption:(CGFloat)consumMoney
{
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(0, 200, 320, 150)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:150];
    [pieChart setSameColorLabel:NO];
    [pieChart setShowArrow:NO];
    [mainScrollView_ addSubview:pieChart];
    
    if (self.isComeIn) {//进闸
        NSMutableArray *components = [NSMutableArray array];
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:@"账户余额" value:surplusMoney];
        [components addObject:component];
        [component setColour:COLOR(64, 163, 104)];
        [pieChart setComponents:components];
        
    }else
    {
        NSMutableArray *components = [NSMutableArray array];
        
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:@"账户余额" value:surplusMoney];
        [component setColour:COLOR(64, 163, 104)];
        [components addObject:component];
        
        
        PCPieComponent *component1 = [PCPieComponent pieComponentWithTitle:@"预计消费" value:consumMoney];
        [component1  setColour:COLOR(226, 90, 60)];
        [components addObject:component1];
        
        [pieChart setComponents:components];
    }
    
    centerView_ = [[UIView alloc] initWithFrame:CGRectMake(120, 35, 80, 80)];
    centerView_.layer.masksToBounds = YES;
    centerView_.layer.cornerRadius = 40.0;
    centerView_.backgroundColor = [UIColor whiteColor];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 80, 20)];
    lable.text = [NSString stringWithFormat:@"%@元",[[NSUserDefaults standardUserDefaults] objectForKey:kAccountBalance]];
    lable.textColor = COLOR(219, 44, 0);
    lable.textAlignment = NSTextAlignmentCenter;
    [centerView_ addSubview:lable];
    
    [pieChart addSubview:centerView_];

}

#pragma mark - 返回按钮

- (void)backClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
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
        accountInfoDic_ = resultDic;
        if ([[resultDic objectForKey:@"balance"] floatValue]>0) {
            
        }else
        {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"你的账户余额不足" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
            alert.tag = 1000;
            [alert show];
        }
        if (!self.isComeIn) {//如果是已经停车的
            [self loadCalculateChargeInfo];
        }else
        {
            [self addPieView:[accountInfoDic_[@"balance"] floatValue] Consumption:0.0];
            [[Hud defaultInstance] hide:self.view];
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
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountid] forKey:@"userid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession] forKey:@"sessionid"];
    
    [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getCalculateCharge" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
        currentInfoDic_ = resultDic;
        [self getOldTimeInfo:resultDic];
        [[Hud defaultInstance] hide:self.view];
        
        if ([accountInfoDic_[@"balance"] floatValue] < [resultDic[@"money"] floatValue]) {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"你的账户余额不足" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
            alert.tag = 1000;
            [alert show];
        }
        [self addPieView:[accountInfoDic_[@"balance"] floatValue] Consumption:[resultDic[@"money"] floatValue]];
        
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)getOldTimeInfo:(NSDictionary *)dic
{
    oldTimeNum_ =  [[dic objectForKey:@"querytime"] longLongValue] - [[dic objectForKey:@"intime"] longLongValue];
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
        [[Hud defaultInstance] showMessage:@"当前没有搜索到设备"];
        return;
    }
    [tempDic setObject:passkind forKey:@"passkind"];
    
    NSMutableDictionary *modleDic = [NSMutableDictionary dictionaryWithDictionary:deviceDic_];
    [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"openDevRoadNum" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
        [self getDeviceStatue:resultDic[@"sourceid"] devId:[modleDic objectForKey:@"devid"]];
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
    
    [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getOpenDevRoadStatus" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
        if (self.isComeIn) {
            [[Hud defaultInstance] showMessage:@"开闸成功，欢迎光临" withHud:YES];
        }else
        {
            NSString *tempString = [NSString stringWithFormat:@"开闸成功，你本次停车共花费%@元，欢迎下次光临",resultDic[@"money"]];
            [[Hud defaultInstance] showMessage:tempString withHud:YES];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

#pragma mark - 获取设备信息
// 获取停车场的UUID

- (void)getParkUuid
{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    [tempDic setObject:[_parkDic objectForKey:@"carparkid"] forKey:@"carparkid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountid] forKey:@"userid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession] forKey:@"sessionid"];
    [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getCarparkBluetooth" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
        currentWifiArray_ = resultDic[@"bluetoothinfo"];
        if (currentWifiArray_.count>0) {
            NSDictionary *dic = [currentWifiArray_ objectAtIndex:0];
            if ([dic[@"bluetoothuuid"] length]>0) {
                NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:dic[@"bluetoothuuid"]];
                self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:kIdentifier];
                [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
            }
        }
        
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

//获取当前设备信息
- (void)getDeviceInfo:(NSArray *)wifiArray
{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:wifiArray
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    [tempDic setObject:[_parkDic objectForKey:@"carparkid"] forKey:@"carparkid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountid] forKey:@"userid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession] forKey:@"sessionid"];
    [tempDic setObject:string forKey:@"bluetoothinfo"];
    [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getDevRoadNumBluetooth" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
        deviceDic_ = resultDic;
        
        //不存在文件重新下载
         if (![[NSFileManager defaultManager]  fileExistsAtPath:[self imageDownloadDestinationPath:resultDic[@"voice"]]])
         {
              [self downLoadWavFile:resultDic[@"voice"]];
         }
       
        if ([deviceDic_[@"openflg"] integerValue]) {
            openDoorBtn_.enabled = YES;
            desLabel_.hidden = YES;
            
            [openDoorBtn_ setBackgroundImage:[UIImage imageNamed:@"点击开闸进入后.png"] forState:UIControlStateNormal];
            [openDoorBtn_ setBackgroundImage:[UIImage imageNamed:@"点击开闸点击效果.png"] forState:UIControlStateHighlighted];
            //播放语音
            SystemSoundID soundID = [self loadId:[self fileNameFromPath:deviceDic_[@"voice"]]];
            AudioServicesPlaySystemSound(soundID);
        }else
        {
            [openDoorBtn_ setBackgroundImage:[UIImage imageNamed:@"点击开闸未进入常态.png"] forState:UIControlStateNormal];
            desLabel_.hidden = NO;
            openDoorBtn_.enabled = NO;
        }
        
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 下载音频文件

- (void)downLoadWavFile:(NSString *)filePath
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:filePath]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    NSString *path = [self imageDownloadDestinationPath:filePath];
    op.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
    }];
    [[NetworkCenter instanceManager].httpClient.operationQueue addOperation:op];
}


- (NSString *)imageDownloadDestinationPath:(NSString *)strUrl
{
    [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *stringSep = [NSMutableString stringWithString:@"/"];
    NSArray *arrayUrlInfo = [strUrl componentsSeparatedByString:stringSep];
    NSMutableString *tempFileName = [NSMutableString stringWithFormat:@"%@", [arrayUrlInfo lastObject]];
    NSString *thePath = GET_FILE_URL(([NSString stringWithFormat:@"%@",tempFileName]));
    return thePath;
}


- (NSString *)fileNameFromPath:(NSString *)stringPath
{
    NSMutableString *stringSep = [NSMutableString stringWithString:@"/"];
    NSArray *arrayUrlInfo = [stringPath componentsSeparatedByString:stringSep];
    NSMutableString *tempFileName = [NSMutableString stringWithFormat:@"%@", [arrayUrlInfo lastObject]];
    return tempFileName;
}

- (SystemSoundID)loadId:(NSString *)filename
{
    SystemSoundID ID;
    NSURL *url = [NSURL fileURLWithPath:GET_FILE_URL(filename)];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &ID);
    return ID;
}

#pragma mark - 获取分钟和小时数


- (void)refreshTimeView
{
    NSDate *date = [NSDate date];
    
    long long timeNum =  [date timeIntervalSinceDate:currentDate_]+oldTimeNum_;
    
    NSInteger secondsNum =(NSInteger)(timeNum - timeNum%60)/60; //多少分钟
    
    NSInteger minuteNum = (NSInteger)(secondsNum%60); //去掉小时
    
    NSInteger hourNum = (secondsNum - secondsNum%60)/60;
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

#pragma mark - Beacon advertising delegate methods
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheralManager error:(NSError *)error
{
    if (error) {
        NSLog(@"Couldn't turn on advertising: %@", error);
        return;
    }
    
    if (peripheralManager.isAdvertising) {
        NSLog(@"Turned on advertising.");
    }
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheralManager
{
    if (peripheralManager.state != 5) {
        NSLog(@"Peripheral manager is off.");
        return;
    }
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    if ([beacons count] == 0) {
        NSLog(@"No beacons found nearby.");
    } else {
        NSLog(@"Found beacons!");
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:12];
    
    for (int k = 0 ; k < currentWifiArray_.count; k++) {
        NSDictionary *dic = [currentWifiArray_ objectAtIndex:k];
        for (int index = 0; index<beacons.count; index ++) {
            CLBeacon *beacon = [beacons objectAtIndex:index];
            NSLog(@"++++++%d",beacon.rssi);
             NSLog(@"------%f",beacon.accuracy);
            
            if ([[beacon.minor stringValue] isEqualToString:dic[@"bluetoothmajor"]] &&(beacon.accuracy < [dic[@"bluetoothdistance"] floatValue] || abs(beacon.rssi) < [dic[@"bluetoothrssi"] floatValue])) {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:12];
                [dic setObject:[beacon.proximityUUID UUIDString] forKey:@"bluetoothuuid"];
                [dic setObject:beacon.major forKey:@"bluetoothmajor"];
                [dic setObject:beacon.minor forKey:@"bluetoothminor"];
                [dic setObject:[NSNumber numberWithFloat:beacon.accuracy] forKey:@"bluetoothdistance"];
                [dic setObject:[NSNumber numberWithInteger:beacon.rssi] forKey:@"bluetoothrssi"];
                [array addObject:dic];
            }
        }
    }
    
    if (array.count == 0) {
        self.currentBeacons = [NSMutableArray arrayWithArray:array];
        deviceDic_ = nil;
        return;
    }
    
    if (self.currentBeacons.count != array.count) {
         self.currentBeacons = [NSMutableArray arrayWithArray:array];
        [self getDeviceInfo:array];
        return;
    }
    
    for (int k = 0; k <array.count; k++) {
        NSDictionary *dic = [array objectAtIndex:k];
        for (int j = 0; j <self.currentBeacons.count; j++) {
            NSDictionary *tempDic = [array objectAtIndex:k];
            if (![[dic[@"bluetoothmajor"] stringValue] isEqualToString:[tempDic[@"bluetoothmajor"] stringValue]]) {
                 self.currentBeacons = [NSMutableArray arrayWithArray:array];
                [self getDeviceInfo:array];
                return;

            }
        }
    }
    
}

@end
