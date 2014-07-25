//
//  MapFootView.m
//  ManyCode
//
//  Created by lichengfei on 14-7-24.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "MapFootView.h"
@interface CustomButton1 : UIButton
@end

@implementation CustomButton1

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(CGRectGetMidX(contentRect) - 15.f, CGRectGetHeight(contentRect) / 2.f - 6.f, 14.f, 12.f);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(CGRectGetMidX(contentRect) + 5.f, 0.f, CGRectGetWidth(contentRect) / 2 -10.f, CGRectGetHeight(contentRect));
}
@end

@implementation MapFootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(10.f, 0.f, 300.f, frame.size.height)];
        tempView.layer.borderColor = [UIColor grayColor].CGColor;
        tempView.layer.cornerRadius = 5.f;
        tempView.clipsToBounds = YES;
        [tempView setBackgroundColor:[UIColor whiteColor]];
        _parkingName = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 7.f, 200.f, 20.f)];
        [_parkingName setBackgroundColor:[UIColor clearColor]];
        _parkingName.textColor = COLOR(51, 51, 51);
        [tempView addSubview:_parkingName];
        [self addSubview:tempView];
        
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
        
        _nameButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(tempView.frame) - 80.f, CGRectGetMaxY(_parkingDistance.frame),70.f, 30)];
        [_nameButton setBackgroundColor:[UIColor clearColor]];
        _nameButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [_nameButton setTitle:@"详情" forState:UIControlStateNormal];
        [_nameButton setTitleColor:COLOR(67, 147, 183) forState:UIControlStateNormal];
        _nameButton.titleLabel.font = FONT(15);
        [_nameButton setTitleColor:COLOR(67, 147, 183) forState:UIControlStateHighlighted];
        
        UIImageView *detailIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 6, 10)];
        detailIcon.image = [UIImage imageNamed:@"详情图标.png"];
        [_nameButton addSubview:detailIcon];
        [tempView addSubview:_nameButton];
        
        _detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tempView.frame), CGRectGetMaxY(_parkingAddress.frame) )];
        _detailButton.backgroundColor = [UIColor clearColor];
        [tempView addSubview:_detailButton];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8.f, CGRectGetMaxY(_parkingAddress.frame) + 5.f, CGRectGetWidth(tempView.frame) - 16.f, 2.f)];
        [lineImageView setBackgroundColor:COLOR(228, 228, 228)];
        lineImageView.image = [UIImage imageNamed:@""];
        [tempView addSubview:lineImageView];
        
        _parkingNavigation = [CustomButton1 buttonWithType:UIButtonTypeCustom];
        [_parkingNavigation setImage:[UIImage imageNamed:@"list_navigation"] forState:UIControlStateNormal];
        [_parkingNavigation setTitle:@"导航" forState:UIControlStateNormal];
        _parkingNavigation.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_parkingNavigation setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _parkingNavigation.frame = CGRectMake(0.f, CGRectGetMaxY(lineImageView.frame), CGRectGetWidth(tempView.frame) / 2 - 10.f, 35.f);
        [tempView addSubview:_parkingNavigation];
        
        UIImageView *seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_parkingNavigation.frame), CGRectGetMinY(_parkingNavigation.frame) + 4.f, 2.f, CGRectGetHeight(_parkingNavigation.frame) - 8.f)];
        seperateLine.image = [UIImage imageNamed:@""];
        [seperateLine setBackgroundColor:COLOR(228, 228, 228)];
        [tempView addSubview:seperateLine];
        
        _parkingMyCar = [CustomButton1 buttonWithType:UIButtonTypeCustom];
        [_parkingMyCar setImage:[UIImage imageNamed:@"list_parking"] forState:UIControlStateNormal];
        [_parkingMyCar setTitle:@"停车" forState:UIControlStateNormal];
        _parkingMyCar.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_parkingMyCar setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _parkingMyCar.frame = CGRectMake(CGRectGetMaxX(seperateLine.frame), CGRectGetMinY(_parkingNavigation.frame), CGRectGetWidth(_parkingNavigation.frame), CGRectGetHeight(_parkingNavigation.frame));
        [tempView addSubview:_parkingMyCar];
    }
    return self;
}
@end
