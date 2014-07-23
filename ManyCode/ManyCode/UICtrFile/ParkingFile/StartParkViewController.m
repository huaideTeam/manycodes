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

@interface StartParkViewController ()
{
    NSString *_currentClock;
    NSMutableArray *_clockTickers;
}

@property (nonatomic, strong)  SBTickerView *clockTickerViewHour1;
@property (nonatomic, strong)  SBTickerView *clockTickerViewHour2;
@property (nonatomic, strong)  SBTickerView *clockTickerViewMinute1;
@property (nonatomic, strong)  SBTickerView *clockTickerViewMinute2;

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

@end
