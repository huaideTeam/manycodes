//
//  DataSourceModel.h
//  ManyCode
//
//  Created by Zhu Shouyu on 7/23/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSourceModel : NSObject

@property (nonatomic, strong) NSString *sessionid;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *statusCode;

/**
 *  初始化数据模型
 *
 *  @param dictionary 数据源
 */
- (void)initializeTheDataSourceWithDictionary:(NSDictionary *)dictionary;
@end


@interface ParkingListModel : DataSourceModel

@property (nonatomic, strong) NSArray *carparklist;         //停车场列表，每一个元素是

@end

@interface ParkingItemModel : DataSourceModel

@property (nonatomic, strong) NSString *carparkid;
@property (nonatomic, strong) NSString *carparkname;
@property (nonatomic, strong) NSString *gps_lon;
@property (nonatomic, strong) NSString *gps_lat;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *spacestotal;
@property (nonatomic, strong) NSString *spacessurplus;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *images;

@end

//缴费记录
@interface ConsumptionHistoryModel : DataSourceModel

@property (nonatomic, strong) NSArray *banchglist;

@end

@interface ConsumptionHistoryItemModel : DataSourceModel

@property (nonatomic, strong) NSString *chgtype;
@property (nonatomic, strong) NSString *chgtime;
@property (nonatomic, strong) NSString *chginfo;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *remark;

@end