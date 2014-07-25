//
//  MapFootView.m
//  ManyCode
//
//  Created by lichengfei on 14-7-24.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "MapFootView.h"

@implementation MapFootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(9.f, 0.f, 297.f, frame.size.height)];
        tempView.backgroundColor = [UIColor whiteColor];
        [self addSubview:tempView];
        
        _parkingName = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 2.f, 200.f, 20.f)];
        [_parkingName setBackgroundColor:[UIColor clearColor]];
        _parkingName.font = FONT(16);
        _parkingName.textColor = COLOR(110, 110, 110);
        [tempView addSubview:_parkingName];
        
        _parkingDistance = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(tempView.frame) - 100.f, 0, 90.f, CGRectGetHeight(_parkingName.frame))];
        [_parkingDistance setBackgroundColor:[UIColor clearColor]];
        _parkingDistance.textAlignment = NSTextAlignmentRight;
        _parkingDistance.font = FONT(12);
        _parkingDistance.textColor =  COLOR(159, 159, 159);
        [tempView addSubview:_parkingDistance];
        
        _parkingAddress = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_parkingName.frame), CGRectGetMaxY(_parkingName.frame), 250.f, 20.f)];
        [_parkingAddress setBackgroundColor:[UIColor clearColor]];
        _parkingAddress.textColor = COLOR(159, 159, 159);
        _parkingAddress.font = FONT(12);
        [tempView addSubview:_parkingAddress];
        
        _detailButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(tempView.frame) - 80.f, 20,70.f, 20)];
        [_detailButton setBackgroundColor:[UIColor clearColor]];
        _detailButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [_detailButton setTitle:@"详情" forState:UIControlStateNormal];
        [_detailButton setTitleColor:COLOR(67, 147, 183) forState:UIControlStateNormal];
        _detailButton.titleLabel.font = FONT(15);
        [_detailButton setTitleColor:COLOR(67, 147, 183) forState:UIControlStateHighlighted];
        
        UIImageView *detailIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 6, 10)];
        detailIcon.image = [UIImage imageNamed:@"详情图标.png"];
        [_detailButton addSubview:detailIcon];
        [tempView addSubview:_detailButton];

        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8.f, CGRectGetMaxY(_parkingAddress.frame), CGRectGetWidth(tempView.frame) - 16.f, 2.f)];
        lineImageView.backgroundColor = COLOR(228, 228, 228);
        [tempView addSubview:lineImageView];
        
        _parkingNavigation = [UIButton buttonWithType:UIButtonTypeCustom];
        _parkingNavigation.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _parkingNavigation.backgroundColor = [UIColor clearColor];
        [_parkingNavigation setTitle:@"导航" forState:UIControlStateNormal];
        [_parkingNavigation setTitleColor:COLOR(160, 160, 160) forState:UIControlStateNormal];
         [_parkingNavigation setTitleColor:COLOR(160, 160, 160) forState:UIControlStateHighlighted];
        _parkingNavigation.frame = CGRectMake(0.f, CGRectGetMaxY(lineImageView.frame), CGRectGetWidth(tempView.frame)/2 -4, 35.f);
        
        UIImageView *navIcon = [[UIImageView alloc] initWithFrame:CGRectMake(43, 10, 14, 13)];
        navIcon.image = [UIImage imageNamed:@"list_navigation@2x.png"];
        [_parkingNavigation addSubview:navIcon];
        
        [tempView addSubview:_parkingNavigation];
        
        UIImageView *seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_parkingNavigation.frame), CGRectGetMinY(_parkingNavigation.frame) + 4.f, 2.f, CGRectGetHeight(_parkingNavigation.frame) - 4.f)];
        seperateLine.backgroundColor = COLOR(228, 228, 228);
        [tempView addSubview:seperateLine];
        
        _parkingMyCar = [UIButton buttonWithType:UIButtonTypeCustom];
        [_parkingMyCar setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _parkingMyCar.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [_parkingMyCar setTitle:@"停车" forState:UIControlStateNormal];
        [_parkingMyCar setTitleColor:COLOR(160, 160, 160) forState:UIControlStateNormal];
        [_parkingMyCar setTitleColor:COLOR(160, 160, 160) forState:UIControlStateHighlighted];
        _parkingMyCar.backgroundColor = [UIColor clearColor];
        _parkingMyCar.frame = CGRectMake(CGRectGetMaxX(seperateLine.frame), CGRectGetMinY(_parkingNavigation.frame), CGRectGetWidth(_parkingNavigation.frame), CGRectGetHeight(_parkingNavigation.frame));
        
        UIImageView *carIcon = [[UIImageView alloc] initWithFrame:CGRectMake(43, 10, 14, 13)];
        carIcon.image = [UIImage imageNamed:@"list_parking@2x.png"];
        [_parkingMyCar addSubview:carIcon];
        [tempView addSubview:_parkingMyCar];
    }
    return self;
}


@end
