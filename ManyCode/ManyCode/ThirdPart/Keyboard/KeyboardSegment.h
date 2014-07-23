//
//  KeyboardSegment.h
//  Meteor
//
//  Created by 常 屹 on 4/10/14.
//  Copyright (c) 2014 常 屹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardSegment : UISegmentedControl {
    __weak id  buttonTarget;
    
    SEL perviousAction;
    SEL nextAction;
}

-(id)initWithTarget:(id)target previousSelector:(SEL)pSelector nextSelector:(SEL)nSelector;
@property (nonatomic, weak) id buttonTarget;
@end



@interface UITextField (ToolbarOnKeyboard)

-(void)addDoneOnKeyboardWithTarget:(id)target action:(SEL)action;

-(void)addPreviousNextDoneOnKeyboardWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction doneAction:(SEL)doneAction;

-(void)setEnablePrevious:(BOOL)isPreviousEnabled next:(BOOL)isNextEnabled;
@end

@interface UITextView (ToolbarOnKeyboard)

-(void)addDoneOnKeyboardWithTarget:(id)target action:(SEL)action;

-(void)addPreviousNextDoneOnKeyboardWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction doneAction:(SEL)doneAction;

-(void)setEnablePrevious:(BOOL)isPreviousEnabled next:(BOOL)isNextEnabled;
@end