//
//  HXSUserBasicInfo.m
//  store
//
//  Created by chsasaw on 14/10/27.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSUserBasicInfo.h"

@implementation HXSUserBasicInfo

- (NSString *)getSexString {
    return self.sex ? (self.sex.integerValue == 0 ? @"男":@"女") : @"保密";
}

@end
