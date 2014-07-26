//
//  CalendarView.h
//  ManyCode
//
//  Created by Zhu Shouyu on 7/26/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarView;
typedef void (^CalendarSelectedSomeDate)(CalendarView *view);       //选择某个日期的时候的处理回调函数

@interface CalendarView : UIView

@property (nonatomic, strong) NSDate *currentChoosedDate;           //初始化显示的日期

@property (nonatomic, readonly) NSDate *selectedDate;                 //用户选择的日期

@property (nonatomic, strong) CalendarSelectedSomeDate choosedSomeDate; //选中某个日期回调函数

@end
