//
//  ExproAnnotation.h
//  PhoneShop
//
//  Created by chengfeili on 13-11-1.
//  Copyright (c) 2013年 Christ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface ExproAnnotation : NSObject<BMKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic,assign) NSInteger tag;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@end
