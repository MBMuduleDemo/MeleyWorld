//
//  NSObject+additions.h
//  Sunvary
//
//  Created by bocweb on 16/5/15.
//  Copyright © 2016年 bocweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (additions)
/**
 *  判断对象是否为空
 *  PS：nil、NSNil、@""、@0 以上4种返回YES
 *
 *  @return YES 为空  NO 为实例对象
 */
+ (BOOL)isNullOrNilWithObject:(id)object;

@end
