//
//  CalendarView.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/26/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "CalendarView.h"

@interface CalendarButton : UIButton

@property (nonatomic, strong) NSDate *date;         //该按钮对应的日期

@end

@implementation CalendarButton

@end

@interface CalendarView ()

@property (nonatomic, strong) NSCalendar *gregorian;

@property (nonatomic) NSInteger currentMonth;

@property (nonatomic) NSInteger currentYear;

@property (nonatomic) NSInteger currentDay;

@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic) NSInteger forwardSelectedIndex;

@end

@implementation CalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureRecognizer:)];
        swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeleft];
        
        UISwipeGestureRecognizer * swipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureRecognizer:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRight];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self initializeTheParameters];
    NSLog(@"---%@", self.selectedDate);
    NSDateComponents *components = [self.gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.currentChoosedDate];
    components.day = 1;
    NSDate *firstDayOfMonth = [self.gregorian dateFromComponents:components];
    NSDateComponents *comps = [self.gregorian components:NSWeekdayCalendarUnit fromDate:firstDayOfMonth];
    int weekday = [comps weekday];
    weekday  = weekday - 1;
    
    if(weekday < 0) {
        weekday += 7;
    }
    NSCalendar *currentMonth = [NSCalendar currentCalendar];
    NSRange days = [currentMonth rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:self.currentChoosedDate];
    
    
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 64.f)];
    titleImageView.backgroundColor = COLOR(97, 89, 77);
    [self addSubview:titleImageView];

     NSDateComponents *currentCommpent1 = [_gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.selectedDate];
    NSDateComponents *currentCommpent = [_gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.currentChoosedDate];
    NSInteger day = currentCommpent1.day;
    NSInteger month = currentCommpent.month;
    
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 10.f, 100.f, 20.f)];
    [_dayLabel setBackgroundColor:[UIColor clearColor]];
    _dayLabel.font = [UIFont boldSystemFontOfSize:18.f];
    _dayLabel.textColor = [UIColor whiteColor];
    _dayLabel.text = [NSString stringWithFormat:@"%d", day];
    [titleImageView addSubview:_dayLabel];
    
    if (self.selectedDate!=self.currentChoosedDate) {
        _dayLabel.hidden = YES;
    } else
    {
        _dayLabel.hidden = NO;
    }
    
    _months = @[@"", @"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"Septemper", @"October", @"November", @"December"];
    _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_dayLabel.frame), CGRectGetMaxY(_dayLabel.frame), CGRectGetWidth(_dayLabel.frame), CGRectGetHeight(_dayLabel.frame))];
    [_monthLabel setBackgroundColor:[UIColor clearColor]];
    _monthLabel.font = [UIFont boldSystemFontOfSize:18.f];
    _monthLabel.textColor = [UIColor whiteColor];
    _monthLabel.text = [NSString stringWithFormat:@"%@", _months[month]];
    [titleImageView addSubview:_monthLabel];
    
    NSInteger columns = 7;
    CGFloat width = CGRectGetWidth(self.bounds) / columns;
    CGFloat height = 26.f;
    CGFloat originY = CGRectGetMaxY(titleImageView.frame);
    NSInteger monthLength = days.length;

    //添加星期
    UIView *weekView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, CGRectGetWidth(self.bounds), height)];
    [weekView setBackgroundColor:COLOR(246, 248, 250)];
    [self addSubview:weekView];
    
    NSArray *weekNames = @[@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"];
    for (int i =0; i < weekNames.count; i++) {
        UILabel *weekNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((width * (i % columns)), 0.f, width, height)];
        weekNameLabel.textAlignment = NSTextAlignmentCenter;
        weekNameLabel.textColor = COLOR(197, 100, 40);
        weekNameLabel.text = weekNames[i];
        weekNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
        [weekView addSubview:weekNameLabel];
    }
    
    UIImageView *daysImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, originY + height, CGRectGetWidth(self.bounds), height * ceil(monthLength / 7.f) * 2)];
    daysImageView.tag = 1UL << 6;
    [daysImageView setBackgroundColor:[UIColor whiteColor]];
    daysImageView.userInteractionEnabled = YES;
    [self addSubview:daysImageView];
    originY = 0.f;
    CGFloat daysImageViewHeight = 0.f;
    
    //上一个月的
    NSDateComponents *previousMonthComponents = [_gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.currentChoosedDate];
    previousMonthComponents.month -= 1;
    previousMonthComponents.day = 20;
    NSDate *previousMonthDate = [_gregorian dateFromComponents:previousMonthComponents];
    NSRange previousMonthDays = [currentMonth rangeOfUnit:NSDayCalendarUnit
                                                   inUnit:NSMonthCalendarUnit
                                                  forDate:previousMonthDate];
    NSLog(@"上一个月的长度:%@----%@------%@", NSStringFromRange(previousMonthDays), previousMonthDate, self.currentChoosedDate);
    NSInteger maxDate = previousMonthDays.length - weekday;
    CGFloat maxX = 0.f;
    CGFloat minY = 0.f;
    for (int i = 0; i < weekday; i++) {
        CalendarButton *button = [self calendarButton];
        [button setTitle:[NSString stringWithFormat:@"%d",maxDate + i + 1] forState:UIControlStateNormal];
        button.date = [self dateForMonth:-1 day:maxDate + i + 1];
        button.tag = 1000 + i;
        if ([self compareDate:button.date toDate:self.selectedDate]) {
            button.selected = YES;
            self.forwardSelectedIndex = button.tag;
        }
        [button setFrame:CGRectMake(maxX, originY, width, height)];
        [daysImageView addSubview:button];
        maxX = CGRectGetMaxX(button.frame);
        minY = CGRectGetMinY(button.frame);
    }
    
    for (NSInteger i= 0; i < monthLength; i++)
    {
        CalendarButton *button = [self calendarButton];
        button.tag = i + 2000;
        [button setTitle:[NSString stringWithFormat:@"%d",i + 1] forState:UIControlStateNormal];
        button.date = [self dateForMonth:0 day:i];
        maxX = ((i + weekday) % 7) * width;
        minY = ((i + weekday) / 7) * height;
        [button setFrame:CGRectMake(maxX, minY, width, height)];
        if ([self compareDate:button.date toDate:self.selectedDate]) {
            button.selected = YES;
            self.forwardSelectedIndex = button.tag;
        }
        [daysImageView addSubview:button];
        daysImageViewHeight = CGRectGetMaxY(button.frame);
    }
    maxX += width;
    for (NSInteger index = 0; maxX < CGRectGetWidth(self.bounds) - width; index ++) {
        CalendarButton *button = [self calendarButton];
        button.date = [self dateForMonth:1 day:index + 1];
        button.tag = 3000 + index;
        if ([self compareDate:button.date toDate:self.selectedDate]) {
            button.selected = YES;
            self.forwardSelectedIndex = button.tag;
        }
        [button setTitle:[NSString stringWithFormat:@"%d",index + 1] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(maxX, minY, width, height)];
        [daysImageView addSubview:button];
        maxX += width;
    }
    CGRect frame = daysImageView.frame;
    frame.size.height = daysImageViewHeight;
    daysImageView.frame = frame;
}

#pragma mark - choose a date 
- (void)chooseDateClickedMethod:(CalendarButton *)sender {
    NSLog(@"---%@－－－－%d", sender.date, self.forwardSelectedIndex);
    UIImageView *tempImageView = (UIImageView *)[self viewWithTag:1UL << 6];
    CalendarButton *tempButton = (CalendarButton *)[tempImageView viewWithTag:self.forwardSelectedIndex];
    tempButton.selected = NO;
    sender.selected = YES;
    self.forwardSelectedIndex = sender.tag;
    self.selectedDate = sender.date;
    if (self.choosedSomeDate) {
        self.choosedSomeDate(self);
    }
}

- (NSDate *)dateForMonth:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *components = [_gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.currentChoosedDate];
    if (0 == month) {
        components.day = day + 1;
    } else if (-1 == month) {
        components.day = day + 1;
    } else if (1 == month) {
        components.day = day + 1;
    }
    
    components.month += month;
    return [_gregorian dateFromComponents:components];
}

#pragma mark - UIGestureRecognizer

-(void)swipeGestureRecognizer:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSDateComponents *components = [_gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.currentChoosedDate];
        components.day = 1;
        components.month += 1;
        self.currentChoosedDate = [_gregorian dateFromComponents:components];
        [UIView transitionWithView:self
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^ { [self setNeedsDisplay]; }
                        completion:nil];
        
    } else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSDateComponents *components = [_gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.currentChoosedDate];
        components.day = 1;
        components.month -= 1;
        self.currentChoosedDate = [_gregorian dateFromComponents:components];
        [UIView transitionWithView:self
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^ { [self setNeedsDisplay]; }
                        completion:nil];
    }
}

#pragma mark - 初始化参数 
- (void)initializeTheParameters {
    if (nil == _gregorian) {
        self.selectedDate = self.currentChoosedDate;
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [_gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.currentChoosedDate];
        _currentDay  = components.day;
        _currentMonth = components.month;
        _currentYear = components.year;
    }
}

- (CalendarButton *)calendarButton {
    CalendarButton *button = [CalendarButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:COLOR(169, 175, 185) forState:UIControlStateNormal];
    [button setTitleColor:COLOR(197, 100, 40) forState:UIControlStateSelected];
    [button addTarget:self action:@selector(chooseDateClickedMethod:) forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
    return button;
}

#pragma mark - 比较两个日期是否相等
- (BOOL)compareDate:(NSDate *)firstDate toDate:(NSDate *)secondDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *firstDateCom = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:firstDate];
    NSDateComponents *secondDateCom = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:secondDate];
    BOOL result = firstDateCom.day == secondDateCom.day && firstDateCom.month == secondDateCom.month && firstDateCom.year == secondDateCom.year;
    return result;
}
@end
