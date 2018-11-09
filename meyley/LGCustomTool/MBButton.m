//
//  MBButton.m
//  MBTodayNews
//
//  Created by Bovin on 2017/11/14.
//  Copyright © 2017年 Bovin. All rights reserved.
//

#import "MBButton.h"
#import <objc/runtime.h>

@interface MBButton ()

@property (nonatomic, assign) CGRect imageRect;

@property (nonatomic, assign) CGRect titleRect;

@end

static const CGFloat _space = 5.0f;


@implementation MBButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
   
    return [[self alloc] initWithType:buttonType];
}

- (instancetype)initWithType:(UIButtonType)buttonType
{
    self = [super init];
    if (self) {
        
        self.type = MBButtonTypeTopImageBottomTitle;
        self.textAlignment = MBButtonAlignmentDefault;
        self.spaceMargin = _space;
        
    }
    return self;
}

+(instancetype)buttonWithFrame:(CGRect)frame backgroundColor:(UIColor *)bgColor title:(NSString *)title titleColor:(UIColor *)titleColor setImage:(NSString *)image selectImage:(NSString *)selectImage addTarget:(id)target action:(SEL)SEL {
    MBButton *button = [MBButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = bgColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:selectImage] forState:UIControlStateHighlighted];
    [button addTarget:target action:SEL forControlEvents:UIControlEventTouchUpInside];
    return button;
    
}


- (void)setType:(MBButtonType)type {
    _type = type;
}
- (void)setTextAlignment:(MBButtonAlignment)textAlignment {
    _textAlignment = textAlignment;
}
- (void)setSpaceMargin:(CGFloat)spaceMargin {
    _spaceMargin = spaceMargin;
}
- (void)setLeftMargin:(CGFloat)leftMargin {
    _leftMargin = leftMargin;
}
- (void)setRightMargin:(CGFloat)rightMargin {
    _rightMargin = rightMargin;
}
- (void)setTopMargin:(CGFloat)topMargin {
    _topMargin = topMargin;
}
- (void)setBottomMargin:(CGFloat)bottomMargin {
    _bottomMargin = bottomMargin;
}
- (void)setHitInset:(UIEdgeInsets)hitInset {
    _hitInset = hitInset;
}
//重布局标题的坐标
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if (!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero)) {
        return self.titleRect;
    }
    return [super titleRectForContentRect:contentRect];
}
//重布局图片的坐标
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if (!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero)) {
        return self.imageRect;
    }
    return [super imageRectForContentRect:contentRect];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    switch (self.textAlignment) {
        case MBButtonAlignmentDefault:
            [self setupButtonTextAgilnmentDefaultWithType:self.type];
            break;
        case MBButtonAlignmentCustom:
            [self setupButtonTextAgilnmentCustomWithType:self.type];
            break;
            
        default:
            break;
    }
    
}
//默认的设置图片与标题位置
- (void)setupButtonTextAgilnmentDefaultWithType:(MBButtonType)type {
    
    CGFloat imageW = self.currentImage.size.width;
    CGFloat imageH = self.currentImage.size.height;
    if (imageW>self.frame.size.width) {
        imageW = self.frame.size.width;
    }
    if (imageH>self.frame.size.height) {
        imageH = self.frame.size.height;
    }
    //获取无限制情况下的label尺寸
    CGRect max_titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(LONG_MAX, LONG_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil];
    CGRect titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width-imageW-self.spaceMargin, LONG_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil];
    CGFloat titleWidth = 0.0f;
    CGFloat titleHeight = titleSize.size.height;
    if (CGRectEqualToRect(max_titleSize, titleSize)) {
        titleWidth = titleSize.size.width;
    }else {
        titleWidth = self.frame.size.width - imageW -self.spaceMargin;
    }
    if (type == MBButtonTypeTopImageBottomTitle) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (imageH+self.spaceMargin+titleHeight>self.frame.size.height) {
            if (UIEdgeInsetsEqualToEdgeInsets(self.imageEdgeInsets, UIEdgeInsetsZero)) {
                self.imageRect = CGRectMake((self.frame.size.width-imageW)/2, 0, imageW, imageH);
                self.titleRect = CGRectMake(0,imageH+self.spaceMargin, self.frame.size.width, self.frame.size.height-imageH-self.spaceMargin);
            }else {
                CGFloat newWidth = imageW-self.imageEdgeInsets.left-self.imageEdgeInsets.right;
                CGFloat newHeight = imageH-self.imageEdgeInsets.top-self.imageEdgeInsets.bottom;
                self.imageRect = CGRectMake((self.frame.size.width-newWidth)/2, self.imageEdgeInsets.top, newWidth, newHeight);
                self.titleRect = CGRectMake(0,newHeight+self.spaceMargin, self.frame.size.width, self.frame.size.height-newHeight-self.spaceMargin);
            }
        }else {
            self.imageRect = CGRectMake((self.frame.size.width-imageW)/2, (self.frame.size.height-imageH-self.spaceMargin-titleHeight)/2, imageW, imageH);
            self.titleRect = CGRectMake(0,(self.frame.size.height-imageH-self.spaceMargin-titleHeight)/2+imageH+self.spaceMargin, self.frame.size.width, titleHeight);
        }
    }else if (type == MBButtonTypeLeftImageRightTitle) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        if (titleWidth == self.frame.size.width - imageW -self.spaceMargin) {
            self.imageRect = CGRectMake(0, (self.frame.size.height-imageH)/2, imageW, imageH);
            self.titleRect = CGRectMake(imageW+self.spaceMargin,0, self.frame.size.width-imageW-self.spaceMargin, self.frame.size.height);
        }else {
            if (UIEdgeInsetsEqualToEdgeInsets(self.imageEdgeInsets, UIEdgeInsetsZero)) {
                self.imageRect = CGRectMake((self.frame.size.width-titleWidth-imageW-self.spaceMargin)/2, (self.frame.size.height-imageH)/2, imageW, imageH);
                self.titleRect = CGRectMake((self.frame.size.width-titleWidth-imageW-self.spaceMargin)/2+imageW+self.spaceMargin,0, titleWidth, self.frame.size.height);
            }else {
                CGFloat newWidth = imageW-self.imageEdgeInsets.left-self.imageEdgeInsets.right;
                CGFloat newHeight = imageH-self.imageEdgeInsets.top-self.imageEdgeInsets.bottom;
                self.imageRect = CGRectMake((self.frame.size.width-titleWidth-newWidth-self.spaceMargin)/2, (self.frame.size.height-newHeight)/2, newWidth, newHeight);
                self.titleRect = CGRectMake((self.frame.size.width-titleWidth-newWidth-self.spaceMargin)/2+imageW+self.spaceMargin,0, titleWidth, self.frame.size.height);
            }
        }
        
    }else if (type == MBButtonTypeBottomImageTopTitle) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (imageH+self.spaceMargin+titleHeight>self.frame.size.height) {
            if (UIEdgeInsetsEqualToEdgeInsets(self.imageEdgeInsets, UIEdgeInsetsZero)) {
                self.imageRect = CGRectMake((self.frame.size.width-imageW)/2, self.frame.size.height-imageH, imageW, imageH);
                self.titleRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-imageH-self.spaceMargin);
            }else {
                CGFloat newWidth = imageW-self.imageEdgeInsets.left-self.imageEdgeInsets.right;
                CGFloat newHeight = imageH-self.imageEdgeInsets.top-self.imageEdgeInsets.bottom;
                self.imageRect = CGRectMake((self.frame.size.width-newWidth)/2, self.frame.size.height-newHeight-self.imageEdgeInsets.bottom, newWidth, newHeight);
                self.titleRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-newHeight-self.spaceMargin);
            }
        }else {
            self.imageRect = CGRectMake((self.frame.size.width-imageW)/2, self.frame.size.height-imageH-(self.frame.size.height-imageH-self.spaceMargin-titleHeight)/2, imageW, imageH);
            self.titleRect = CGRectMake(0,(self.frame.size.height-imageH-self.spaceMargin-titleHeight)/2, self.frame.size.width, titleHeight);
        }
        
    }else if (type == MBButtonTypeRightImageLeftTitle) {
        self.titleLabel.textAlignment = NSTextAlignmentRight;

        if (titleWidth == self.frame.size.width - imageW -self.spaceMargin) {
            self.imageRect = CGRectMake(self.frame.size.width-imageW-self.rightMargin, (self.frame.size.height-imageH)/2, imageW, imageH);
            self.titleRect = CGRectMake(0, 0, self.frame.size.width-imageW-self.spaceMargin, self.frame.size.height);
        }else {
            if (UIEdgeInsetsEqualToEdgeInsets(self.imageEdgeInsets, UIEdgeInsetsZero)) {
                self.imageRect = CGRectMake(self.frame.size.width-imageW-(self.frame.size.width-titleWidth-imageW-self.spaceMargin)/2, (self.frame.size.height-imageH)/2, imageW, imageH);
                self.titleRect = CGRectMake((self.frame.size.width-titleWidth-imageW-self.spaceMargin)/2, 0, titleWidth, self.frame.size.height);
            }else {
                CGFloat newWidth = imageW-self.imageEdgeInsets.left-self.imageEdgeInsets.right;
                CGFloat newHeight = imageH-self.imageEdgeInsets.top-self.imageEdgeInsets.bottom;
                self.imageRect = CGRectMake(self.frame.size.width-newWidth-(self.frame.size.width-titleWidth-newWidth-self.spaceMargin)/2, (self.frame.size.height-newHeight)/2, newWidth, newHeight);
                self.titleRect = CGRectMake((self.frame.size.width-titleWidth-newWidth-self.spaceMargin)/2, 0, titleWidth, self.frame.size.height);
            }
        }
    }
    
}

//根据button的内容类型自定义设置图片与标题的位置
- (void)setupButtonTextAgilnmentCustomWithType:(MBButtonType)type {
   
//    CGFloat scale = [UIScreen mainScreen].scale;
    //如果图片有@2x,@3x两种类型时,图片的宽高根据scale比率计算,默认只有一张图片时使用2倍的比率
    CGFloat imageW = self.currentImage.size.width;
    CGFloat imageH = self.currentImage.size.height;
    if (imageW>self.frame.size.width) {
        imageW = self.frame.size.width;
    }
    if (imageH>self.frame.size.height) {
        imageH = self.frame.size.height;
    }
    if (type == MBButtonTypeTopImageBottomTitle) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageRect = CGRectMake((self.frame.size.width-imageW)/2, self.topMargin, imageW, imageH);
        self.titleRect = CGRectMake(self.leftMargin,imageH+self.spaceMargin+self.topMargin, self.frame.size.width-self.leftMargin-self.rightMargin, self.frame.size.height-imageH-self.spaceMargin-self.topMargin-self.bottomMargin);
    }else if (type == MBButtonTypeLeftImageRightTitle) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        if (UIEdgeInsetsEqualToEdgeInsets(self.imageEdgeInsets, UIEdgeInsetsZero)) {
            self.imageRect = CGRectMake(self.leftMargin, (self.frame.size.height-imageH)/2, imageW, imageH);
            self.titleRect = CGRectMake(self.leftMargin+imageW+self.spaceMargin,self.topMargin, self.frame.size.width-imageW-self.spaceMargin-self.leftMargin-self.rightMargin, self.frame.size.height-self.topMargin-self.bottomMargin);
        }else {
            CGFloat newWidth = imageW-self.imageEdgeInsets.left-self.imageEdgeInsets.right;
            CGFloat newHeight = imageH-self.imageEdgeInsets.top-self.imageEdgeInsets.bottom;
            self.imageRect = CGRectMake(self.leftMargin, (self.frame.size.height-newHeight)/2, newHeight, newHeight);
            self.titleRect = CGRectMake(self.leftMargin+newWidth+self.spaceMargin,self.topMargin, self.frame.size.width-newWidth-self.spaceMargin-self.leftMargin-self.rightMargin, self.frame.size.height-self.topMargin-self.bottomMargin);
        }
    }else if (type == MBButtonTypeBottomImageTopTitle) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageRect = CGRectMake((self.frame.size.width-imageW)/2, self.frame.size.height-imageH-self.bottomMargin, imageW, imageH);
        self.titleRect = CGRectMake(self.leftMargin, self.topMargin, self.frame.size.width-self.leftMargin-self.rightMargin, self.frame.size.height-imageH-self.spaceMargin-self.topMargin-self.bottomMargin);
    }else if (type == MBButtonTypeRightImageLeftTitle) {
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.imageRect = CGRectMake(self.frame.size.width-imageW-self.rightMargin, (self.frame.size.height-imageH)/2, imageW, imageH);
        self.titleRect = CGRectMake(self.leftMargin,self.topMargin, self.frame.size.width-imageW-self.spaceMargin-self.leftMargin-self.rightMargin, self.frame.size.height-self.topMargin-self.bottomMargin);
    }
}
//可以扩大点击的范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGFloat extWidth =  fabs(self.hitInset.left)+fabs(self.hitInset.right);
    CGFloat extHeight = fabs(self.hitInset.top)+fabs(self.hitInset.bottom);
    CGRect bounds = CGRectMake(-fabs(self.hitInset.left), -fabs(self.hitInset.top), self.bounds.size.width+extWidth, self.bounds.size.height+extHeight);
    return CGRectContainsPoint(bounds, point);
}

@end
