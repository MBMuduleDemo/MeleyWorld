//
//  NSDate+Meyley.m
//  meyley
//
//  Created by chsasaw on 2017/3/4.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "NSDate+Meyley.h"

@implementation NSDate (Meyley)

- (NSString *)meyleyFormatString {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *todayDateString = [dateFormatter stringFromDate:today];
    
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *selfString = [dateFormatter stringFromDate:self];
    
    return [selfString stringByReplacingOccurrencesOfString:todayDateString withString:@""];
}

@end
