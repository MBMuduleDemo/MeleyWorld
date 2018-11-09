//
//  NSObject+additions.m
//  Sunvary
//
//  Created by bocweb on 16/5/15.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import "NSObject+additions.h"

@implementation NSObject (additions)

+ (BOOL)isNullOrNilWithObject:(id)object;
{
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return NO;
        } else {
            return NO;
        }
    }
    
    return NO;
}

@end
