//
//  RegisterThirdStepViewController.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/25/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "RegisterThirdStepViewController.h"

@interface RegisterThirdStepViewController ()

@property (nonatomic, strong) UITextField *firstPasswordTextField;

@property (nonatomic, strong) UITextField *secondPasswordTextField;

@end
@implementation RegisterThirdStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    
    NSString *value = @"1 输入手机号  >  2 输入验证码  > 设置密码";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:value];
    CTFontRef tempFont = CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:18].fontName,
                                              18,
                                              NULL);
    [str addAttribute:(NSString *)kCTFontAttributeName
                value:(__bridge id)tempFont
                range:NSMakeRange(0, str.length)];
    CFRelease(tempFont);
    
    UIColor *normarlColor = COLOR(113, 112, 112);
    [str addAttribute:(NSString *)kCTForegroundColorAttributeName
                value:(id)normarlColor.CGColor
                range:NSMakeRange(0, str.length)];
    NSRange range = [value rangeOfString:@"设置密码"];
    
    CTFontRef nextFont = CTFontCreateWithName((CFStringRef)[UIFont boldSystemFontOfSize:18].fontName,
                                              18,
                                              NULL);
    UIColor *currentColor = COLOR(227, 166, 149);
    [str addAttribute:(NSString *)kCTForegroundColorAttributeName
                value:(id)currentColor.CGColor
                range:range];
    CFRelease(nextFont);
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.frame), 49.f);
    textLayer.fontSize = 18.f;
    textLayer.foregroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.f].CGColor;
    textLayer.string = str;
    [self.view.layer addSublayer:textLayer];
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(10.f, CGRectGetMinY(textLayer.frame) + 15.f, CGRectGetWidth(self.view.frame) - 20.f, 61.f)];
    tempView.layer.cornerRadius = 5.f;
    tempView.backgroundColor = [UIColor whiteColor];
    tempView.layer.borderWidth = 1.f;
    tempView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:tempView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.f, CGRectGetHeight(tempView.frame) / 2.f - 7.f, 15.f, 15.f)];
    [iconImageView setBackgroundColor:[UIColor redColor]];
    [tempView addSubview:iconImageView];
    
    UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 3.f, 15.f, CGRectGetWidth(tempView.frame) - CGRectGetMaxX(iconImageView.frame) - 20.f, 30.f)];
    inputTextField.placeholder = @"设置密码";
    inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    [tempView addSubview:inputTextField];
    inputTextField.secureTextEntry = YES;
    self.firstPasswordTextField = inputTextField;
    
    UIView *nextTempView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(tempView.frame), CGRectGetMaxY(tempView.frame) + 15.f, CGRectGetWidth(tempView.frame), CGRectGetHeight(tempView.frame))];
    nextTempView.layer.cornerRadius = 5.f;
    nextTempView.backgroundColor = [UIColor whiteColor];
    nextTempView.layer.borderWidth = 1.f;
    nextTempView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:nextTempView];
    
    UIImageView *nextIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.f, CGRectGetHeight(nextTempView.frame) / 2.f - 7.f, 15.f, 15.f)];
    [nextIconImageView setBackgroundColor:[UIColor redColor]];
    [nextTempView addSubview:nextIconImageView];
    
    UITextField *nextInputTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nextIconImageView.frame) + 3.f, 15.f, CGRectGetWidth(tempView.frame) - CGRectGetMaxX(iconImageView.frame) - 20.f, 30.f)];
    nextInputTextField.placeholder = @"再次确认密码";
    nextInputTextField.keyboardType = UIKeyboardTypeNumberPad;
    [nextTempView addSubview:nextInputTextField];
    nextInputTextField.secureTextEntry = YES;
    self.secondPasswordTextField = nextInputTextField;
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    submitButton.frame = CGRectMake(CGRectGetMinX(nextTempView.frame), CGRectGetMaxY(nextTempView.frame) + 38.f, CGRectGetWidth(nextTempView.frame), 52.f);
    [submitButton setTitle:@"完成注册" forState:UIControlStateNormal];
    [self.view addSubview:submitButton];
    [submitButton addTarget:self action:@selector(submitButtonClickedMethod) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - SubmitButtonClickedMethod
- (void)submitButtonClickedMethod {
    
}

@end
