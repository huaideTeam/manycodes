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

static NSString *identifierForFirstSectionCellSetting = @"identifierForFirstSectionCellSetting";
static NSString *identifierForSecondSectionCellSetting = @"identifierForSecondSectionCellSetting";

@interface SettingMainViewController ()<UITableViewDataSource, UITableViewDelegate>

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
    UITableView *settingListTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    settingListTableView.contentInset = UIEdgeInsetsMake(-35.f, 0, 0, 0);
    settingListTableView.dataSource = self;
    settingListTableView.delegate = self;
    [settingListTableView registerClass:[SettingFirstSectionTableViewCell class] forCellReuseIdentifier:identifierForFirstSectionCellSetting];
    [settingListTableView registerClass:[SettingSecondSectionTableViewCell class] forCellReuseIdentifier:identifierForSecondSectionCellSetting];
    [self.view addSubview:settingListTableView];
    
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
            return 3;
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
            NSArray *titles = @[@"清理缓存", @"流量统计", @"精品推荐"];
            cell.menuTitleLabel.text = titles[indexPath.row];
            if (indexPath.row != 0) {
                cell.menuDefaultLabel.hidden = YES;
            } else {
                cell.menuDefaultLabel.hidden = NO;
                cell.menuDefaultLabel.text = [NSString stringWithFormat:@"本月使用流量:%dB", 100];
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
    if (1 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                
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
}
@end
