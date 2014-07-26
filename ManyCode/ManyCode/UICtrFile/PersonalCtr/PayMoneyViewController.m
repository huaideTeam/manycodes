//
//  PayMoneyViewController.m
//  ManyCode
//
//  Created by lichengfei on 14-7-26.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "PayMoneyViewController.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "UPPayPlugin.h"

@interface PayMoneyViewController ()<UPPayPluginDelegate>
{
    UITextField *mainTextField_;
}

@end

@implementation PayMoneyViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    mainView.contentSize = CGSizeMake(320, 560);
    mainView.userInteractionEnabled = YES;
    mainView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:mainView];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 345)];
    backImage.image = [UIImage imageNamed:@""];
//    [mainView addSubview:backImage];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(40,90,90, 90)];
    titleImage.image = [UIImage  imageNamed:@""];
    [mainView addSubview:titleImage];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 60, 150, 20)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kAccountMobile];
    [mainView addSubview:nameLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 90, 150, 20)];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.text = @"当前余额：34元";
    [mainView addSubview:priceLabel];
    
    
    UIButton * payButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 130, 90, 30)];
    [payButton addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    payButton.backgroundColor = [UIColor blueColor];
    [mainView addSubview:payButton];
    
    mainTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(52, 190, 215, 32)];
    mainTextField_.borderStyle = UITextBorderStyleRoundedRect;
    mainTextField_.placeholder = @"输入充值金额";
    mainTextField_.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [mainView addSubview:mainTextField_];
}

#pragma mark - 支付

- (void)payBtnClick:(UIButton *)button
{
    [mainTextField_ resignFirstResponder];
    if ([mainTextField_.text length]>0) {
         [[Hud defaultInstance] loading:self.view];
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
        [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountid] forKey:@"userid"];
        [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession] forKey:@"sessionid"];
       [tempDic setObject:mainTextField_.text forKey:@"mony"];
        
        [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"userRecharge" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
            [[Hud defaultInstance] hide:self.view];
            
        [UPPayPlugin startPay:[resultDic objectForKey:@"merchantOrderId"] mode:@"00" viewController:self delegate:self];

            
        } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else
    {
        [[Hud defaultInstance] showMessage:@"请输入充值的金额"];
    }
}

#pragma mark - 支付delegate
- (void)UPPayPluginResult:(NSString *)result
{
    NSString* msg = [NSString stringWithFormat:@"支付结果：%@", result];
    [[Hud defaultInstance] showMessage:msg];
}
@end
