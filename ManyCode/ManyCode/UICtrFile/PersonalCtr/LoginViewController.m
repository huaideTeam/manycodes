//
//  LoginViewController.m
//  ManyCode
//
//  Created by lichengfei on 14-7-23.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "LoginViewController.h"
#import "UINavigationItem+Items.h"
#import "UnderLineLabel.h"
#import "KeyboardSegment.h"
#import "RegisterFirstStepViewController.h"
#import "ChangePasswordViewController.h"
#import "ForgetPasswordViewController.h"

@interface LoginViewController ()
{
    UIScrollView *mainScrollView_;
    UITextField *accountText_;
    UITextField *passwordText_;
    UIButton *storeButton_;
}

@end

@implementation LoginViewController

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


#pragma mark - use define

- (void)loadFunctionView
{
    self.titleLable.text = @"登录";    
    //注册按钮
    self.rightButton.frame = CGRectMake(270, 5, 42, 30);
    [self.rightButton setBackgroundColor:[UIColor clearColor]];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"注册登录按钮常态.png"] forState:UIControlStateNormal];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"注册登录按钮效果.png"] forState:UIControlStateHighlighted];
    [self.rightButton setTitle:@"注册" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = FONT(12);
    self.rightButton.hidden = NO;
    
    mainScrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopImageHeight, 320, kCurrentWindowHeight-kTopImageHeight- kStatueHeight)];
    mainScrollView_.backgroundColor = COLOR(229, 228, 225);
    mainScrollView_.contentSize = CGSizeMake(320, kCurrentWindowHeight-44);
    [self.view addSubview:mainScrollView_];
    
    [self addAccountView];
    
    
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

- (void)addAccountView
{
    UIView *accountView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 250)];
    //账号
    UIImageView *accoutImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 50)];
    accoutImage.image = [UIImage imageNamed:@"单条列表背景.png"];
    accoutImage.userInteractionEnabled = YES;
    [accountView addSubview:accoutImage];
    
    UIImageView *accoutIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 18, 15)];
    accoutIcon.image = [UIImage imageNamed:@"手机号码图标.png"];
    [accoutImage addSubview:accoutIcon];
    
    accountText_ = [[UITextField alloc] initWithFrame:CGRectMake(50, 10, 250, 30)];
    accountText_.placeholder = @"请输入手机号码";
    [accountText_ addDoneOnKeyboardWithTarget:self action:@selector(doneClicked:)];
    accountText_.borderStyle = UITextBorderStyleNone;
    accountText_.keyboardType = UIKeyboardTypeNumberPad;
    [accoutImage addSubview:accountText_];
    
    //账号
    UIImageView *passwordImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 52, 300, 50)];
    passwordImage.image = [UIImage imageNamed:@"单条列表背景.png"];
    passwordImage.userInteractionEnabled = YES;
    [accountView addSubview:passwordImage];
    
    UIImageView *passwordIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 18, 15)];
    passwordIcon.image = [UIImage imageNamed:@"密码图标.png"];
    [passwordImage addSubview:passwordIcon];
    
    passwordText_ = [[UITextField alloc] initWithFrame:CGRectMake(50, 10, 250, 30)];
    passwordText_.placeholder = @"请输入密码";
    [passwordText_ addDoneOnKeyboardWithTarget:self action:@selector(doneClicked:)];
    passwordText_.borderStyle = UITextBorderStyleNone;
    passwordText_.keyboardType = UIKeyboardTypeNumberPad;
    [passwordImage addSubview:passwordText_];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 130, 300, 55)];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.backgroundColor = [UIColor clearColor];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"注册 登录按钮常态.png"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"注册 登录按钮效果.png"] forState:UIControlStateHighlighted];
    [accountView addSubview:loginButton];
    
    
    storeButton_ = [[UIButton alloc] initWithFrame:CGRectMake(10, 192, 25, 25)];
    storeButton_.backgroundColor = [UIColor clearColor];
    [storeButton_ setBackgroundImage:[UIImage imageNamed:@"未勾选.png"] forState:UIControlStateNormal];
    [storeButton_ setBackgroundImage:[UIImage imageNamed:@"同意勾选.png"] forState:UIControlStateSelected];
    [storeButton_ addTarget:self action:@selector(storeClick:) forControlEvents:UIControlEventTouchUpInside];
    storeButton_.selected = YES;
    [accountView addSubview:storeButton_];
    
    UILabel * nameLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 192, 100, 25)];
    nameLable.text = @"记住密码";
    nameLable.textColor = [UIColor darkGrayColor];
    [accountView addSubview:nameLable];
    
    
   UnderLineLabel *passwordLable = [[UnderLineLabel alloc] initWithFrame:CGRectMake(220, 190, 80, 30)];
   passwordLable.shouldUnderline = YES;
    passwordLable.backgroundColor = [UIColor clearColor];
    passwordLable.textColor = [UIColor darkGrayColor];
    passwordLable.text = @"忘记密码?";
   [passwordLable addTarget:self action:@selector(forgotPasswdClick:)];
    [accountView addSubview:passwordLable];
    
    [mainScrollView_ addSubview:accountView];
}

//是不是记住登陆
- (void)storeClick:(UIButton *)button
{
    button.selected = !button.selected;
}

#pragma mark - 返回按钮


- (void)rightClick:(UIButton *)button
{
    RegisterFirstStepViewController *viewController = [[RegisterFirstStepViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)loginClick:(UIButton *)button
{
    [self.view endEditing:YES];
    [self.view endEditing:NO];
    
    [[Hud defaultInstance] loading:self.view withText:@"登录中...."];
    //判断账户和密码不能为空
    if (accountText_.text.length == 0 || passwordText_.text.length == 0) {
        [[Hud defaultInstance] showMessage:@"手机号码或者密码为空"];
        return;
    }
    
    NSString * regex   = @"^[0-9]*$";
    
    NSPredicate * pred  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isAccountMatch    = [pred evaluateWithObject:accountText_.text];
    
    NSString * regex1  = @"^[A-Za-z0-9]+$";
    
    NSPredicate * pred2  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex1];
    
    BOOL isPasswordMatch   = [pred2 evaluateWithObject:passwordText_.text];
    
    if (isAccountMatch && isPasswordMatch)
    {
    
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
        [tempDic setObject:accountText_.text forKey:@"mobile"];
        [tempDic setObject:passwordText_.text forKey:@"password"];
        
        [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"checkLogin" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
            [self saveLoginInfo:resultDic];
            [[Hud defaultInstance] showMessage:@"登录成功" withHud:YES];
            [[NetworkCenter instanceManager] setIsLogin:YES];
            [[NetworkCenter instanceManager] setDevroadArray:resultDic[@"devroadstatus"]];
             [[NSUserDefaults standardUserDefaults] setObject:passwordText_.text forKey:kPassWord];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginNotification" object:nil];
            
        } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else
    {
        [[Hud defaultInstance] showMessage:@"用户名或者密码错误"];
        return;
    }
}

- (void)forgotPasswdClick:(id)sender
{
    ForgetPasswordViewController *forgetPass = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgetPass animated:YES];
}

- (void)changePasswdClick:(id)sender
{
    ChangePasswordViewController *viewController = [[ChangePasswordViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}

#pragma mark - 保存登录信息

- (void)saveLoginInfo:(NSDictionary *)dic
{
    
     [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:storeButton_.selected] forKey:@"isStoreLogin"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"mobile"] forKey:kAccountMobile];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"userid"] forKey:kAccountid];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"sessionid"] forKey:kAccountSession];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"balance"] forKey:kAccountBalance];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"head_img"] forKey:kHead_img];
}

#pragma mark - keyboard btn
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize kbSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect viewFrame = CGRectMake(0, kTopImageHeight, 320, kCurrentWindowHeight-kTopImageHeight- kStatueHeight);
        viewFrame.size.height -= kbSize.height;
        mainScrollView_.frame = viewFrame;
    }];
    
    return;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect viewFrame =CGRectMake(0, kTopImageHeight, 320, kCurrentWindowHeight-kTopImageHeight- kStatueHeight);
        mainScrollView_.frame = viewFrame;
    }];
    
    return;
}


@end
