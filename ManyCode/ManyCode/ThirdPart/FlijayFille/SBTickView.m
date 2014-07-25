//
//  SBTickView.m
//  SBTickerViewDemo
//
//  Created by Simon Blommegård on 2011-12-10.
//  Copyright (c) 2011 Simon Blommegård. All rights reserved.
//

#import "SBTickView.h"

@implementation SBTickView
@synthesize title = _title;
@synthesize fontSize = _fontSize;
@synthesize backColor = _backColor;
@synthesize titleColor = _titleColor;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackColor:[UIColor colorWithRed:0.173 green:0.176 blue:0.173 alpha:1.000]];
        [self setTitleColor:[UIColor colorWithWhite:0.7 alpha:1.000]];
        [self setBackgroundColor:[UIColor clearColor]];
        
//        self.backImage = [[UIImageView alloc] initWithFrame:self.bounds];
        [self setFontSize:50.];
    }
    return self;
}

+ (id)tickViewWithTitle:(NSString *)title fontSize:(CGFloat)fontSize {
    SBTickView *view = [[SBTickView alloc] initWithFrame:CGRectZero];
    [view setTitle:title];
    [view setFontSize:fontSize];
    return view;
}
- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 1., 1.)
                                                    cornerRadius:2.];
    [self.backColor set];
    [path fill];
    
    [self.titleColor set];
    
    NSMutableArray* filenames = [NSMutableArray arrayWithCapacity: 10];
	for (int i = 0; i < 10; i++) {
		[filenames addObject: [NSString stringWithFormat: @"%d.png", i]];
	}
    
    NSString *imageName = [filenames objectAtIndex:[self.title integerValue]];
    UIImage *image = [UIImage imageNamed:imageName];
    
    [image drawInRect:self.bounds];
    
//    [self.title drawInRect:self.bounds withFont:[UIFont boldSystemFontOfSize:_fontSize]
//             lineBreakMode:UILineBreakModeTailTruncation
//                 alignment:UITextAlignmentCenter];  
}

@end
