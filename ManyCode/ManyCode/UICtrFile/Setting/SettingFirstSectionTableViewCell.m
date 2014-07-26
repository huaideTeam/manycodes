//
//  SettingFirstSectionTableViewCell.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/26/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "SettingFirstSectionTableViewCell.h"

@implementation SettingFirstSectionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _menuTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, 200.f, 44.f)];
        [_menuTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_menuTitleLabel];
        
        _menuSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(250.f, 7.f, 50.f, 10.f)];
        [_menuSwitch setOnTintColor:[UIColor orangeColor]];
        [self.contentView addSubview:_menuSwitch];
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
