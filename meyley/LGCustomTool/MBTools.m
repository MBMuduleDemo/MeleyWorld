//
//  MBTools.m
//  meyley
//
//  Created by Bovin on 2018/9/11.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "MBTools.h"

static MBTools *_tools;
@implementation MBTools

+ (instancetype)shareTools {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tools = [[MBTools alloc]init];
    });
    return _tools;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc]init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    }
    return self;
}

+ (NSMutableAttributedString *)typeString:(NSString *)typeString typeStringColor:(UIColor *)typeColor valueString:(NSString *)valueString valueStringColor:(UIColor *)valueColor {
    if (!typeString.length) {
        typeString = @"";
    }
    
    if (!valueString.length) {
        valueString = @"";
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",typeString,valueString]];
    
    [str addAttribute:NSForegroundColorAttributeName value:typeColor range:NSMakeRange(0,typeString.length)];
    [str addAttribute:NSForegroundColorAttributeName value:valueColor range:NSMakeRange(typeString.length,valueString.length)];
    
    return str;
}
+ (NSMutableAttributedString *)typeString:(NSString *)typeString typeStringColor:(UIColor *)typeColor typeStringFont:(UIFont *)typeFont valueString:(NSString *)valueString valueStringColor:(UIColor *)valueColor valueStringFont:(UIFont *)valueFont {
    if (!typeString.length) {
        typeString = @"";
    }
    
    if (!valueString.length) {
        valueString = @"";
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",typeString,valueString]];
    [str addAttributes:@{NSForegroundColorAttributeName:typeColor,NSFontAttributeName:typeFont} range:NSMakeRange(0,typeString.length)];
    [str addAttributes:@{NSForegroundColorAttributeName:valueColor,NSFontAttributeName:valueFont} range:NSMakeRange(typeString.length,valueString.length)];
    
    return str;
}
//验证手机号码
+ (BOOL)checkMobileIsTrue:(NSString *)mobile {
    
    NSString *mobileFormat = @"^(0|86|17951)?(13[0-9]|15[0-9]|[16[0-9]]|17[0-9]|18[0-9]|14[57]|19[0-9])[0-9]{8}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileFormat];
    return [mobileTest evaluateWithObject:mobile];
    
}
+ (NSDate *)transformDateFromDateString:(NSString *)dateString {
    
    NSDate *date = [[MBTools shareTools].dateFormatter dateFromString:dateString];
    return date;
}
+ (NSString *)transFormDateStringFormTimeInterval:(id)interval {
    NSString *dateString = nil;
    NSTimeInterval timeInterval = [interval doubleValue];
    NSDate *theDate = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000.0];
    dateString = [[MBTools shareTools].dateFormatter stringFromDate:theDate];
    return dateString;
}
@end
