//
//  HomeListView.h
//  ManyCode
//
//  Created by lichengfei on 14-7-23.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeEventDelegate.h"

@interface HomeListView : UIView

@property (nonatomic, assign)id<HomeEventDelegate>delegate;

/**
 *  更新界面
 *
 *  @param parkingList 停车场列表
 */
- (void)refreshParkingList:(NSArray *)parkingList;

//取消loading
- (void)endFreshLoading;

@end
