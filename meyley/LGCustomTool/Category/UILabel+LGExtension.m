//
//  UILabel+LGExtension.m
//  jiangxiaoyu
//
//  Created by apple on 17/3/27.
//  Copyright © 2017年 CYY. All rights reserved.
//

#import "UILabel+LGExtension.h"

@implementation UILabel (LGExtension)

+(instancetype)lableWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)color font:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment  lines:(CGFloat)lines{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.font = LGFont(font);
    label.textAlignment = textAlignment;
    label.numberOfLines = lines;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    return label;
}





@end
