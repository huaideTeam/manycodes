//
//  HomeListParkingListTableViewCell.h
//  ManyCode
//
//  Created by Zhu Shouyu on 7/23/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeListParkingListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *parkingName;             //停车场名称

@property (nonatomic, strong) UILabel *parkingDistance;         //停车场距离当前的距离

@property (nonatomic, strong) UILabel *parkingAddress;          //停车场地址

@property (nonatomic, strong) UIButton *parkingNavigation;      //停车场导航

@property (nonatomic, strong) UIButton *parkingMyCar;           //停车

@end
