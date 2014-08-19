//
//  RegisterThirdStepViewController.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/25/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "RegisterThirdStepViewController.h"
#import "LoginViewController.h"
#import "KeyboardSegment.h"

@interface RegisterThirdStepViewController ()

@property (nonatomic, strong) UITextField *firstPasswordTextField;

@property (nonatomic, strong) UITextField *secondPasswordTextField;

@property (nonatomic, strong) UIScrollView *mainScrollView;

@end
@implementation RegisterThirdStepViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, kCurrentWindowHeight-44)];
    _mainScrollView.backgroundColor = [UIColor clearColor];
    _mainScrollView.contentSize = CGSizeMake(320, kCurrentWindowHeight-44);
    [self.view addSubview:_mainScrollView];
    
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
    textLayer.frame = CGRectMake(0.f, 26.f, CGRectGetWidth(self.view.frame), 29.f);
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.foregroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.f].CGColor;
    textLayer.string = str;
    [_mainScrollView.layer addSublayer:textLayer];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textLayer.frame) - 3.f, CGRectGetWidth(self.view.bounds), 1.f)];
    [lineImageView setBackgroundColor:[UIColor grayColor]];
    [_mainScrollView addSubview:lineImageView];
    
    UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, CGRectGetMaxY(textLayer.frame) + 15.f, CGRectGetWidth(self.view.frame) - 20.f, 50.f)];
    tempView.image = [UIImage imageNamed:@"单条列表背景.png"];
    tempView.userInteractionEnabled = YES;
    [_mainScrollView addSubview:tempView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 17.f, 18.f, 15.f)];
    [iconImageView setBackgroundColor:[UIColor clearColor]];
    iconImageView.image = [UIImage imageNamed:@"密码图标.png"];
    [tempView addSubview:iconImageView];
    
    UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 20.f, 10.f, CGRectGetWidth(tempView.frame) - CGRectGetMaxX(iconImageView.frame) - 30.f, 30.f)];
    inputTextField.placeholder = @"设置密码";
    [tempView addSubview:inputTextField];
    [inputTextField addDoneOnKeyboardWithTarget:self action:@selector(doneClicked:)];
    inputTextField.secureTextEntry = YES;
    self.firstPasswordTextField = inputTextField;
    
    UIImageView *nextTempView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(tempView.frame), CGRectGetMaxY(tempView.frame) + 15.f, CGRectGetWidth(tempView.frame), CGRectGetHeight(tempView.frame))];
    nextTempView.image = [UIImage imageNamed:@"单条列表背景.png"];
    nextTempView.userInteractionEnabled = YES;
    [_mainScrollView addSubview:nextTempView];
    
    UIImageView *nextIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 17.f, 18.f, 15.f)];
    nextIconImageView.image = [UIImage imageNamed:@"密码图标.png"];
    [nextIconImageView setBackgroundColor:[UIColor clearColor]];
    [nextTempView addSubview:nextIconImageView];
    
    UITextField *nextInputTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 20.f, 10.f, CGRectGetWidth(tempView.frame) - CGRectGetMaxX(iconImageView.frame) - 30.f, 30.f)];
    nextInputTextField.placeholder = @"再次确认密码";
    [nextTempView addSubview:nextInputTextField];
    [nextInputTextField addDoneOnKeyboardWithTarget:self action:@selector(doneClicked:)];
    nextInputTextField.secureTextEntry = YES;
    self.secondPasswordTextField = nextInputTextField;
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"register_normal"] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"register_selected"] forState:UIControlStateHighlighted];
    submitButton.frame = CGRectMake(CGRectGetMinX(nextTempView.frame), CGRectGetMaxY(nextTempView.frame) + 38.f, CGRectGetWidth(nextTempView.frame), 52.f);
    [submitButton setTitle:@"完成注册" forState:UIControlStateNormal];
    [_mainScrollView addSubview:submitButton];
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
            [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"register" Parameter:@{@"mobile":ACCOUNTNAME, @"password":self.firstPasswordTextField.text} Finish:^(NSDictionary *resultDic) {
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

#pragma mark - 键盘点击事件
-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}

#pragma mark - keyboard btn
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize kbSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect viewFrame = CGRectMake(0.f, 0.f, SCREENWIDTH, SCREENHEIGHT - 44.f);
        viewFrame.size.height -= kbSize.height;
        _mainScrollView.frame = viewFrame;
    }];
    
    return;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect viewFrame = CGRectMake(0.f, 0.f, SCREENWIDTH, SCREENHEIGHT - 44.f);
        _mainScrollView.frame = viewFrame;
    }];
    
    return;
}

@end
