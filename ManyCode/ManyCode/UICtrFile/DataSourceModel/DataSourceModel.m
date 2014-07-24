//
//  DataSourceModel.m
//  ManyCode
//
//  Created by Zhu Shouyu on 7/23/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "DataSourceModel.h"

@implementation DataSourceModel

/**
 *  初始化数据模型 数据测试
 *
 *  @param dictionary 数据源
 */
- (void)initializeTheDataSourceWithDictionary:(NSDictionary *)dictionary {
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"数据源初始化，未定义key:%@,value:%@", key, value);
}

@end

@implementation ParkingListModel

- (void)initializeTheDataSourceWithDictionary:(NSDictionary *)dictionary {
    [super initializeTheDataSourceWithDictionary:dictionary];
    NSArray *carparklist = [dictionary objectForKey:@"carparklist"];
    NSMutableArray *carList = [NSMutableArray array];
    for (NSDictionary *tempDic in carparklist) {
        ParkingItemModel *item = [[ParkingItemModel alloc] init];
        [item setValuesForKeysWithDictionary:tempDic];
        [carList addObject:item];
    }
    self.carparklist = [NSArray arrayWithArray:carList];
}

@end

@implementation ParkingItemModel

@end