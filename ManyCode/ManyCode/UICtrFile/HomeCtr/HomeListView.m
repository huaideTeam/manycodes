//
//  HomeListView.m
//  ManyCode
//
//  Created by lichengfei on 14-7-23.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "HomeListView.h"
#import "HomeListParkingListTableViewCell.h"
#import "DataSourceModel.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

static NSString *identifierForHomeListTableView = @"identifierForHomeListTableView";

@interface HomeListView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *parkingListTableView;          //停车场列表

@property (nonatomic, strong) NSArray *parkingListDataSource;             //停车场数据源

@end

@implementation HomeListView

@synthesize parkingListDataSource = _parkingListDataSource;
@synthesize parkingListTableView = _parkingListTableView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _parkingListTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [_parkingListTableView registerClass:[HomeListParkingListTableViewCell class] forCellReuseIdentifier:identifierForHomeListTableView];
        _parkingListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _parkingListTableView.backgroundColor = COLOR(235, 237, 240);
        _parkingListTableView.dataSource = self;
        _parkingListTableView.delegate = self;
        [self addSubview:_parkingListTableView];
    }
    return self;
}

/**
 *  更新界面
 *
 *  @param parkingList 停车场列表
 */
- (void)refreshParkingList:(NSArray *)parkingList {
    self.parkingListDataSource = parkingList;
    [self.parkingListTableView reloadData];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.parkingListDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeListParkingListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForHomeListTableView forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *itemDic = self.parkingListDataSource[indexPath.row];
    cell.parkingName.text = [NSString stringWithFormat:@"%d.%@", indexPath.row + 1, [itemDic objectForKey:@"carparkname"]];
    cell.parkingDistance.text = [itemDic objectForKey:@"distance"];
    cell.parkingAddress.text = [itemDic objectForKey:@"address"];
    cell.parkingNavigation.tag = indexPath.row ;
    cell.parkingMyCar.tag = indexPath.row;
    [cell.parkingNavigation addTarget:self action:@selector(startNav:) forControlEvents:UIControlEventTouchUpInside];
    [cell.parkingMyCar addTarget:self action:@selector(startParking:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115.f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate pushToParkDetailView:self clickIndex:indexPath.row];
}
#pragma mark - 界面跳转

//开始导航
- (void)startNav:(UIButton *)button
{
    [self.delegate currentNavView:self clickIndex:button.tag];
}


- (void)startParking:(UIButton *)button
{
    [self.delegate currentParkView:self clickIndex:button.tag];
}

@end
