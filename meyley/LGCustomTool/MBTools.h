//
//  MBTools.h
//  meyley
//
//  Created by Bovin on 2018/9/11.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBTools : NSObject

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

+ (instancetype)shareTools;

+(NSMutableAttributedString *)typeString:(NSString *)typeString typeStringColor:(UIColor *)typeColor valueString:(NSString *)valueString valueStringColor:(UIColor *)valueColor;

+(NSMutableAttributedString *)typeString:(NSString *)typeString typeStringColor:(UIColor *)typeColor typeStringFont:(UIFont *)typeFont valueString:(NSString *)valueString valueStringColor:(UIColor *)valueColor valueStringFont:(UIFont *)valueFont;

+ (BOOL)checkMobileIsTrue:(NSString *)mobile;

+ (NSDate *)transformDateFromDateString:(NSString *)dateString;

+ (NSString *)transFormDateStringFormTimeInterval:(id)interval;
@end
