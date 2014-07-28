//
//  PersonalCenterViewController.m
//  ManyCode
//
//  Created by lichengfei on 14-7-22.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalCell.h"
#import "LoginViewController.h"
#import "SettingMainViewController.h"
#import "ConsumptionHistoryViewController.h"
#import "PayMoneyViewController.h"
#import "Common.h"
#import "MyPurseViewController.h"
#import "UINavigationItem+Items.h"

@interface PersonalCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *mainTableView_;
    NSArray *nameArray_;
    UIButton *photoBtn_;
}

@end

@implementation PersonalCenterViewController


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
    self.view.backgroundColor = COLOR(220, 220, 220);
    self.title = @"个人中心";
    
    //返回按钮
    UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHome.frame = CGRectMake(0, 0.f, 50, 28.f);
    [btnHome setBackgroundColor:[UIColor clearColor]];
    [btnHome setBackgroundImage:[UIImage imageNamed:@"返回按钮常态.png"] forState:UIControlStateNormal];
    [btnHome setBackgroundImage:[UIImage imageNamed:@"返回按钮效果.png"] forState:UIControlStateHighlighted];
    [btnHome addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnHome setTitle:@"返回" forState:UIControlStateNormal];
    btnHome.titleLabel.font = FONT(12);
    if (IOS7) {
        [self.navigationItem setLeftBarButtonItemInIOS7:[[UIBarButtonItem alloc] initWithCustomView:btnHome]];
    }
    else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnHome];
    }
    
    nameArray_ = @[@"我的钱包",@"停车扣费记录",@"快捷支付",@"设置",@"版本更新"];
    mainTableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kCurrentWindowHeight- kTopImageHeight- kStatueHeight)];
    mainTableView_.delegate = self;
    mainTableView_.dataSource = self;
    mainTableView_.backgroundColor = [UIColor clearColor];
    mainTableView_.backgroundView = nil;
    [mainTableView_ setTableHeaderView:[self creatHeadView:NO]];
    [mainTableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:mainTableView_];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:@"loginNotification" object:nil];

}

#pragma mark - 返回按钮
- (void)backClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma makr - 自定义view
- (UIView *)creatHeadView:(BOOL )isLogin
{
    if (isLogin) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 175)];
        backImage.image = [UIImage  imageNamed:@"头像背景.png"];
        [headView addSubview:backImage];
        
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(25,75,90, 90)];
        titleImage.image = [UIImage  imageNamed:@"示意头像 描边.png"];
        titleImage.userInteractionEnabled = YES;
        [headView addSubview:titleImage];
        
        photoBtn_ = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        photoBtn_.backgroundColor = [UIColor clearColor];
        [photoBtn_ setBackgroundImage:[UIImage imageNamed:@"示意头像 图片.png"] forState:UIControlStateNormal];
        [photoBtn_ addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [titleImage addSubview:photoBtn_];
        
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 110, 150, 20)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kAccountMobile];
        [headView addSubview:nameLabel];
        
        UIButton  *priceBtn = [[UIButton alloc] initWithFrame:CGRectMake(130, 125, 150, 20)];
        priceBtn.backgroundColor = [UIColor clearColor];
        [priceBtn setTitle:@"当前余额：34元" forState:UIControlStateNormal];
        [priceBtn addTarget:self action:@selector(chargeMoneyClick:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:priceBtn];
        
        return headView;
    }else
    {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 175)];
        backImage.image = [UIImage  imageNamed:@"头像背景.png"];
        [headView addSubview:backImage];
        
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(25,75,90, 90)];
        titleImage.image = [UIImage  imageNamed:@"示意头像 描边.png"];
        titleImage.userInteractionEnabled = YES;
        [headView addSubview:titleImage];
        
        photoBtn_ = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        photoBtn_.backgroundColor = [UIColor clearColor];
        [photoBtn_ setBackgroundImage:[UIImage imageNamed:@"示意头像 图片.png"] forState:UIControlStateNormal];
        [photoBtn_ addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [titleImage addSubview:photoBtn_];
        
        UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 135, 100, 30)];
        [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
        loginButton.backgroundColor = [UIColor clearColor];
        [loginButton setBackgroundImage:[UIImage imageNamed:@"立即登录按钮常态.png"] forState:UIControlStateNormal];
         [loginButton setBackgroundImage:[UIImage imageNamed:@"立即登录按钮效果.png"] forState:UIControlStateNormal];
        [loginButton  addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:loginButton];
        
        return headView;
    }
}

- (void)loginClick:(UIButton *)button
{
    LoginViewController *viewCtr = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:viewCtr animated:YES];
    
}

#pragma mark - 拍照

- (void)takePhoto:(UIButton *)button
{
    
}
#pragma mark - table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return nameArray_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *personId = @"personID";
    PersonalCell *cell= [tableView dequeueReusableCellWithIdentifier:personId];
    if (cell == nil) {
        cell = [[PersonalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personId];
    }
    cell.titleLabel.text = nameArray_[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //@"我的钱包",@"停车扣费记录",@"快捷支付",@"设置",@"版本更新"
    switch (indexPath.row) {
        case 0:     //
        {
            if ([NetworkCenter instanceManager].isLogin) {
                MyPurseViewController *viewCtr = [[MyPurseViewController alloc] init];
                [self.navigationController pushViewController:viewCtr animated:YES];
            }else
            {
                [[Hud defaultInstance] showMessage:@"请登录"];
            }
        }
            break;
        case 1:
        {
            ConsumptionHistoryViewController *viewController = [[ConsumptionHistoryViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            SettingMainViewController *viewController = [[SettingMainViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 4:
        {
            [Common checkUpdateVersion:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - notify

- (void)loginSuccess:(NSNotification *)notify
{
    if ([[notify name] isEqualToString:@"loginNotification"]) {
        [mainTableView_ setTableHeaderView:[self creatHeadView:YES]];
    }
}

- (void)chargeMoneyClick:(UIButton *)button
{
    PayMoneyViewController *viewCtr = [[PayMoneyViewController alloc] init];
    [self.navigationController pushViewController:viewCtr animated:YES];
}
@end
