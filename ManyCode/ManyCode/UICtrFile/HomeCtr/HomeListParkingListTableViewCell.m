//
//  HomeListParkingListTableViewCell.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/23/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "HomeListParkingListTableViewCell.h"
@interface CustomButton : UIButton
@end

@implementation CustomButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(CGRectGetMidX(contentRect) - 24.f, CGRectGetHeight(contentRect) / 2.f - 6.f, 14.f, 12.f);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(CGRectGetMidX(contentRect) -4, 0.f, CGRectGetWidth(contentRect) / 2 -10.f, CGRectGetHeight(contentRect));
}
@end
@implementation HomeListParkingListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(9.f, 15.f, 297.f, 100.f)];
        tempView.layer.borderColor = [UIColor grayColor].CGColor;
        tempView.layer.cornerRadius = 5.f;
        tempView.clipsToBounds = YES;
        [tempView setBackgroundColor:[UIColor whiteColor]];
        _parkingName = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 7.f, 200.f, 20.f)];
        [_parkingName setBackgroundColor:[UIColor clearColor]];
        _parkingName.textColor = COLOR(51, 51, 51);
        [tempView addSubview:_parkingName];
        [self.contentView addSubview:tempView];
        
        _parkingDistance = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(tempView.frame) - 100.f, CGRectGetMinY(_parkingName.frame), 90.f, CGRectGetHeight(_parkingName.frame))];
        [_parkingDistance setBackgroundColor:[UIColor clearColor]];
        _parkingDistance.textAlignment = NSTextAlignmentRight;
        _parkingDistance.textColor = COLOR(159, 159, 159);
        _parkingDistance.font = FONT(12);
        [tempView addSubview:_parkingDistance];
        
        _parkingAddress = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_parkingName.frame), CGRectGetMaxY(_parkingName.frame) + 5.f, 250.f, 20.f)];
        [_parkingAddress setBackgroundColor:[UIColor clearColor]];
        _parkingAddress.textColor = COLOR(159, 159, 159);
        _parkingAddress.font = FONT(12);
        [tempView addSubview:_parkingAddress];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8.f, CGRectGetMaxY(_parkingAddress.frame) + 5.f, CGRectGetWidth(tempView.frame) - 16.f, 2.f)];
        [lineImageView setBackgroundColor:COLOR(228, 228, 228)];
        lineImageView.image = [UIImage imageNamed:@""];
        [tempView addSubview:lineImageView];
        
        _parkingNavigation = [CustomButton buttonWithType:UIButtonTypeCustom];
        [_parkingNavigation setImage:[UIImage imageNamed:@"list_navigation"] forState:UIControlStateNormal];
        [_parkingNavigation setTitle:@"导航" forState:UIControlStateNormal];
        _parkingNavigation.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_parkingNavigation setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _parkingNavigation.frame = CGRectMake(0.f, CGRectGetMaxY(lineImageView.frame), CGRectGetWidth(tempView.frame) / 2 - 10.f, 35.f);
        [tempView addSubview:_parkingNavigation];
        
        UIImageView *seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_parkingNavigation.frame)+10, CGRectGetMinY(_parkingNavigation.frame) + 4.f, 2.f, CGRectGetHeight(_parkingNavigation.frame) - 8.f)];
        seperateLine.image = [UIImage imageNamed:@""];
        [seperateLine setBackgroundColor:COLOR(228, 228, 228)];
        [tempView addSubview:seperateLine];
        
        _parkingMyCar = [CustomButton buttonWithType:UIButtonTypeCustom];
        [_parkingMyCar setImage:[UIImage imageNamed:@"list_parking"] forState:UIControlStateNormal];
        [_parkingMyCar setTitle:@"停车" forState:UIControlStateNormal];
        _parkingMyCar.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_parkingMyCar setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _parkingMyCar.frame = CGRectMake(CGRectGetMaxX(seperateLine.frame), CGRectGetMinY(_parkingNavigation.frame), CGRectGetWidth(_parkingNavigation.frame), CGRectGetHeight(_parkingNavigation.frame));
        [tempView addSubview:_parkingMyCar];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
