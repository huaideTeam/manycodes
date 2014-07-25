//
//  SearchCell.m
//  ManyCode
//
//  Created by lichengfei on 14-7-24.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "SearchCell.h"

@interface SearchCell ()

@end

@implementation SearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        _iconImage.image = [UIImage imageNamed:@"mapButton.png"];
        [self.contentView addSubview:_iconImage];
        
        _cityNameLable = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 230, 20)];
        _cityNameLable.backgroundColor = [UIColor clearColor];
        _cityNameLable.font = FONT(17);
        _cityNameLable.textColor = [UIColor grayColor];
        [self.contentView addSubview:_cityNameLable];
        
        _lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height- 2, 290, 2)];
        _lineImage.backgroundColor = COLOR(228, 228, 228);
        [self.contentView addSubview:_lineImage];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
