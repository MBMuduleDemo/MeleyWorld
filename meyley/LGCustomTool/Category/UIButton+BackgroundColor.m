//
//  UIButton+BackgroundColor.m
//

#import "UIButton+BackgroundColor.h"
#import <objc/runtime.h>

@implementation UIButton (BackgroundColor)

- (void)setBlock:(void(^)(UIButton*))block {
    objc_setAssociatedObject(self,@selector(block), block,OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget: self action:@selector(click:)forControlEvents:UIControlEventTouchUpInside];
}
- (void(^)(UIButton*))block {
    return objc_getAssociatedObject(self,@selector(block));
}
- (void)addTapBlock:(void(^)(UIButton*))block {
    self.block= block;
    [self addTarget: self action:@selector(click:)forControlEvents:UIControlEventTouchUpInside];
}
- (void)click:(UIButton*)btn {
    if(self.block) {
        self.block(btn);
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

- (void)setCornerBackgroundColor:(UIColor *)backgroundColor withRadius:(CGFloat)radius forState:(UIControlState)state
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    [self setBackgroundColor:backgroundColor forState:state];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
