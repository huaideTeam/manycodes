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
    
    
    
    mainScrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, kCurrentWindowHeight-44)];
    mainScrollView_.backgroundColor = [UIColor clearColor];
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
    UIImageView *accoutImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 60)];
    accoutImage.image = [UIImage imageNamed:@""];
    [accountView addSubview:accoutImage];
    
    UIImageView *accoutIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
    accoutIcon.image = [UIImage imageNamed:@""];
    [accountView addSubview:accoutIcon];
    
    accountText_ = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, 250, 30)];
    accountText_.placeholder = @"请输入手机号码";
    accountText_.text = @"18913394805";
    [accountText_ addDoneOnKeyboardWithTarget:self action:@selector(doneClicked:)];
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
    passwordText_.text = @"123456";
    [passwordText_ addDoneOnKeyboardWithTarget:self action:@selector(doneClicked:)];
    passwordText_.borderStyle = UITextBorderStyleNone;
    passwordText_.keyboardType = UIKeyboardTypeNumberPad;
    [accountView addSubview:passwordText_];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 150, 300, 55)];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.backgroundColor = [UIColor redColor];
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
    RegisterFirstStepViewController *viewController = [[RegisterFirstStepViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)loginClick:(UIButton *)button
{
    [self.view endEditing:YES];
    [self.view endEditing:NO];
    
    [[Hud defaultInstance] loading:self.view withText:@"登陆中...."];
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
            [[Hud defaultInstance] showMessage:@"登陆成功" withHud:YES];
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

#pragma mark - 保存登陆信息

- (void)saveLoginInfo:(NSDictionary *)dic
{
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"mobile"] forKey:kAccountMobile];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"userid"] forKey:kAccountid];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"sessionid"] forKey:kAccountSession];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"balance"] forKey:kAccountBalance];
}

#pragma mark - keyboard btn
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize kbSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect viewFrame = CGRectMake(0.f, 0.f, SCREENWIDTH, SCREENHEIGHT - 44.f);
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
        CGRect viewFrame = CGRectMake(0.f, 0.f, SCREENWIDTH, SCREENHEIGHT - 44.f);
        mainScrollView_.frame = viewFrame;
    }];
    
    return;
}


@end
