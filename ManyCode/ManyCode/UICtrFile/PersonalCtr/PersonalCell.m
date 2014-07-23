//
//  PersonalCell.m
//  ManyCode
//
//  Created by lichengfei on 14-7-22.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "PersonalCell.h"

@interface PersonalCell ()

@end

@implementation PersonalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self ) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = FONT(17);
        [self.contentView addSubview:_titleLabel];
        
        
         //我是傻逼测试
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 20, 100, 20)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = FONT(12);
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}

@end
