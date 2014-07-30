//
//  RegisterFirstStepViewController.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/24/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "RegisterFirstStepViewController.h"
#import "UnderLineLabel.h"
#import "RegisterSecondStepViewController.h"

@interface RegisterFirstStepViewController ()

@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, strong) UITextField *inputTextField;

@end

@implementation RegisterFirstStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    
    NSString *value = @"1 输入手机号  >  2 输入验证码  3 设置密码";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:value];
    
    CTFontRef tempFont = CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:16].fontName,
                                              16,
                                              NULL);
    [str addAttribute:(NSString *)kCTFontAttributeName
                value:(__bridge id)tempFont
                range:NSMakeRange(0, str.length)];
    CFRelease(tempFont);
    
    UIColor *normarlColor = COLOR(113, 112, 112);
    [str addAttribute:(NSString *)kCTForegroundColorAttributeName
                value:(id)normarlColor.CGColor
                range:NSMakeRange(0, str.length)];
    NSRange range = [value rangeOfString:@"1 输入手机号"];
    UIColor *currentColor = COLOR(227, 166, 149);
    [str addAttribute:(NSString *)kCTForegroundColorAttributeName
                value:(id)currentColor.CGColor
                range:range];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.frame = CGRectMake(0.f, 30.f, CGRectGetWidth(self.view.frame), 29.f);
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.foregroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.f].CGColor;
    textLayer.string = str;
    [self.view.layer addSublayer:textLayer];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textLayer.frame) - 3.f, CGRectGetWidth(self.view.bounds), 1.f)];
    [lineImageView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:lineImageView];
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(10.f, CGRectGetMaxY(textLayer.frame) + 15.f, CGRectGetWidth(self.view.frame) - 20.f, 61.f)];
    tempView.layer.cornerRadius = 5.f;
    tempView.backgroundColor = [UIColor whiteColor];
    tempView.layer.borderWidth = 1.f;
    tempView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:tempView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.f, CGRectGetHeight(tempView.frame) / 2.f - 7.f, 15.f, 15.f)];
    [iconImageView setBackgroundColor:[UIColor clearColor]];
    iconImageView.image = [UIImage imageNamed:@"phoneNumber_logo"];
    [tempView addSubview:iconImageView];
    
    UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 3.f, 15.f, CGRectGetWidth(tempView.frame) - CGRectGetMaxX(iconImageView.frame) - 20.f, 30.f)];
    inputTextField.placeholder = @"请输入您的手机号码";
    inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    [tempView addSubview:inputTextField];
    self.inputTextField = inputTextField;
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitButton setBackgroundImage:[UIImage imageNamed:@"register_normal"] forState:UIControlStateNormal];
    [_submitButton setBackgroundImage:[UIImage imageNamed:@"register_selected"] forState:UIControlStateHighlighted];
    _submitButton.frame = CGRectMake(CGRectGetMinX(tempView.frame), CGRectGetMaxY(tempView.frame) + 38.f, CGRectGetWidth(tempView.frame), 52.f);
    [_submitButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.view addSubview:_submitButton];
    [_submitButton addTarget:self action:@selector(submitButtonClickedMethod) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *checkBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBoxButton setImage:[UIImage imageNamed:@"未勾选.png"] forState:UIControlStateNormal];
    [checkBoxButton setImage:[UIImage imageNamed:@"同意勾选.png"] forState:UIControlStateSelected];
    checkBoxButton.frame = CGRectMake(CGRectGetMinX(_submitButton.frame) + 5.f, CGRectGetMaxY(_submitButton.frame) + 5.f, 15.f, 15.f);
    [self.view addSubview:checkBoxButton];
    checkBoxButton.selected = YES;
    [checkBoxButton addTarget:self action:@selector(checkBoxButtonClickedMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(checkBoxButton.frame) + 3.f, CGRectGetMinY(checkBoxButton.frame), 120.f, CGRectGetHeight(checkBoxButton.frame))];
    tempLabel.text = @"我已阅读并同意";
    [tempLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tempLabel];
    
    UnderLineLabel *lineLabel = [[UnderLineLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tempLabel.frame), CGRectGetMinY(tempLabel.frame), 128.f, CGRectGetHeight(tempLabel.frame))];
    lineLabel.textColor = [UIColor orangeColor];
    lineLabel.shouldUnderline = YES;
    [lineLabel setText:@"抢车位用户协议" andCenter:lineLabel.center];
    [lineLabel addTarget:self action:@selector(readTheCopyRightButtonClickedMethod)];
    [self.view addSubview:lineLabel];
}


#pragma mark - SubmitButtonClickedMethod 
- (void)submitButtonClickedMethod {
    [self.inputTextField resignFirstResponder];
    NSString * regex   = @"^[0-9]*$";
    
    NSPredicate * pred  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isAccountMatch    = [pred evaluateWithObject:self.inputTextField.text];
    if (self.inputTextField.text.length == 11 && isAccountMatch) {
        [[Hud defaultInstance] loading:self.view withText:@"获取验证码中..."];
        __weak RegisterFirstStepViewController *weakSelf = self;
        [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getSMSVerify" Parameter:@{@"mobile":_inputTextField.text} Finish:^(NSDictionary *resultDic) {
            if ([resultDic[@"statusCode"] isEqualToString:@"200"]) {
                [[NSUserDefaults standardUserDefaults] setObject:resultDic[@"mobile"] forKey:kAccountMobile];
                RegisterFirstStepViewController *strongSelf = weakSelf;
                RegisterSecondStepViewController *viewC = [[RegisterSecondStepViewController alloc] initWithVerifyCode:resultDic[@"verify"]];
                [strongSelf.navigationController pushViewController:viewC animated:YES];
            } else {
                [[Hud defaultInstance] showMessage:@"获取验证码失败"];
            }
            
        } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[Hud defaultInstance] showMessage:@"获取验证码失败"];
        }];
        
    }
    else {
        [[Hud defaultInstance] showMessage:@"请输入合法手机号"];
    }
    
}

#pragma mark - 是否同意用户协议按钮点击事件
- (void)checkBoxButtonClickedMethod:(UIButton *)checkBoxButton {
    
    checkBoxButton.selected = !checkBoxButton.selected;
    self.submitButton.userInteractionEnabled = checkBoxButton.selected;
}

#pragma mark - 阅读协议点击事件
- (void)readTheCopyRightButtonClickedMethod {
    
}
@end
