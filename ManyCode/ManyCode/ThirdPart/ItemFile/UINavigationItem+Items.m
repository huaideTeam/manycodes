//
//  UINavigationItem+Items.m
//  Meteor
//
//  Created by 常 屹 on 4/30/14.
//  Copyright (c) 2014 常 屹. All rights reserved.
//

#import "UINavigationItem+Items.h"

@implementation UINavigationItem (Items)
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
- (void)setLeftBarButtonItemInIOS7:(UIBarButtonItem *)_leftBarButtonItem
{
    if (_leftBarButtonItem == nil) {
        return;
    }
    
    if (_leftBarButtonItem.customView == nil) {
        [self setLeftBarButtonItems:@[_leftBarButtonItem]];
        return;
    }
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -12;
    if (_leftBarButtonItem){
        [self setLeftBarButtonItems:@[spaceButtonItem, _leftBarButtonItem] animated:YES];
    }  else {
        [self setLeftBarButtonItems:@[spaceButtonItem] animated:YES];
    }
}

- (void)setRightBarButtonItemInIOS7:(UIBarButtonItem *)_rightBarButtonItem
{
    if (_rightBarButtonItem == nil) {
        return;
    }
    
    if (_rightBarButtonItem.customView == nil) {
        [self setRightBarButtonItems:@[_rightBarButtonItem]];
        return;
    }
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -12;
    if (_rightBarButtonItem) {
        [self setRightBarButtonItems:@[spaceButtonItem, _rightBarButtonItem] animated:YES];
    } else   {
        [self setRightBarButtonItems:@[spaceButtonItem] animated:YES];
    }
}
#endif
@end
