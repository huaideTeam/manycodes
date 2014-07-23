//
//  KeyboardSegment.m
//  Jewel
//
//  Created by 常 屹 on 13-11-28.
//  Copyright (c) 2013年 常 屹. All rights reserved.
//

#import "KeyboardSegment.h"

@implementation KeyboardSegment
@synthesize buttonTarget;
-(id)initWithTarget:(id)target previousSelector:(SEL)pSelector nextSelector:(SEL)nSelector
{
    self = [super initWithItems:[NSArray arrayWithObjects:@"上一项",@"下一项",nil]];
    if (self)
    {
        [self setSegmentedControlStyle:UISegmentedControlStyleBar];
        
        [self setMomentary:YES];
        [self addTarget:self action:@selector(segmentedControlHandler:) forControlEvents:UIControlEventValueChanged];
        
        
        self.buttonTarget = target;
        perviousAction = pSelector;
        nextAction = nSelector;
    }
    return self;
}

- (void)dealloc
{
    self.buttonTarget = nil;
    perviousAction = 0;
    nextAction = 0;
}

- (void)segmentedControlHandler:(KeyboardSegment *)sender
{
    switch ([sender selectedSegmentIndex])
    {
        case 0:
        {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[buttonTarget class] instanceMethodSignatureForSelector:perviousAction]];
            invocation.target = buttonTarget;
            invocation.selector = perviousAction;
            [invocation invoke];
        }
            break;
        case 1:
        {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[buttonTarget class] instanceMethodSignatureForSelector:nextAction]];
            invocation.target = buttonTarget;
            invocation.selector = nextAction;
            [invocation invoke];
        }
        default:
            break;
    }
}
@end


/*Additional Function*/
@implementation UITextField(ToolbarOnKeyboard)

#pragma mark - Toolbar on UIKeyboard
-(void)addDoneOnKeyboardWithTarget:(id)target action:(SEL)action
{
    @autoreleasepool {
        __weak id tt = target;
        
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        [toolbar setBarStyle:UIBarStyleBlackTranslucent];
        [toolbar sizeToFit];
        
        UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:tt action:action];
        UIBarButtonItem *nilButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolbar setItems:[NSArray arrayWithObjects: nilButton,doneButton, nil]];
        [self setInputAccessoryView:toolbar];
    }
}

-(void)addPreviousNextDoneOnKeyboardWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction doneAction:(SEL)doneAction
{
    @autoreleasepool {
        __weak id tt = target;
        
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        [toolbar setBarStyle:UIBarStyleBlackTranslucent];
        [toolbar sizeToFit];
        
        UIBarButtonItem *nilButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:tt action:doneAction];
        KeyboardSegment *segControl = [[KeyboardSegment alloc] initWithTarget:tt previousSelector:previousAction nextSelector:nextAction];
        UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:segControl];
        [toolbar setItems:[NSArray arrayWithObjects: segButton,nilButton,doneButton, nil]];
        [self setInputAccessoryView:toolbar];
    }
    
    
}

-(void)setEnablePrevious:(BOOL)isPreviousEnabled next:(BOOL)isNextEnabled
{
    UIToolbar *inputView = (UIToolbar*)[self inputAccessoryView];
    if ([inputView isKindOfClass:[UIToolbar class]] && [[inputView items] count]>0){
        UIBarButtonItem *barButtonItem = (UIBarButtonItem*)[[inputView items] objectAtIndex:0];
        if ([barButtonItem isKindOfClass:[UIBarButtonItem class]] && [barButtonItem customView] != nil){
            UISegmentedControl *segmentedControl = (UISegmentedControl*)[barButtonItem customView];
            if ([segmentedControl isKindOfClass:[UISegmentedControl class]] && [segmentedControl numberOfSegments]>1){
                [segmentedControl setEnabled:isPreviousEnabled forSegmentAtIndex:0];
                [segmentedControl setEnabled:isNextEnabled forSegmentAtIndex:1];
            }
        }
    }
}

@end

@implementation UITextView (ToolbarOnKeyboard)

-(void)addDoneOnKeyboardWithTarget:(id)target action:(SEL)action
{
    @autoreleasepool {
        __weak id tt = target;
        
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        [toolbar setBarStyle:UIBarStyleBlackTranslucent];
        [toolbar sizeToFit];
        
        UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:tt action:action];
        UIBarButtonItem *nilButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolbar setItems:[NSArray arrayWithObjects: nilButton,doneButton, nil]];
        [self setInputAccessoryView:toolbar];
    }
}

-(void)addPreviousNextDoneOnKeyboardWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction doneAction:(SEL)doneAction
{
    @autoreleasepool {
        __weak id tt = target;
        
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        [toolbar setBarStyle:UIBarStyleBlackTranslucent];
        [toolbar sizeToFit];
        
        UIBarButtonItem *nilButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:tt action:doneAction];
        KeyboardSegment *segControl = [[KeyboardSegment alloc] initWithTarget:tt previousSelector:previousAction nextSelector:nextAction];
        UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:segControl];
        [toolbar setItems:[NSArray arrayWithObjects: segButton,nilButton,doneButton, nil]];
        [self setInputAccessoryView:toolbar];
    }
    
}

-(void)setEnablePrevious:(BOOL)isPreviousEnabled next:(BOOL)isNextEnabled
{
    UIToolbar *inputView = (UIToolbar*)[self inputAccessoryView];
    if ([inputView isKindOfClass:[UIToolbar class]] && [[inputView items] count]>0){
        UIBarButtonItem *barButtonItem = (UIBarButtonItem*)[[inputView items] objectAtIndex:0];
        if ([barButtonItem isKindOfClass:[UIBarButtonItem class]] && [barButtonItem customView] != nil){
            UISegmentedControl *segmentedControl = (UISegmentedControl*)[barButtonItem customView];
            if ([segmentedControl isKindOfClass:[UISegmentedControl class]] && [segmentedControl numberOfSegments]>1){
                [segmentedControl setEnabled:isPreviousEnabled forSegmentAtIndex:0];
                [segmentedControl setEnabled:isNextEnabled forSegmentAtIndex:1];
            }
        }
    }
}

@end
