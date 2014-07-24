//
//  HomeListParkingListTableViewCell.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/23/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "HomeListParkingListTableViewCell.h"

@implementation HomeListParkingListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(9.f, 15.f, 297.f, 90.f)];
        tempView.layer.borderColor = [UIColor grayColor].CGColor;
        tempView.layer.cornerRadius = 5.f;
        _parkingName = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 7.f, 200.f, 20.f)];
        [_parkingName setBackgroundColor:[UIColor clearColor]];
        _parkingName.textColor = COLOR(51, 51, 51);
        [tempView addSubview:_parkingName];
        [self.contentView addSubview:tempView];
        
        _parkingDistance = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(tempView.frame) - 100.f, CGRectGetMinY(_parkingName.frame), 90.f, CGRectGetHeight(_parkingName.frame))];
        [_parkingDistance setBackgroundColor:[UIColor clearColor]];
        _parkingDistance.textAlignment = NSTextAlignmentRight;
        _parkingName.textColor = COLOR(159, 159, 159);
        [tempView addSubview:_parkingDistance];
        
        _parkingAddress = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_parkingName.frame), CGRectGetMaxY(_parkingName.frame) + 5.f, 250.f, 20.f)];
        [_parkingAddress setBackgroundColor:[UIColor clearColor]];
        _parkingAddress.textColor = COLOR(159, 159, 159);
        [tempView addSubview:_parkingAddress];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8.f, CGRectGetMaxY(_parkingAddress.frame) + 5.f, CGRectGetWidth(tempView.frame) - 16.f, 2.f)];
        lineImageView.image = [UIImage imageNamed:@""];
        [self.contentView addSubview:lineImageView];
        
        _parkingNavigation = [UIButton buttonWithType:UIButtonTypeCustom];
        [_parkingNavigation setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_parkingNavigation setTitle:@"" forState:UIControlStateNormal];
        _parkingNavigation.frame = CGRectMake(0.f, CGRectGetMaxY(lineImageView.frame), CGRectGetWidth(tempView.frame) - 10.f, 35.f);
        [tempView addSubview:_parkingNavigation];
        
        UIImageView *seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_parkingNavigation.frame), CGRectGetMinY(_parkingNavigation.frame) + 2.f, 2.f, CGRectGetHeight(_parkingNavigation.frame) - 4.f)];
        seperateLine.image = [UIImage imageNamed:@""];
        [self.contentView addSubview:seperateLine];
        
        _parkingMyCar = [UIButton buttonWithType:UIButtonTypeCustom];
        [_parkingMyCar setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_parkingMyCar setTitle:@"" forState:UIControlStateNormal];
        _parkingMyCar.frame = CGRectMake(CGRectGetMaxX(seperateLine.frame), CGRectGetMinY(_parkingNavigation.frame), CGRectGetWidth(_parkingNavigation.frame), CGRectGetHeight(_parkingNavigation.frame));
        [tempView addSubview:_parkingMyCar];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
