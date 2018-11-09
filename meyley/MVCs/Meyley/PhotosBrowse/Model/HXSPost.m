//
//  HXSPost.m
//  store
//
//  Created by 格格 on 16/4/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPost.h"


@implementation HXSLike

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;
{
    return [[HXSLike alloc] initWithDictionary:object error:nil];
}

@end


@implementation HXSComment

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSComment alloc] initWithDictionary:object error:nil];
}

@end



@implementation HXSPost

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSPost alloc] initWithDictionary:object error:nil];
}

@end
