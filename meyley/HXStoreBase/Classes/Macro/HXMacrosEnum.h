//
//  HXSMacros.h
//  store
//
//  Created by chsasaw on 14/10/25.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#ifndef store_HXSMacros_h
#define store_HXSMacros_h

// 登录账号
typedef enum
{
    kHXSSinaWeiboAccount,
    kHXSWeixinAccount,
    kHXSQQAccount,
    kHXSAlipayAccount,
    kHXSUnknownAccount = 99,
}HXSAccountType;

// 分享 结果
typedef NS_ENUM(NSUInteger, HXSShareResult) {
    kHXSShareResultOk = 0,
    kHXSShareResultCancel = 1,
    kHXSShareResultFailed = 2
};

#endif
