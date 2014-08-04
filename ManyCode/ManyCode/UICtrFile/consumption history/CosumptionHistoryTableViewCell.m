//
//  CosumptionHistoryTableViewCell.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/26/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "CosumptionHistoryTableViewCell.h"

@implementation CosumptionHistoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ConsumptionHistory"]];
        imageView.frame = CGRectMake(0, 0, 320.f, 70.f);
        [self.contentView addSubview:imageView];
        
        _consumptionTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.f, 32.f, 60.f, 30.f)];
        _consumptionTimeLabel.textColor = COLOR(128, 127, 127);
        _consumptionTimeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _consumptionTimeLabel.textAlignment = NSTextAlignmentCenter;
        _consumptionTimeLabel.numberOfLines = 2;
        _consumptionTimeLabel.backgroundColor = [UIColor clearColor];
        _consumptionTimeLabel.font = [UIFont systemFontOfSize:10.f];
        [self.contentView addSubview:_consumptionTimeLabel];
        
        _consumptionTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10.f, 20.f, 20.f)];
        _consumptionTypeImageView.center = CGPointMake(CGRectGetMaxX(_consumptionTimeLabel.frame), _consumptionTypeImageView.center.y);
        _consumptionTypeImageView.layer.cornerRadius = 10.f;
        _consumptionTypeImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_consumptionTypeImageView];
        
        _consumptionPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_consumptionTypeImageView.frame), CGRectGetMinY(_consumptionTypeImageView.frame), 200.f, 20.f)];
        _consumptionPlaceLabel.textColor = COLOR(106, 106, 106);
        _consumptionPlaceLabel.backgroundColor = [UIColor clearColor];
        _consumptionPlaceLabel.font = [UIFont systemFontOfSize:10.f];
        [self.contentView addSubview:_consumptionPlaceLabel];
        
        _consumptionDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_consumptionPlaceLabel.frame), CGRectGetMinY(_consumptionTimeLabel.frame) + 10.f, 135.f, 20.f)];
        _consumptionDetailLabel.textColor = COLOR(128, 127, 127);
        _consumptionDetailLabel.backgroundColor = [UIColor clearColor];
        _consumptionDetailLabel.font = [UIFont systemFontOfSize:10.f];
        [self.contentView addSubview:_consumptionDetailLabel];
        
        _consumptionReduceMoney = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_consumptionDetailLabel.frame), CGRectGetMinY(_consumptionDetailLabel.frame), 100.f, 20.f)];
        _consumptionReduceMoney.textColor = COLOR(128, 127, 127);
        _consumptionReduceMoney.backgroundColor = [UIColor clearColor];
        _consumptionReduceMoney.font = [UIFont systemFontOfSize:10.f];
        [self.contentView addSubview:_consumptionReduceMoney];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
