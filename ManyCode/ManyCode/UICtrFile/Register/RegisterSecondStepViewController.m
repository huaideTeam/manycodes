//
//  RegisterSecondStepViewController.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/25/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "RegisterSecondStepViewController.h"
#import "RegisterThirdStepViewController.h"

@interface RegisterSecondStepViewController ()

@property (nonatomic, strong) UITextField *inputTextField;

@property (nonatomic, strong) NSString *verifyCode;

@end

@implementation RegisterSecondStepViewController

/**
 *  个人用户注册第二步
 *
 *  @param verifyCode 从服务器获取的验证码
 *
 *  @return 用户注册第二步实例
 */
- (instancetype)initWithVerifyCode:(NSString *)verifyCode {
    self = [super init];
    if (self) {
        _verifyCode = verifyCode;
    }
    return self;
}


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
    NSRange range = [value rangeOfString:@"2 输入验证码"];
    
    UIColor *currentColor = COLOR(227, 166, 149);
    [str addAttribute:(NSString *)kCTForegroundColorAttributeName
                value:(id)currentColor.CGColor
                range:range];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.frame = CGRectMake(0.f, 10.f, CGRectGetWidth(self.view.frame), 49.f);
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.foregroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.f].CGColor;
    textLayer.string = str;
    [self.view.layer addSublayer:textLayer];
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(10.f, CGRectGetMaxY(textLayer.frame) + 15.f, CGRectGetWidth(self.view.frame) - 20.f, 61.f)];
    tempView.layer.cornerRadius = 5.f;
    tempView.backgroundColor = [UIColor whiteColor];
    tempView.layer.borderWidth = 1.f;
    tempView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:tempView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.f, CGRectGetHeight(tempView.frame) / 2.f - 7.f, 15.f, 15.f)];
    [iconImageView setBackgroundColor:[UIColor redColor]];
    [tempView addSubview:iconImageView];
    
    UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 3.f, 15.f, CGRectGetWidth(tempView.frame) - CGRectGetMaxX(iconImageView.frame) - 20.f, 30.f)];
    inputTextField.placeholder = @"请输入短信验证码";
    inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    [tempView addSubview:inputTextField];
    self.inputTextField = inputTextField;
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    submitButton.frame = CGRectMake(CGRectGetMinX(tempView.frame), CGRectGetMaxY(tempView.frame) + 38.f, CGRectGetWidth(tempView.frame), 52.f);
    [submitButton setTitle:@"通过验证" forState:UIControlStateNormal];
    [self.view addSubview:submitButton];
    [submitButton addTarget:self action:@selector(submitButtonClickedMethod) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - SubmitButtonClickedMethod
- (void)submitButtonClickedMethod {
    [self.inputTextField resignFirstResponder];
    if ([self.inputTextField.text isEqualToString:self.verifyCode]) {
        RegisterThirdStepViewController *viewController = [[RegisterThirdStepViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        [[Hud defaultInstance] showMessage:@"请输入正确的验证码"];
    }
    
}

@end
