//
//  TooltipView.h
//  haoshuimian
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 CYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TooltipView : UIView

+(void)showMessage:(NSString *)message offset:(CGFloat)offset;

+(void)showAlertView:(NSString *)title content:(NSString *)content offset:(CGFloat)offset;

+(void)showAlertView:(NSString *)title content:(NSString *)content offset:(CGFloat)offset rotation:(BOOL)rotation;

@end
