//
//  Common.m
//  CommonPro
//
//  Created by chengfeili on 14-5-7.
//  Copyright (c) 2014年 大飞哥. All rights reserved.
//

#import "Common.h"
#import "BlockUI.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "Reachability.h"

@implementation Common

/**
 *  16进制转换成color
 *
 *  @param stringToConvert 字体的颜色值
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

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
+ (CGFloat)heightForString:(NSString *)string FontSize:(UIFont *)font constrainedSize:(CGSize)size lineBreakMode:(NSLineBreakMode)LineBreakMode
{
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:string];
    NSRange range = NSMakeRange(0, attrStr.length);
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    CGRect sizeToFit = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return sizeToFit.size.height;
}

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
+ (CGFloat)widthForString:(NSString *)string FontSize:(UIFont *)font constrainedSize:(CGSize)size lineBreakMode:(NSLineBreakMode)LineBreakMode
{
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:string];
    NSRange range = NSMakeRange(0, attrStr.length);
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    CGRect sizeToFit = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return sizeToFit.size.width;
}
/**
 *  调用系统拨打电话
 *
 *  @param phoneNum 电话号码字符串
 */
+ (void) makePhoneCall:(NSString *)phoneNum
{
    if (phoneNum.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"无号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    NSString *telString = [NSString stringWithFormat:@"tel://%@",phoneNum];
    NSURL *telURL = [NSURL URLWithString:telString];
    if ([[UIApplication sharedApplication] canOpenURL:telURL]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"是否拨打电话:%@",phoneNum] message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex != 0) {
                [[UIApplication sharedApplication] openURL:telURL];
            }
        }];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"" message:@"当前设备不支持电话功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }

}


/**
 *  图片最适合的尺寸大小
 *
 *  @param apImg         图片
 *  @param constrainSize 显示的大小
 *
 *  @return 图片需要剪切的大小
 */
+ (CGSize)AspectSizeFromImage:(UIImage *)apImg ConstrainWith:(CGSize)constrainSize
{
    CGSize newSize = CGSizeMake(0, 0);
    CGFloat wScaleRate = apImg.size.width/constrainSize.width;
    CGFloat hScaleRate = apImg.size.height/constrainSize.height;
    CGFloat imgScaleRate = MAX(wScaleRate, hScaleRate);
    if (imgScaleRate<1.0) {
        return constrainSize;
    }
    if (imgScaleRate>0) {
        newSize.width = apImg.size.width/imgScaleRate;
        newSize.height = apImg.size.height/imgScaleRate;
    }
    return newSize;
}


/**
 *  压缩图片
 *
 *  @param img  图片
 *  @param size 压缩的大小
 *
 *  @return UIImage
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

/**
 *  MD5加密
 *
 *  @param srcStr 加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+ (NSString *)MD5FromString:(NSString *)srcStr
{
    NSString *tempString = [NSString stringWithFormat:@"fae@#&* %@ artdore,art",srcStr];
    const char *cStr = [tempString UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];

}

/**
 *  将nsdate转化为字符串
 *
 *  @param date date日期
 *
 *  @return 字符串
 */
+ (NSString *)getDateString:(NSDate *)date
{
    NSString *format = @"yyyy-MM-dd HH:mm:ss";
    NSTimeZone *localZone = [NSTimeZone systemTimeZone];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:localZone];
	NSString* dateStr = [formatter stringFromDate:date];
	return dateStr;
}

/**
 *  获取手机的mac 地址
 *
 *  @return 唯一的地址字符串
 */
+ (NSString *) macaddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"x:x:x:x:x:x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    NSString *tempString = [NSString stringWithFormat:@"ios-%@",[outstring uppercaseString]];
    return tempString;
}


/**
 * @brief lengthOfText
 *
 * Detailed 计算text的长度，1个汉字length＋2，1个英文length＋1
 * @param[in] text
 * @param[out]
 * @return int
 * @note
 */
+ (int)lengthOfText:(NSString*)text
{
    long len = [text length];
    int lenthText = 0;
    for (int i = 0; i < len; i++) {
        unichar t = [text characterAtIndex:i];
        // 汉字，标点符号
        if ((t >= 0x4e00 && t <= 0x9fff) || (t >= 0x3000 && t <= 0x303f) || (t >= 0xff00 && t <= 0xffef)) {
            lenthText += 2;
        }
        else {
            lenthText++;
        }
    }
    return lenthText;
}


/**
 *  通过文件夹名获取缓存的路径
 *
 *  @param foldName 文件夹名
 *
 *  @return 文件夹缓存的完整路径
 */
+ (NSString *)getCachePathWithFolor:(NSString *)foldName
{
    BOOL isDir = YES;
    NSError *error = nil;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches"];
    if (foldName) {
        path = [path stringByAppendingPathComponent:foldName];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"Catch Error while create path %@",error);
            return nil;
        }
    }
    return path;
}


+ (void) jumpToAppStoreAndMarkApp
{
    if (IOS7) {
        NSString *str = @"itms-apps://itunes.apple.com/app/id839908137";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }else{
        NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=839908137";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }
}

/**
 *  检查版本更新
 *
 *  @param isShowAlert
 */
+ (void) checkUpdateVersion:(BOOL)isShowAlert
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%d",1233]]];
        
        [request setHTTPMethod:@"GET"];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        if (!returnData) {
            return;
        }
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
        if ([jsonData[@"results"] count] == 0) {
            return;
        }
        NSString *latestVersion = jsonData[@"results"][0][@"version"];
        
        NSDictionary *appInfoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *version = [appInfoDict objectForKey:@"CFBundleVersion"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([latestVersion isEqualToString:version] && isShowAlert) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已是最新版本" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if (latestVersion.floatValue > version.floatValue)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有最新版本可更新" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [Common jumpToAppStoreAndMarkApp];
                    }
                }];
            }
        });
    });
}


/**
 *  判断有没有网络
 *
 *  @return int
 */
+ (int) isHasNetWork
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NSLog(@"%d",[r currentReachabilityStatus]);
    return [r currentReachabilityStatus];
}


//流量统计
+ (NSString *)getTotalBytes
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)
    {
        return 0;
    }
    
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        
        if (ifa->ifa_data == 0)
            continue;
        
        if (!strcmp(ifa->ifa_name, "pdp_ip0"))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
            NSLog(@"%s :iBytes is %d, oBytes is %d",
                  ifa->ifa_name, iBytes, oBytes);
        }
    }
    freeifaddrs(ifa_list);
    
    int totalBytes = iBytes+oBytes;
    
    if(totalBytes < 1024)     // B
    {
        return [NSString stringWithFormat:@"%dB", totalBytes];
    }
    else if(totalBytes >= 1024 && totalBytes < 1024 * 1024) // KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)totalBytes / 1024];
    }
    else if(totalBytes >= 1024 * 1024 && totalBytes < 1024 * 1024 * 1024)   // MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)totalBytes / (1024 * 1024)];
    }
    else    // GB
    {
        return [NSString stringWithFormat:@"%.3fGB", (double)totalBytes / (1024 * 1024 * 1024)];
    }
}
@end
