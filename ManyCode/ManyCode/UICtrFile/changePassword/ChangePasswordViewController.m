//
//  ChangePasswordViewController.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/25/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "KeyboardSegment.h"

@interface ChangePasswordViewController ()

@property (nonatomic, strong) UITextField *forwardPasswordTextField;

@property (nonatomic, strong) UITextField *firstPasswordTextField;

@property (nonatomic, strong) UITextField *secondPasswordTextField;

@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation ChangePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"密码修改";
    
    NSArray *iconImageName = @[@"phoneNumber_logo", @"密码图标", @"密码图标"];
    NSArray *placeHolders = @[@"请输入当前密码", @"请输入新密码", @"再次确认新密码"];
    NSArray *vaues = @[@"forwardPasswordTextField", @"firstPasswordTextField", @"secondPasswordTextField"];
    
    CGFloat startX = 10.f;
    CGFloat startY = 15.f;
    CGFloat space = 5.f;
    CGFloat height = 50.f;
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, kCurrentWindowHeight-44)];
    _mainScrollView.backgroundColor = [UIColor clearColor];
    _mainScrollView.contentSize = CGSizeMake(320, kCurrentWindowHeight-44);
    [self.view addSubview:_mainScrollView];
    
    for (NSInteger index = 0; index < [iconImageName count]; index ++) {
        UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY + index * (height + space), CGRectGetWidth(self.view.frame) - 2 * startX, height)];
        tempView.image = [UIImage imageNamed:@"单条列表背景.png"];
        tempView.userInteractionEnabled = YES;
        [_mainScrollView addSubview:tempView];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 17.f, 18.f, 15.f)];
        [iconImageView setBackgroundColor:[UIColor clearColor]];
        iconImageView.image = [UIImage imageNamed:iconImageName[index]];
        [tempView addSubview:iconImageView];
        
        UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 20.f, 10.f, CGRectGetWidth(tempView.frame) - CGRectGetMaxX(iconImageView.frame) - 30.f, 30.f)];
        inputTextField.placeholder = placeHolders[index];
        [tempView addSubview:inputTextField];
        [inputTextField addDoneOnKeyboardWithTarget:self action:@selector(doneClicked:)];
        inputTextField.secureTextEntry = YES;
        [self setValue:inputTextField forKey:vaues[index]];
    }
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"register_normal"] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"register_selected"] forState:UIControlStateHighlighted];
    submitButton.frame = CGRectMake(startX, (height + space) * iconImageName.count + 2 * startY, CGRectGetWidth(self.view.frame) - 2 * startX, 52.f);
    [submitButton setTitle:@"验证并登录" forState:UIControlStateNormal];
    [_mainScrollView addSubview:submitButton];
    [submitButton addTarget:self action:@selector(submitButtonClickedMethod) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 键盘点击事件
-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}

#pragma mark - SubmitButtonClickedMethod
- (void)submitButtonClickedMethod {
    [self.firstPasswordTextField resignFirstResponder];
    [self.secondPasswordTextField resignFirstResponder];
    [self.forwardPasswordTextField resignFirstResponder];
    if (self.forwardPasswordTextField.text.length && self.firstPasswordTextField.text.length && self.secondPasswordTextField.text.length && [self.firstPasswordTextField.text isEqualToString:self.secondPasswordTextField.text]) {
        NSString * regex1  = @"^[A-Za-z0-9]+$";
        
        NSPredicate * pred2  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex1];
        
        BOOL isPasswordMatch   = [pred2 evaluateWithObject:self.firstPasswordTextField.text];
        if (isPasswordMatch) {
            [[Hud defaultInstance] loading:self.view withText:@"修改密码,请稍候..."];
            __weak ChangePasswordViewController *weakSelf = self;
            [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"setUserPassword" Parameter:@{@"sessionid":[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession], @"oldpassword":self.forwardPasswordTextField.text, @"newpassword":self.firstPasswordTextField.text} Finish:^(NSDictionary *resultDic) {
                if ([resultDic[@"statusCode"] isEqualToString:@"200"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:resultDic[@"mobile"] forKey:kAccountMobile];
                    [[NSUserDefaults standardUserDefaults] setObject:resultDic[@"sessionid"] forKey:kAccountSession];
                    [[NSUserDefaults standardUserDefaults] setObject:resultDic[@"userid"] forKey:kAccountid];
                    [[Hud defaultInstance] hide:self.view];
                    ChangePasswordViewController *strongSelf = weakSelf;
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                } else {
                    [[Hud defaultInstance] showMessage:@"密码失败"];
                }
                
            } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
                [[Hud defaultInstance] showMessage:@"密码失败"];
            }];
        } else {
            [[Hud defaultInstance] showMessage:@"请输入合法的密码，字母和数字组成，或者两次输入密码不一致"];
        }
    }
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
