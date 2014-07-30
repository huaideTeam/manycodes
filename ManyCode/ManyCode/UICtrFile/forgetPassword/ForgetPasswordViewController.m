//
//  ForgetPasswordViewController.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/28/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "KeyboardSegment.h"

@interface ForgetPasswordViewController ()

@property (nonatomic, strong) UITextField *phoneNumberTextField;

@property (nonatomic, strong) UITextField *checkCodeTextField;

@property (nonatomic, strong) NSString *checkCode;

@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation ForgetPasswordViewController
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
    self.title = @"找回密码";
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, kCurrentWindowHeight-44)];
    _mainScrollView.backgroundColor = [UIColor clearColor];
    _mainScrollView.contentSize = CGSizeMake(320, kCurrentWindowHeight-44);
    [self.view addSubview:_mainScrollView];
    
    UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 15.f, 165.f, 50.f)];
    tempView.image = [UIImage imageNamed:@"单条列表背景.png"];
    tempView.userInteractionEnabled = YES;
    [_mainScrollView addSubview:tempView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 17.f, 18.f, 15.f)];
    [iconImageView setBackgroundColor:[UIColor clearColor]];
    iconImageView.image = [UIImage imageNamed:@"phoneNumber_logo"];
    [tempView addSubview:iconImageView];
    
    UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 20.f, 10.f, CGRectGetWidth(tempView.frame) - CGRectGetMaxX(iconImageView.frame) - 30.f, 30.f)];
    inputTextField.placeholder = @"请输入您的手机号码";
    [inputTextField addDoneOnKeyboardWithTarget:self action:@selector(doneClicked:)];
    inputTextField.font = [UIFont systemFontOfSize:13.f];
    inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    [tempView addSubview:inputTextField];
    self.phoneNumberTextField = inputTextField;
    
    UIButton *_submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitButton setBackgroundImage:[UIImage imageNamed:@"register_normal"] forState:UIControlStateNormal];
    [_submitButton setBackgroundImage:[UIImage imageNamed:@"register_selected"] forState:UIControlStateHighlighted];
    _submitButton.frame = CGRectMake(CGRectGetMaxX(tempView.frame) + 20.f, CGRectGetMinY(tempView.frame), CGRectGetWidth(self.view.frame) - CGRectGetMaxX(tempView.frame) - CGRectGetMinX(tempView.frame) - 20.f, CGRectGetHeight(tempView.frame));
    [_submitButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_mainScrollView addSubview:_submitButton];
    [_submitButton addTarget:self action:@selector(submitButtonClickedMethod) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *nextTempView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(tempView.frame), CGRectGetMaxY(tempView.frame) + 3.f, CGRectGetWidth(self.view.frame) - 2 * CGRectGetMinX(tempView.frame), CGRectGetHeight(tempView.frame))];
    nextTempView.layer.cornerRadius = 5.f;
    nextTempView.backgroundColor = [UIColor whiteColor];
    nextTempView.layer.borderWidth = 1.f;
    nextTempView.layer.borderColor = [UIColor grayColor].CGColor;
    [_mainScrollView addSubview:nextTempView];
    
    UIImageView *nextIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.f, CGRectGetHeight(tempView.frame) / 2.f - 7.f, 15.f, 15.f)];
    nextIconImageView.image = [UIImage imageNamed:@"密码图标"];
    [nextIconImageView setBackgroundColor:[UIColor clearColor]];
    [nextTempView addSubview:nextIconImageView];
    
    UITextField *nextInputTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nextIconImageView.frame) + 3.f, 15.f, CGRectGetWidth(tempView.frame) - CGRectGetMaxX(iconImageView.frame) - 20.f, 30.f)];
    nextInputTextField.placeholder = @"请输入短信验证码";
    [nextTempView addSubview:nextInputTextField];
    [nextInputTextField addDoneOnKeyboardWithTarget:self action:@selector(doneClicked:)];
    nextInputTextField.font = [UIFont systemFontOfSize:13.f];
    nextInputTextField.secureTextEntry = YES;
    self.checkCodeTextField = nextInputTextField;
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"register_normal"] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"register_selected"] forState:UIControlStateHighlighted];
    submitButton.frame = CGRectMake(CGRectGetMinX(nextTempView.frame), CGRectGetMaxY(nextTempView.frame) + 38.f, CGRectGetWidth(nextTempView.frame), 52.f);
    [submitButton setTitle:@"验证并登录" forState:UIControlStateNormal];
    [_mainScrollView addSubview:submitButton];
    [submitButton addTarget:self action:@selector(checkCodeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SubmitButtonClickedMethod
- (void)submitButtonClickedMethod {
    [self.phoneNumberTextField resignFirstResponder];
    NSString * regex   = @"^[0-9]*$";
    
    NSPredicate * pred  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isAccountMatch    = [pred evaluateWithObject:self.phoneNumberTextField.text];
    if (self.phoneNumberTextField.text.length == 11 && isAccountMatch) {
        [[Hud defaultInstance] loading:self.view withText:@"获取验证码中..."];
        __weak ForgetPasswordViewController *weakSelf = self;
        [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getSMSVerify" Parameter:@{@"mobile":_phoneNumberTextField.text} Finish:^(NSDictionary *resultDic) {
            if ([resultDic[@"statusCode"] isEqualToString:@"200"]) {
                [[NSUserDefaults standardUserDefaults] setObject:resultDic[@"mobile"] forKey:kAccountMobile];
                ForgetPasswordViewController *strongSelf = weakSelf;
                strongSelf.checkCode = resultDic[@"verify"];
                [[Hud defaultInstance] hide:strongSelf.view];
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

#pragma mark - SubmitButtonClickedMethod
- (void)checkCodeButtonClicked {
    [self.phoneNumberTextField resignFirstResponder];
    [self.checkCodeTextField resignFirstResponder];
    if ([self.checkCodeTextField.text isEqualToString:self.checkCode]) {
        [[Hud defaultInstance] loading:self.view withText:@"获取密码中..."];
        __weak ForgetPasswordViewController *weakSelf = self;
        [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"userForgetpassword" Parameter:@{@"mobile":_phoneNumberTextField.text} Finish:^(NSDictionary *resultDic) {
            if ([resultDic[@"statusCode"] isEqualToString:@"200"]) {
                [[NSUserDefaults standardUserDefaults] setObject:resultDic[@"mobile"] forKey:kAccountMobile];
                ForgetPasswordViewController *strongSelf = weakSelf;
                [strongSelf.navigationController popViewControllerAnimated:YES];
                [[Hud defaultInstance] hide:strongSelf.view];
            } else {
                [[Hud defaultInstance] showMessage:@"获取密码失败"];
            }
            
        } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[Hud defaultInstance] showMessage:@"获取密码失败"];
        }];
    } else {
        [[Hud defaultInstance] showMessage:@"请输入正确的验证码"];
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
