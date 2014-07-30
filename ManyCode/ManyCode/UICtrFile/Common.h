//
//  Common.h
//  CommonPro
//
//  Created by chengfeili on 14-5-7.
//  Copyright (c) 2014年 大飞哥. All rights reserved.
//

//#define kStatueHeight ([[UIDevice currentDevice] systemVersion].floatValue >=7.0?20:0)
//
//#define kTopImageHeight 45 +kStatueHeight
//
//#define kFullWindowHeight [[UIScreen mainScreen] bounds].size.height //全屏高度
//
//#define kCurrentWindowHeight [[UIScreen mainScreen] applicationFrame].size.height //应用程序界面高度
//
//#define IS_iOS7 ([[UIDevice currentDevice] systemVersion].floatValue >=7.0) //设备系统是否是iOS7


#import <Foundation/Foundation.h>

@interface Common : NSObject

/**
 *  16进制转换成color
 *
 *  @param stringToConvert 字体的颜色值
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *) stringToConvert;


/**
 *  获取字符串的高度
 *
 *  @param string        字符串string
 *  @param font          字符串的字体大小
 *  @param size          字符串显示的size
 *  @param LineBreakMode 字符串显示的方式
 *
 *  @return 字符串的高度
 */
+ (CGFloat)heightForString:(NSString *)string FontSize:(UIFont *)font constrainedSize:(CGSize)size lineBreakMode:(NSLineBreakMode)LineBreakMode;

/**
 *  获取字符串的宽度
 *
 *  @param string        字符串string
 *  @param font          字符串的字体大小
 *  @param size          字符串显示的size
 *  @param LineBreakMode 字符串显示的方式
 *
 *  @return 字符串的宽度
 */
+ (CGFloat)widthForString:(NSString *)string FontSize:(UIFont *)font constrainedSize:(CGSize)size lineBreakMode:(NSLineBreakMode)LineBreakMode;
/**
 *  调用系统拨打电话
 *
 *  @param phoneNum 电话号码字符串
 */
+ (void) makePhoneCall:(NSString *)phoneNum;


/**
 *  图片最适合的尺寸大小
 *
 *  @param apImg         图片
 *  @param constrainSize 显示的大小
 *
 *  @return 图片需要剪切的大小
 */
+ (CGSize)AspectSizeFromImage:(UIImage *)apImg ConstrainWith:(CGSize)constrainSize;


/**
 *  压缩图片
 *
 *  @param img  图片
 *  @param size 压缩的大小
 *
 *  @return UIImage
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

/**
 *  MD5加密
 *
 *  @param srcStr 加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+ (NSString *)MD5FromString:(NSString *)srcStr;


/**
 *  将nsdate转化为字符串
 *
 *  @param date date日期
 *
 *  @return 字符串
 */
+ (NSString *)getDateString:(NSDate *)date;


/**
 *  将nsdate转化为字符串
 *
 *  @param date date日期
 *
 *  @return 字符串
 */
+ (NSDate *)getUTCFormateLocalDate:(NSString *)localDate;

/**
 *  获取手机的mac 地址
 *
 *  @return 唯一的地址字符串
 */
+ (NSString *) macaddress;

/**
 * @brief lengthOfText
 *
 * Detailed 计算text的长度，1个汉字length＋2，1个英文length＋1
 * @param[in] text
 * @param[out]
 * @return int
 * @note
 */
+ (int)lengthOfText:(NSString*)text;


/**
 *  通过文件夹名获取缓存的路径
 *
 *  @param foldName 文件夹名
 *
 *  @return 文件夹缓存的完整路径
 */
+ (NSString *)getCachePathWithFolor:(NSString *)foldName;

/**
 *  跳转到appstore
 */
+ (void) jumpToAppStoreAndMarkApp;

/**
 *  检查版本更新
 *
 *  @param isShowAlert
 */
+ (void) checkUpdateVersion:(BOOL)isShowAlert;

/**
 *  判断有没有网络
 *
 *  @return int
 */
+ (int) isHasNetWork;

/**
 *  流量统计
 *
 *  @return string
 */
+ (NSString *)getTotalBytes;

/**
 *  获取本地的wifi列表
 *
 *  @return nsdic
 */
+ (NSDictionary *)fetchSSIDInfo;

@end
