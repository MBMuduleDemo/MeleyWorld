//
//  DFCornerNumView.m
//  DFJC_201609
//
//  Created by 汪泽煌 on 2016/12/9.
//  Copyright © 2016年 汪泽煌. All rights reserved.
//

#import "DFCornerNumView.h"

@interface DFCornerNumView ()

@property (weak, nonatomic) IBOutlet UIImageView *img_bg;

@property (weak, nonatomic) IBOutlet UILabel *lb_num;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraints_lbNum_Width;


@end


@implementation DFCornerNumView


- (void)awakeFromNib{
    
    [super awakeFromNib];
    

    self.lb_num.layer.cornerRadius = 7;
    self.lb_num.layer.masksToBounds = YES;
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cornerViewTap)];
    [self addGestureRecognizer:tapGesture];
    
}

- (void)cornerViewTap{
    
    NSLog(@"点击了 数字view");
    
    if ([self.delegate respondsToSelector:@selector(cornerViewClick)]) {
        
        [self.delegate cornerViewClick];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(cornerViewClickWithView:)]){
        [self.delegate cornerViewClickWithView:self];
    }
    
}


+ (DFCornerNumView *)instanceCornerNumView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"DFCornerNumView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}

- (void)setImgName:(NSString *)imgName{
    
    if (imgName) {
        _img_bg.image = [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}

- (void)setUnreadNumStr:(NSString *)unreadNumStr{
    
    if (unreadNumStr) {
        
        
        
        if(![unreadNumStr isEqualToString:self.lb_num.text] && self.lb_num.text.length>0){
            //做个动画
            [self.lb_num.layer addAnimation:[self scale:@(1.2) orgin:@(0.9) durTimes:0.2 Rep:2] forKey:@"zoom"];

        }
        
        self.lb_num.text = unreadNumStr;
        if ([unreadNumStr integerValue]>=10) {
            
            self.constraints_lbNum_Width.constant = 20;
        }else if ([unreadNumStr integerValue] <10){
            self.constraints_lbNum_Width.constant = 14;
        }
        
        
        
        [self layoutSubviews];
    }
    
}


- (CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repeatTimes{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue=orginMultiple;
    animation.toValue=Multiple;
    animation.duration=time;
    animation.autoreverses=YES;
    animation.repeatCount=repeatTimes;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}


- (void)setShouldNumHidden:(BOOL)shouldNumHidden{
    
    self.lb_num.hidden = shouldNumHidden;
}


@end
