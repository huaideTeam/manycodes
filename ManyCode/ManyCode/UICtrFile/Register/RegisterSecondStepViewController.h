//
//  RegisterSecondStepViewController.h
//  ManyCode
//
//  Created by Zhu Shouyu on 7/25/14.
//  Copyright (c) 2014 lichengfei. All rights reserved.
//

#import "ModelViewController.h"

@interface RegisterSecondStepViewController : ModelViewController

/**
 *  个人用户注册第二步
 *
 *  @param verifyCode 从服务器获取的验证码
 *
 *  @return 用户注册第二步实例
 */
- (instancetype)initWithVerifyCode:(NSString *)verifyCode;
@end
