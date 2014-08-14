//
//  SettingMainViewController.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/26/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "SettingMainViewController.h"
#import "SettingFirstSectionTableViewCell.h"
#import "SettingSecondSectionTableViewCell.h"
#import "Common.h"
#import "ChangePasswordViewController.h"

static NSString *identifierForFirstSectionCellSetting = @"identifierForFirstSectionCellSetting";
static NSString *identifierForSecondSectionCellSetting = @"identifierForSecondSectionCellSetting";

@interface SettingMainViewController ()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView*settingListTableView_;
}

@end

@implementation SettingMainViewController

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
    self.title = @"设置";
    settingListTableView_ = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    settingListTableView_.contentInset = UIEdgeInsetsMake(-35.f, 0, 0, 0);
    settingListTableView_.dataSource = self;
    settingListTableView_.delegate = self;
    [settingListTableView_ registerClass:[SettingFirstSectionTableViewCell class] forCellReuseIdentifier:identifierForFirstSectionCellSetting];
    [settingListTableView_ registerClass:[SettingSecondSectionTableViewCell class] forCellReuseIdentifier:identifierForSecondSectionCellSetting];
    [self.view addSubview:settingListTableView_];
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    if ([NetworkCenter instanceManager].isLogin) {
        
        UIButton *_submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setBackgroundImage:[UIImage imageNamed:@"register_normal"] forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage imageNamed:@"register_selected"] forState:UIControlStateHighlighted];
        _submitButton.frame = CGRectMake(9, 0, 302.f, 46.f);
        [_submitButton setTitle:@"注销" forState:UIControlStateNormal];
        [footView addSubview:_submitButton];
        [_submitButton addTarget:self action:@selector(logoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
     settingListTableView_.tableFooterView = footView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableVieDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
        {
            if ([NetworkCenter instanceManager].isLogin) {
                return 3;
            }else
            {
                return 2;
            }
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            SettingFirstSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForFirstSectionCellSetting forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *titles = @[@"开启地图自动定位", @"保持屏幕常亮", @"到达感应范围内自动弹出"];
            NSArray *keys = @[kAllowUsingLocation, kAllowIdleTimerInvalid, kAllowOpenAutomatic];
            cell.menuTitleLabel.text = titles[indexPath.row];
            cell.menuSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:keys[indexPath.row]];
            cell.menuSwitch.tag = indexPath.row;
            [cell.menuSwitch addTarget:self action:@selector(switchClickedMethod:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }
            break;
        case 1 :
        {
            SettingSecondSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForSecondSectionCellSetting forIndexPath:indexPath];
            NSArray *titles = nil;
            if ([NetworkCenter instanceManager].isLogin) {
                titles = @[@"清理缓存", @"流量统计", @"修改密码"];
            }else
            {
                titles = @[@"清理缓存", @"流量统计"];
            }
            
            cell.menuTitleLabel.text = titles[indexPath.row];
            if (indexPath.row != 1) {
                cell.menuDefaultLabel.hidden = YES;
            } else {
                cell.menuDefaultLabel.hidden = NO;
                cell.menuDefaultLabel.text = [NSString stringWithFormat:@"使用流量:%@", [Common getTotalBytes]];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            break;
        default:
        {
            return nil;
        }
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (1 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否清除缓存" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                alert.tag = 1000;
                [alert show];
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                ChangePasswordViewController *viewController = [[ChangePasswordViewController alloc] init];
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark - UISwitchClickedMethod
- (void)switchClickedMethod:(UISwitch *)tempSwitch {
    NSArray *keys = @[kAllowUsingLocation, kAllowIdleTimerInvalid, kAllowOpenAutomatic];
    [[NSUserDefaults standardUserDefaults] setBool:tempSwitch.on forKey:keys[tempSwitch.tag]];
    if (tempSwitch.tag == 1) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:[[NSUserDefaults standardUserDefaults] boolForKey:kAllowIdleTimerInvalid]];
    }
}

#pragma mark - alert delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (!buttonIndex) {
            [[Hud defaultInstance] showMessage:@"清除缓存成功"];
        }
    }
    
}

#pragma mark - 注销登录
- (void)logoutButtonClicked:(UIButton *)button
{
    [[Hud defaultInstance] loading:self.view withText:@"退出登录中"];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountid] forKey:@"userid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession] forKey:@"sessionid"];
    
    [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"logout" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
        [[Hud defaultInstance] showMessage:@"退出登录成功" withHud:YES];
        button.hidden = YES;
        [[NetworkCenter instanceManager] setIsLogin:NO];
        [[NetworkCenter instanceManager] setDevroadArray:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutNotify" object:nil];
        [settingListTableView_ reloadData];
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
@end
