//
//  UIColor+Hex.h
//  颜色常识
//
//  Created by yz on 15/12/15.
//  Copyright © 2015年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LGExtension)

// 默认alpha位1
+ (UIColor *)colorWithString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithString:(NSString *)color alpha:(CGFloat)alpha;

@end
