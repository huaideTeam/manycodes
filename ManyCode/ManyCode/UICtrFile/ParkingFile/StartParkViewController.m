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
#import "PieChartView.h"

#define PIE_HEIGHT 280

@interface StartParkViewController ()<PieChartDelegate>
{
    NSString *_currentClock;
    NSMutableArray *_clockTickers;
}

@property (nonatomic, strong)  SBTickerView *clockTickerViewHour1;
@property (nonatomic, strong)  SBTickerView *clockTickerViewHour2;
@property (nonatomic, strong)  SBTickerView *clockTickerViewMinute1;
@property (nonatomic, strong)  SBTickerView *clockTickerViewMinute2;
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,strong) NSMutableArray *colorArray;
@property (nonatomic,strong) NSMutableArray *valueArray2;
@property (nonatomic,strong) NSMutableArray *colorArray2;
@property (nonatomic,strong) PieChartView *pieChartView;
@property (nonatomic,strong) UIView *pieContainer;
@property (nonatomic)BOOL inOut;
@property (nonatomic,strong) UILabel *selLabel;

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

- (void)viewDidAppear:(BOOL)animated
{
    [self.pieChartView reloadChart];
}
#pragma mark - use Function

- (void)loadFunctionView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"抢车位";
    
    if (IOS7) {
        [self setExtendedLayoutIncludesOpaqueBars:NO];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    _currentClock = @"0000";
    _clockTickers = [[NSMutableArray alloc] initWithCapacity:12];
    for (int k = 0; k< 4; k++) {
        SBTickerView *view = [[SBTickerView alloc] initWithFrame:CGRectMake(40+60*k, 30, 42, 62)];
        [view setFrontView:[SBTickView tickViewWithTitle:@"0" fontSize:45.]];
        [self.view addSubview:view];
        [_clockTickers addObject:view];
    }
    
     [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(numberTick:) userInfo:nil repeats:YES];
    
    //饼图
    
    self.inOut = YES;
    self.valueArray = [[NSMutableArray alloc] initWithObjects:
                       [NSNumber numberWithInt:2],
                       [NSNumber numberWithInt:3],
                       [NSNumber numberWithInt:2],
                       [NSNumber numberWithInt:3],
                       [NSNumber numberWithInt:3],
                       [NSNumber numberWithInt:4],
                       nil];
    self.valueArray2 = [[NSMutableArray alloc] initWithObjects:
                        [NSNumber numberWithInt:3],
                        [NSNumber numberWithInt:2],
                        [NSNumber numberWithInt:2],
                        nil];
    
    self.colorArray = [NSMutableArray arrayWithObjects:
                       [UIColor colorWithHue:((0/8)%20)/20.0+0.02 saturation:(0%8+3)/10.0 brightness:91/100.0 alpha:1],
                       [UIColor colorWithHue:((1/8)%20)/20.0+0.02 saturation:(1%8+3)/10.0 brightness:91/100.0 alpha:1],
                       [UIColor colorWithHue:((2/8)%20)/20.0+0.02 saturation:(2%8+3)/10.0 brightness:91/100.0 alpha:1],
                       [UIColor colorWithHue:((3/8)%20)/20.0+0.02 saturation:(3%8+3)/10.0 brightness:91/100.0 alpha:1],
                       [UIColor colorWithHue:((4/8)%20)/20.0+0.02 saturation:(4%8+3)/10.0 brightness:91/100.0 alpha:1],
                       [UIColor colorWithHue:((5/8)%20)/20.0+0.02 saturation:(5%8+3)/10.0 brightness:91/100.0 alpha:1],
                       nil];
    self.colorArray2 = [[NSMutableArray alloc] initWithObjects:
                        [UIColor purpleColor],
                        [UIColor orangeColor],
                        [UIColor magentaColor],
                        nil];
    
    //add shadow img
    CGRect pieFrame = CGRectMake((self.view.frame.size.width - PIE_HEIGHT) / 2, 120, PIE_HEIGHT, PIE_HEIGHT);
    
    UIImage *shadowImg = [UIImage imageNamed:@"shadow.png"];
    UIImageView *shadowImgView = [[UIImageView alloc]initWithImage:shadowImg];
    shadowImgView.frame = CGRectMake(0, pieFrame.origin.y + PIE_HEIGHT*0.92, shadowImg.size.width/2, shadowImg.size.height/2);
    [self.view addSubview:shadowImgView];
    
    self.pieContainer = [[UIView alloc]initWithFrame:pieFrame];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.colorArray];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
    [self.pieChartView setAmountText:@"-2456.0"];
    [self.view addSubview:self.pieContainer];
    
    //add selected view
    UIImageView *selView = [[UIImageView alloc]init];
    selView.image = [UIImage imageNamed:@"select.png"];
    selView.frame = CGRectMake((self.view.frame.size.width - selView.image.size.width/2)/2, self.pieContainer.frame.origin.y + self.pieContainer.frame.size.height, selView.image.size.width/2, selView.image.size.height/2);
    [self.view addSubview:selView];
    
    self.selLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, selView.image.size.width/2, 21)];
    self.selLabel.backgroundColor = [UIColor clearColor];
    self.selLabel.textAlignment = NSTextAlignmentCenter;
    self.selLabel.font = [UIFont systemFontOfSize:17];
    self.selLabel.textColor = [UIColor whiteColor];
    [selView addSubview:self.selLabel];
    [self.pieChartView setTitleText:@"支出总计"];
    self.title = @"对账单";
    
}

- (void)numberTick:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mmss"];
    NSString *newClock = [formatter stringFromDate:[NSDate date]];
    
    [_clockTickers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![[_currentClock substringWithRange:NSMakeRange(idx, 1)] isEqualToString:[newClock substringWithRange:NSMakeRange(idx, 1)]]) {
            [obj setBackView:[SBTickView tickViewWithTitle:[newClock substringWithRange:NSMakeRange(idx, 1)] fontSize:45.]];
            [obj tick:SBTickerViewTickDirectionDown animated:YES completion:nil];
        }
    }];
    
    _currentClock = newClock;
}


#pragma mark - 饼图的delegate

- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per
{
    self.selLabel.text = [NSString stringWithFormat:@"%2.2f%@",per*100,@"%"];
}

- (void)onCenterClick:(PieChartView *)pieChartView
{
    self.inOut = !self.inOut;
    self.pieChartView.delegate = nil;
    [self.pieChartView removeFromSuperview];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.inOut?self.valueArray:self.valueArray2 withColor:self.inOut?self.colorArray:self.colorArray2];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
    [self.pieChartView reloadChart];
    
    if (self.inOut) {
        [self.pieChartView setTitleText:@"支出总计"];
        [self.pieChartView setAmountText:@"-2456.0"];
        
    }else{
        [self.pieChartView setTitleText:@"收入总计"];
        [self.pieChartView setAmountText:@"+567.23"];
    }
}


@end
