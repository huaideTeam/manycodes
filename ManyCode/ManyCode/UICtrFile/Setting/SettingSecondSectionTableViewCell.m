//
//  SettingSecondSectionTableViewCell.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/26/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "SettingSecondSectionTableViewCell.h"

@implementation SettingSecondSectionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _menuTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, 120.f, 44.f)];
        [_menuTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_menuTitleLabel];
        
        _menuDefaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.f, 0.f, 150.f, 44.f)];
        _menuDefaultLabel.textColor = [UIColor lightGrayColor];
        [_menuDefaultLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_menuDefaultLabel];
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
