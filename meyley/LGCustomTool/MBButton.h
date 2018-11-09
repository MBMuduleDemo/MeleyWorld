//
//  MBButton.h
//  MBTodayNews
//
//  Created by Bovin on 2017/11/14.
//  Copyright © 2017年 Bovin. All rights reserved.
//

#import <UIKit/UIKit.h>
//按钮图片与标题位置枚举
typedef NS_ENUM(NSUInteger, MBButtonType) {
    MBButtonTypeTopImageBottomTitle,    //图上标题下
    MBButtonTypeLeftImageRightTitle,    //图左标题右
    MBButtonTypeBottomImageTopTitle,    //图下标题上
    MBButtonTypeRightImageLeftTitle,    //图右标题左
};

typedef NS_ENUM(NSUInteger, MBButtonAlignment) {
    MBButtonAlignmentDefault,       //默认图标与文字居中显示
    MBButtonAlignmentCustom,        //自定义设置图片与标题的位置
};

@interface MBButton : UIButton
//按钮图片与标题的位置类型
@property (nonatomic, assign) MBButtonType type;
//按钮内容显示的方式
@property (nonatomic, assign) MBButtonAlignment textAlignment;
//图片与标题之间的距离
@property (nonatomic, assign) CGFloat spaceMargin;
//横向边距,默认均为0;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;
//纵向边距,默认均为0;
@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, assign) CGFloat bottomMargin;
//设置可点击范围，仅支持扩大点击范围 CGFloat top, left, bottom, right 设置上下左右数值扩大对应方向上的点击区域。
@property (nonatomic, assign) UIEdgeInsets hitInset;

/**
 创建图片与标题共存的按钮

 @param frame 按钮的位置及大小坐标
 @param bgColor 按钮的背景颜色
 @param title 按钮的标题
 @param titleColor 按钮标题颜色
 @param image 按钮图片
 @param selectImage 按钮选中及高亮时图片
 @param target 监听响应的对象
 @param SEL 响应是回调的方法
 @return 生成的按钮
 */
+ (nonnull instancetype)buttonWithFrame:(CGRect)frame
                        backgroundColor:(nullable UIColor *)bgColor
                                  title:(nullable NSString *)title
                             titleColor:(nullable UIColor *)titleColor
                               setImage:(nullable NSString *)image
                            selectImage:(nullable NSString *)selectImage
                              addTarget:(nonnull id)target
                                 action:(nonnull SEL)SEL;

@end
