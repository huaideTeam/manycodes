//
//  ConsumptionHistoryViewController.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/26/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "ConsumptionHistoryViewController.h"
#import "CosumptionHistoryTableViewCell.h"
#import "DataSourceModel.h"
#import "CalendarView.h"

static NSString *identifierForCosumptionHistory = @"identifierForCosumptionHistory";

@interface ConsumptionHistoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *consumptionHistoryTableView;

@property (nonatomic, strong) NSArray *consumptionHistoryDataSource;

@property (nonatomic, strong) NSDate *currentFilterDate;

@end

@implementation ConsumptionHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestDataSourceFromServerShouldShowHud:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"缴费记录";
    _currentFilterDate = [NSDate date];
    _consumptionHistoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kCurrentWindowHeight- kTopImageHeight)];
    [_consumptionHistoryTableView registerClass:[CosumptionHistoryTableViewCell class] forCellReuseIdentifier:identifierForCosumptionHistory];
    _consumptionHistoryTableView.delegate = self;
    _consumptionHistoryTableView.dataSource = self;
    _consumptionHistoryTableView.backgroundColor = [UIColor clearColor];
    _consumptionHistoryTableView.backgroundView = nil;
    [_consumptionHistoryTableView setTableHeaderView:[self headerViewForCosumptionList]];
    [_consumptionHistoryTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _consumptionHistoryTableView.separatorColor = COLOR(212, 212, 211);
    [self.view addSubview:_consumptionHistoryTableView];
    
    UIButton *calendar = [UIButton buttonWithType:UIButtonTypeCustom];
    calendar.backgroundColor = [UIColor redColor];
    [calendar addTarget:self action:@selector(showCalendarView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:calendar];
    calendar.frame = CGRectMake(5.f, 175.f, 50.f, 50.f);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.consumptionHistoryDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CosumptionHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForCosumptionHistory forIndexPath:indexPath];
    ConsumptionHistoryItemModel *item = self.consumptionHistoryDataSource[indexPath.row];
    cell.consumptionTimeLabel.text = item.chgtime;
//    cell.consumptionPlaceLabel.text = item.c
    cell.consumptionDetailLabel.text = item.remark;
    cell.consumptionReduceMoney.text = item.money;
    switch ([item.chgtype intValue]) {
        case 0:
        {
            cell.consumptionTypeImageView.backgroundColor = [UIColor redColor];
        }
            break;
        case 1 :
        {
            cell.consumptionTypeImageView.backgroundColor = [UIColor greenColor];
        }
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}
#pragma mark - 列表头
- (UIView *)headerViewForCosumptionList {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200)];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:headView.bounds];
    backImage.image = [UIImage  imageNamed:@"头像背景.png"];
    [headView addSubview:backImage];
    
    UIImageView *circleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25.f, CGRectGetMaxY(backImage.frame) - 120.f, 90.f, 90.f)];
    circleImageView.image = [UIImage imageNamed:@"示意头像 描边.png"];
    [circleImageView setBackgroundColor:[UIColor clearColor]];
    [headView addSubview:circleImageView];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(25,90,90, 90)];
    titleImage.center = circleImageView.center;
    titleImage.image = [UIImage  imageNamed:@"示意头像 图片.png"];
    [headView addSubview:titleImage];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(circleImageView.frame) + 10.f, CGRectGetMidY(circleImageView.frame) - 20.f, 150, 20)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kAccountMobile];
    [headView addSubview:nameLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame), CGRectGetWidth(nameLabel.frame), CGRectGetHeight(nameLabel.frame))];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.text = BALANCE;
    [headView addSubview:priceLabel];
    return headView;
}

#pragma mark - 服务器交互数据请求

- (void)requestDataSourceFromServerShouldShowHud:(BOOL)show {
    if (show) {
        [[Hud defaultInstance] loading:self.view withText:@"加载数据中,请稍候。。。"];
    }
    __weak ConsumptionHistoryViewController *weakSelf = self;
    [[NetworkCenter instanceManager]
     requestWebWithParaWithURL:@"getUserBalanceChange"
     Parameter:@{@"sessionid":[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession],
                 @"userid":[[NSUserDefaults standardUserDefaults] objectForKey:kAccountid],
                 @"page":@"-1"}
     Finish:^(NSDictionary *resultDic) {
         ConsumptionHistoryViewController *strongSelf = weakSelf;
         ConsumptionHistoryModel *model = [[ConsumptionHistoryModel alloc] init];
         [model initializeTheDataSourceWithDictionary:resultDic];
         strongSelf.consumptionHistoryDataSource = [NSArray arrayWithArray:model.banchglist];
         if (show) {
             [[Hud defaultInstance] hide:strongSelf.view];
         }
         [strongSelf.consumptionHistoryTableView reloadData];
         
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (show) {
            ConsumptionHistoryViewController *strongSelf = weakSelf;
            [[Hud defaultInstance] hide:strongSelf.view];
        }
        [[Hud defaultInstance] showMessage:@"加载数据失败"];
    }];
}

#pragma  mark - 显示日历界面
- (void)showCalendarView {
    UIControl *tempControl = [[UIControl alloc] initWithFrame:self.view.bounds];
    tempControl.backgroundColor = [UIColor blackColor];
    tempControl.alpha = 0.5f;
    [tempControl addTarget:self action:@selector(hideCalendarView) forControlEvents:UIControlEventValueChanged];
    tempControl.tag = 1UL << 7;
    [self.view addSubview:tempControl];
    CalendarView *view = [[CalendarView alloc] initWithFrame:CGRectMake(40.f, 100.f, CGRectGetWidth(self.view.frame) - 80.f, 250.f)];
    view.tag = 1UL << 8;
    view.currentChoosedDate = self.currentFilterDate;
    [view setBackgroundColor:[UIColor clearColor]];
    __weak ConsumptionHistoryViewController *weakSelf = self;
    CalendarSelectedSomeDate block = ^(CalendarView *calendarView) {
        ConsumptionHistoryViewController *strongSelf = weakSelf;
        strongSelf.currentFilterDate = calendarView.selectedDate;
        [strongSelf hideCalendarView];
    };
    [view setChoosedSomeDate:block];
    [self.view addSubview:view];
}

- (void)hideCalendarView {
    UIControl *tempControl = (UIControl *)[self.view viewWithTag:1UL << 7];
    [tempControl removeFromSuperview];
    
    CalendarView *tempView = (CalendarView *)[self.view viewWithTag:1UL << 8];
    [tempView removeFromSuperview];
}
@end
