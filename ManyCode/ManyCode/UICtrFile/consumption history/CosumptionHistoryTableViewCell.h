//
//  CosumptionHistoryTableViewCell.h
//  ManyCode
//
//  Created by Zhu Shouyu on 7/26/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CosumptionHistoryTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *consumptionTimeLabel;         //消费时间

@property (nonatomic, strong) UIImageView *consumptionTypeImageView;    //消费类型

@property (nonatomic, strong) UILabel *consumptionPlaceLabel;            //消费场所

@property (nonatomic, strong) UILabel *consumptionDetailLabel;          //消费明晰

@property (nonatomic, strong) UILabel *consumptionReduceMoney;          //消费扣款

@end
