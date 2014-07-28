//
//  RegisterThirdStepViewController.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/25/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "RegisterThirdStepViewController.h"
#import "LoginViewController.h"

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
    NSRange range = [value rangeOfString:@"设置密码"];
    
    UIColor *currentColor = COLOR(227, 166, 149);
    [str addAttribute:(NSString *)kCTForegroundColorAttributeName
                value:(id)currentColor.CGColor
                range:range];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.frame = CGRectMake(0.f, 30.f, CGRectGetWidth(self.view.frame), 29.f);
    textLayer.alignmentMode = kCAAlignmentCenter;
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
    inputTextField.placeholder = @"设置密码";
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
    [nextTempView addSubview:nextInputTextField];
    nextInputTextField.secureTextEntry = YES;
    self.secondPasswordTextField = nextInputTextField;
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"register_normal"] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"register_selected"] forState:UIControlStateHighlighted];
    submitButton.frame = CGRectMake(CGRectGetMinX(nextTempView.frame), CGRectGetMaxY(nextTempView.frame) + 38.f, CGRectGetWidth(nextTempView.frame), 52.f);
    [submitButton setTitle:@"完成注册" forState:UIControlStateNormal];
    [self.view addSubview:submitButton];
    [submitButton addTarget:self action:@selector(submitButtonClickedMethod) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - SubmitButtonClickedMethod
- (void)submitButtonClickedMethod {
    [self.firstPasswordTextField resignFirstResponder];
    [self.secondPasswordTextField resignFirstResponder];
    if (self.firstPasswordTextField.text.length && self.secondPasswordTextField.text.length && [self.firstPasswordTextField.text isEqualToString:self.secondPasswordTextField.text]) {
        NSString * regex1  = @"^[A-Za-z0-9]+$";
        
        NSPredicate * pred2  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex1];
        
        BOOL isPasswordMatch   = [pred2 evaluateWithObject:self.firstPasswordTextField.text];
        if (isPasswordMatch) {
            [[Hud defaultInstance] loading:self.view withText:@"注册中,请稍候..."];
            __weak RegisterThirdStepViewController *weakSelf = self;
            [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"register" Parameter:@{@"mobile":[[NSUserDefaults standardUserDefaults] objectForKey:kAccountMobile], @"password":self.firstPasswordTextField.text} Finish:^(NSDictionary *resultDic) {
                if ([resultDic[@"statusCode"] isEqualToString:@"200"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:resultDic[@"mobile"] forKey:kAccountMobile];
                    [[NSUserDefaults standardUserDefaults] setObject:resultDic[@"sessionid"] forKey:kAccountSession];
                    [[NSUserDefaults standardUserDefaults] setObject:resultDic[@"userid"] forKey:kAccountid];
                    [[Hud defaultInstance] hide:self.view];
                    RegisterThirdStepViewController *strongSelf = weakSelf;
                    NSArray *viewControllers = strongSelf.navigationController.viewControllers;
                    for (UIViewController *temp in viewControllers) {
                        if ([temp isKindOfClass:[LoginViewController class]]) {
                            [strongSelf.navigationController popToViewController:temp animated:YES];
                            break;
                        }
                    }
                } else {
                    [[Hud defaultInstance] showMessage:@"用户注册失败"];
                }
                
            } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
                [[Hud defaultInstance] showMessage:@"用户注册失败"];
            }];
        } else {
            [[Hud defaultInstance] showMessage:@"请输入合法的密码，字母和数字组成，或者两次输入密码不一致"];
        }
    }
}

@end
