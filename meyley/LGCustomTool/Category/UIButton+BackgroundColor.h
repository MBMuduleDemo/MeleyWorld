//
//  UIButton+BackgroundColor.h
//

#import <UIKit/UIKit.h>

@interface UIButton (BackgroundColor)

@property(nonatomic ,copy)void(^block)(UIButton *);

-(void)addTapBlock:(void(^)(UIButton*btn))block;

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

- (void)setCornerBackgroundColor:(UIColor *)backgroundColor withRadius:(CGFloat)radius forState:(UIControlState)state;


@end
