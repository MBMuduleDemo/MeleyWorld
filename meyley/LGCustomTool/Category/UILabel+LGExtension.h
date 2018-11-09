//
//  UILabel+LGExtension.h
//  jiangxiaoyu
//
//  Created by apple on 17/3/27.
//  Copyright © 2017年 CYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LGExtension)

//快速创建label
+(instancetype)lableWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)color  font:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment  lines:(CGFloat)lines;


@end
