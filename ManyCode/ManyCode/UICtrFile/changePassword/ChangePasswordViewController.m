//
//  ChangePasswordViewController.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/25/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@property (nonatomic, strong) UITextField *forwardPasswordTextField;

@property (nonatomic, strong) UITextField *firstPasswordTextField;

@property (nonatomic, strong) UITextField *secondPasswordTextField;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *iconImageName = @[@"", @"", @""];
    NSArray *placeHolders = @[@"请输入当前密码", @"请输入新密码", @"再次确认新密码"];
    NSArray *vaues = @[@"forwardPasswordTextField", @"firstPasswordTextField", @"secondPasswordTextField"];
    
    CGFloat startX = 10.f;
    CGFloat startY = 15.f;
    CGFloat space = 5.f;
    CGFloat height = 61.f;
    for (NSInteger index = 0; index < [iconImageName count]; index ++) {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY + index * (height + space), CGRectGetWidth(self.view.frame) - 2 * startX, height)];
        tempView.layer.cornerRadius = 5.f;
        tempView.backgroundColor = [UIColor whiteColor];
        tempView.layer.borderWidth = 1.f;
        tempView.layer.borderColor = [UIColor grayColor].CGColor;
        [self.view addSubview:tempView];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.f, CGRectGetHeight(tempView.frame) / 2.f - 7.f, 15.f, 15.f)];
        [iconImageView setBackgroundColor:[UIColor redColor]];
        iconImageView.image = [UIImage imageNamed:iconImageName[index]];
        [tempView addSubview:iconImageView];
        
        UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 3.f, 15.f, CGRectGetWidth(tempView.frame) - CGRectGetMaxX(iconImageView.frame) - 20.f, 30.f)];
        inputTextField.placeholder = placeHolders[index];
        [tempView addSubview:inputTextField];
        inputTextField.secureTextEntry = YES;
        [self setValue:inputTextField forKey:vaues[index]];
    }
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    submitButton.frame = CGRectMake(startX, (height + space) * iconImageName.count + 2 * startY, CGRectGetWidth(self.view.frame) - 2 * startX, 52.f);
    [submitButton setTitle:@"验证并登录" forState:UIControlStateNormal];
    [self.view addSubview:submitButton];
    [submitButton addTarget:self action:@selector(submitButtonClickedMethod) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

@end
