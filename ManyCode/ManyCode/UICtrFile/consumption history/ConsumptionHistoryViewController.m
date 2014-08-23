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
#import "Common.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

static NSString *identifierForCosumptionHistory = @"identifierForCosumptionHistory";

@interface ConsumptionHistoryViewController ()<UITableViewDataSource, UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
}

@property (nonatomic, strong) UITableView *consumptionHistoryTableView;

@property (nonatomic, strong) NSMutableArray *consumptionHistoryDataSource;

@property (nonatomic, strong) NSDate *currentFilterDate;

@property (nonatomic, assign) NSInteger pageIndex;

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
    
    self.titleLable.text = @"缴费记录";
    _pageIndex = 1;
    _consumptionHistoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopImageHeight, CGRectGetWidth(self.view.frame), kCurrentWindowHeight- kTopImageHeight-kStatueHeight)];
    [_consumptionHistoryTableView registerClass:[CosumptionHistoryTableViewCell class] forCellReuseIdentifier:identifierForCosumptionHistory];
    _consumptionHistoryTableView.delegate = self;
    _consumptionHistoryTableView.dataSource = self;
    _consumptionHistoryTableView.backgroundColor = COLOR(229, 228, 225);
    _consumptionHistoryTableView.backgroundView = nil;
    [_consumptionHistoryTableView setTableHeaderView:[self headerViewForCosumptionList]];
    [_consumptionHistoryTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _consumptionHistoryTableView.separatorColor = COLOR(212, 212, 211);
    [self.view addSubview:_consumptionHistoryTableView];
    
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = _consumptionHistoryTableView;
    
    UIButton *calendar = [UIButton buttonWithType:UIButtonTypeCustom];
    calendar.backgroundColor = [UIColor clearColor];
    [calendar setBackgroundImage:[UIImage imageNamed:@"日历图标.png"] forState:UIControlStateNormal];
    [calendar addTarget:self action:@selector(showCalendarView) forControlEvents:UIControlEventTouchUpInside];
    [self.consumptionHistoryTableView addSubview:calendar];
    calendar.frame = CGRectMake(5.f, 75.f, 25.f, 30.f);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- refresh view
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loadOrderData) userInfo:nil repeats:NO];
}

- (void)loadOrderData
{
    [self requestDataSourceFromServerShouldShowHud:NO];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [_footer endRefreshing];
    return self.consumptionHistoryDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CosumptionHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForCosumptionHistory forIndexPath:indexPath];
    ConsumptionHistoryItemModel *item = self.consumptionHistoryDataSource[indexPath.row];
    cell.consumptionTimeLabel.text = [Common getDateWithSeconds:[item.chgtime longLongValue]];
    cell.consumptionPlaceLabel.text = item.remark;
//    cell.consumptionDetailLabel.text = item.remark;
    cell.consumptionReduceMoney.text = [NSString stringWithFormat:@"扣除费用：%@元",item.money];
    switch ([item.chgtype intValue]) {
        case 0:
        {
            cell.consumptionTypeImageView.image = [UIImage imageNamed:@"充值图标.png"];
           
        }
            break;
        case 1 :
        {
             cell.consumptionTypeImageView.image = [UIImage imageNamed:@"停车图标.png"];
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
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 90)];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    backImage.image = [UIImage  imageNamed:@"payMoneyTitleImage.png"];
    [headView addSubview:backImage];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(25,18,65.f, 65.)];
    titleImage.image = [UIImage  imageNamed:@"示意头像 描边.png"];
    titleImage.userInteractionEnabled = YES;
    [headView addSubview:titleImage];
    
    UIImageView * photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    photoImage.backgroundColor = [UIColor clearColor];
    photoImage.layer.masksToBounds = YES;
    photoImage.center = titleImage.center;
    photoImage.layer.cornerRadius = photoImage.frame.size.height/2;
    [photoImage setImageWithURL:HEADIMG placeholderImage:[UIImage imageNamed:@"示意头像 图片.png"]];
    [headView addSubview:photoImage];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 25, 150, 20)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = FONT(18);
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = ACCOUNTNAME;
    [headView addSubview:nameLabel];
    
    UILabel *priceBtn_ = [[UILabel alloc] initWithFrame:CGRectMake(120, 50, 150, 20)];
    priceBtn_.backgroundColor = [UIColor clearColor];
    priceBtn_.font = FONT(18);
    priceBtn_.textColor = [UIColor whiteColor];
    priceBtn_.text = BALANCE;
    [headView addSubview:priceBtn_];
    return headView;
}

#pragma mark - 服务器交互数据请求

- (void)requestDataSourceFromServerShouldShowHud:(BOOL)show {
    if (show) {
        [[Hud defaultInstance] loading:self.view withText:@"加载数据中,请稍候。。。"];
    }
    __weak ConsumptionHistoryViewController *weakSelf = self;
    NSDictionary *parameters = nil;
    if (self.currentFilterDate) {
        parameters = @{
                       @"sessionid":[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession],
                       @"userid":[[NSUserDefaults standardUserDefaults] objectForKey:kAccountid],
                       @"querytime":[Common getDateString:self.currentFilterDate],
                       @"page": [NSString stringWithFormat:@"%d", _pageIndex]
                       };
    }
    else {
        parameters = @{
                       @"sessionid":[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession],
                       @"userid":[[NSUserDefaults standardUserDefaults] objectForKey:kAccountid],
                       @"page": [NSString stringWithFormat:@"%d", _pageIndex]
                       };
    }
    [[NetworkCenter instanceManager]
     requestWebWithParaWithURL:@"getUserBalanceChange"
     Parameter:parameters
     Finish:^(NSDictionary *resultDic) {
         ConsumptionHistoryViewController *strongSelf = weakSelf;
         ConsumptionHistoryModel *model = [[ConsumptionHistoryModel alloc] init];
         [model initializeTheDataSourceWithDictionary:resultDic];
         strongSelf.consumptionHistoryDataSource = [NSMutableArray arrayWithArray:model.banchglist];
         if (show) {
             [[Hud defaultInstance] hide:strongSelf.view];
         }
         _pageIndex ++;
         [strongSelf.consumptionHistoryTableView reloadData];
         
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (error.code == 219) {
            _pageIndex = 1;
            [self.consumptionHistoryDataSource removeAllObjects];
            [self.consumptionHistoryTableView reloadData];
        }
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
    view.currentChoosedDate = self.currentFilterDate ? self.currentFilterDate : [NSDate date];
    [view setBackgroundColor:[UIColor clearColor]];
    __weak ConsumptionHistoryViewController *weakSelf = self;
    CalendarSelectedSomeDate block = ^(CalendarView *calendarView) {
        _pageIndex = 0;
        ConsumptionHistoryViewController *strongSelf = weakSelf;
        strongSelf.currentFilterDate = calendarView.selectedDate;
        [self requestDataSourceFromServerShouldShowHud:YES];
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
