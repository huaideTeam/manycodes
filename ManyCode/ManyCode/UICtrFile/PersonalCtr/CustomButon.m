//
//  CustomButon.m
//  ManyCode
//
//  Created by lichengfei on 14-7-29.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "CustomButon.h"

@implementation CustomButon

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _titleImageView.backgroundColor = [UIColor clearColor];
        _titleImageView.layer.masksToBounds = YES;
        _titleImageView.layer.cornerRadius = self.bounds.size.height/2;
        [self addSubview:_titleImageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
