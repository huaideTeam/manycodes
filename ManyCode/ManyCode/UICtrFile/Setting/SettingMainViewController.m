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
    UITableView *settingListTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
            return cell;
        }
            break;
        case 1 :
        {
            SettingSecondSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForSecondSectionCellSetting forIndexPath:indexPath];
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
@end
