//
//  UIView+Extensions.h
//  CSLeftSlideDemo
//
//  Created by LCS on 16/2/13.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extensions)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize  size;

/**设置圆角*/
@property (nonatomic,assign)IBInspectable CGFloat cornerRidus;

/** 获取view所在的controller */
-(UIViewController *)getViewController;

/** 判断self和anotherView是否重叠 */
- (BOOL)hu_intersectsWithAnotherView:(UIView *)anotherView;


@end
