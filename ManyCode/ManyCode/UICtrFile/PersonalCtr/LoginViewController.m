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

@interface LoginViewController ()
{
    UIScrollView *mainScrollView_;
    UITextField *accountText_;
    UITextField *passwordText_;
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
    if (IOS7) {
        [self setExtendedLayoutIncludesOpaqueBars:NO];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.title = @"登陆";
    self.view.backgroundColor = COLOR(229.0, 228.0, 225.0);
    
    //返回按钮
    UIButton *backHome = [UIButton buttonWithType:UIButtonTypeCustom];
    backHome.frame = CGRectMake(0, 0.f, 24, 25.f);
    [backHome setBackgroundColor:[UIColor clearColor]];
    [backHome setImage:[UIImage imageNamed:@"personButton.png"] forState:UIControlStateNormal];
    [backHome setImage:[UIImage imageNamed:@"personButton.png"] forState:UIControlStateHighlighted];
	[backHome addTarget:self action:@selector(showLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    if (IOS7) {
        [self.navigationItem setLeftBarButtonItemInIOS7:[[UIBarButtonItem alloc] initWithCustomView:backHome]];
    }
    else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backHome];
    }
    
    //注册按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0.f, 24, 25.f);
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton setImage:[UIImage imageNamed:@"personButton.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"personButton.png"] forState:UIControlStateHighlighted];
	[leftButton addTarget:self action:@selector(registClick:) forControlEvents:UIControlEventTouchUpInside];
    if (IOS7) {
        [self.navigationItem setRightBarButtonItemInIOS7:[[UIBarButtonItem alloc] initWithCustomView:leftButton]];
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    }
    
    
    
    mainScrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, kCurrentWindowHeight)];
    mainScrollView_.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainScrollView_];
    
    [self addAccountView];
    
   
}

- (void)addAccountView
{
    UIView *accountView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 250)];
    //账号
    UIImageView *accoutImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 60)];
    accoutImage.image = [UIImage imageNamed:@""];
    [accountView addSubview:accoutImage];
    
    UIImageView *accoutIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
    accoutIcon.image = [UIImage imageNamed:@""];
    [accountView addSubview:accoutIcon];
    
    accountText_ = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, 250, 30)];
    accountText_.placeholder = @"请输入手机号码";
    accountText_.borderStyle = UITextBorderStyleNone;
    accountText_.keyboardType = UIKeyboardTypeNumberPad;
    [accountView addSubview:accountText_];
    
    //账号
    UIImageView *passwordImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 65, 300, 60)];
    passwordImage.image = [UIImage imageNamed:@""];
    [accountView addSubview:passwordImage];
    
    UIImageView *passwordIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 65, 30, 30)];
    passwordIcon.image = [UIImage imageNamed:@""];
    [accountView addSubview:passwordIcon];
    
    passwordText_ = [[UITextField alloc] initWithFrame:CGRectMake(50, 65, 250, 30)];
    passwordText_.placeholder = @"请输入密码";
    passwordText_.borderStyle = UITextBorderStyleNone;
    passwordText_.keyboardType = UIKeyboardTypeNumberPad;
    [accountView addSubview:passwordText_];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 150, 300, 55)];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpOutside];
    [accountView addSubview:loginButton];
    
   UnderLineLabel *passwordLable = [[UnderLineLabel alloc] initWithFrame:CGRectMake(30, 220, 80, 30)];
   passwordLable.shouldUnderline = YES;
    passwordLable.backgroundColor = [UIColor clearColor];
    passwordLable.textColor = [UIColor darkGrayColor];
    passwordLable.text = @"忘记密码?";
   [passwordLable addTarget:self action:@selector(forgotPasswdClick:)];
    [accountView addSubview:passwordLable];
    
    UnderLineLabel *changePasswordLable = [[UnderLineLabel alloc] initWithFrame:CGRectMake(200, 220, 80, 30)];
    changePasswordLable.shouldUnderline = YES;
    changePasswordLable.text = @"修改密码";
    changePasswordLable.textColor = [UIColor darkGrayColor];
    changePasswordLable.backgroundColor = [UIColor clearColor];
    [changePasswordLable addTarget:self action:@selector(changePasswdClick:)];
    [accountView addSubview:changePasswordLable];
    
    [mainScrollView_ addSubview:accountView];
}


#pragma mark - 返回按钮

- (void)showLeftClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registClick:(UIButton *)button
{
    
}

- (void)loginClick:(UIButton *)button
{
    
}

- (void)forgotPasswdClick:(id)sender
{
    
}

- (void)changePasswdClick:(id)sender
{
    
}
@end
