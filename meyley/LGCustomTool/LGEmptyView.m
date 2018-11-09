//
//  LGEmptyView.m
//  haoshuimian365
//
//  Created by apple on 2017/6/21.
//  Copyright © 2017年 CYY. All rights reserved.
//

#import "LGEmptyView.h"

@interface LGEmptyView()
/**   */
@property (nonatomic , strong)UIImageView *imageView;
/**   */
@property (nonatomic , strong)UIButton *retryBtn;

@end

@implementation LGEmptyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.desLabel];
        [self addSubview:self.retryBtn];
        self.margin = 20*LGPercent;
        self.labelFont = LGFont(14);
        self.btnFont = LGFont(14);
        self.bufferImage = [UIImage imageNamed:@"hh刷新-1-w"];
        self.textColor = [UIColor colorWithString:@"cccccc"];
        self.btnTextColor = [UIColor colorWithString:@"cccccc"];
        self.btnBorderColor = [UIColor colorWithString:@"cccccc"];
    }
    return self;
}


-(void)setLabelFont:(UIFont *)labelFont{
    _labelFont = labelFont;
    self.desLabel.font = labelFont;
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.desLabel.textColor = textColor;
}

-(void)setBtnFont:(UIFont *)btnFont{
    _btnFont = btnFont;
    self.retryBtn.titleLabel.font = btnFont;
}

-(void)setBtnTextColor:(UIColor *)btnTextColor{
    _btnTextColor = btnTextColor;
    [self.retryBtn setTitleColor:btnTextColor forState:UIControlStateNormal];
}

-(void)setBtnBorderColor:(UIColor *)btnBorderColor{
    _btnBorderColor = btnBorderColor;
    self.retryBtn.layer.borderColor = btnBorderColor.CGColor;
}


//图片+文字
-(void)showViewWithImageName:(NSString *)image andDes:(NSString *)des{
    self.hidden = NO;
    self.imageView.hidden = NO;
    self.desLabel.hidden = NO;
    self.retryBtn.hidden = YES;
    //坐标
    self.desLabel.text = des;
    self.imageView.image = [UIImage imageNamed:image];
    CGSize imageSize = [UIImage imageNamed:image].size;//图片大小
    self.imageView.center = CGPointMake(self.size.width/2.0, (self.size.height-self.margin-imageSize.height*LGPercent)/2.0+self.offset);
    self.imageView.bounds = CGRectMake(0, 0, imageSize.width*LGPercent, imageSize.height*LGPercent);
    
    CGSize textSize = [des boundingRectWithSize:CGSizeMake(self.size.width-25*LGPercent, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.labelFont} context:nil].size;
    self.desLabel.frame = CGRectMake(10*LGPercent, (self.size.height+self.margin)/2.0+self.offset, self.size.width-20*LGPercent, textSize.height+5.0*LGPercent);

    [self.imageView.layer removeAllAnimations];
}

//文字+按钮
-(void)showFaildViewWithDes:(NSString *)des{
    self.hidden = NO;
    self.imageView.hidden = YES;
    self.desLabel.hidden = NO;
    self.retryBtn.hidden = NO;
    self.desLabel.text = des;
    CGSize textSize = [des boundingRectWithSize:CGSizeMake(self.size.width-25*LGPercent, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.labelFont} context:nil].size;
    self.desLabel.frame = CGRectMake(10*LGPercent, (self.size.height-self.margin)/2.0-textSize.height+self.offset, self.size.width-20*LGPercent, textSize.height);
    self.retryBtn.center = CGPointMake(self.size.width/2.0, (self.size.height + self.margin + self.retryBtn.size.height)/2.0+self.offset);
    [self.imageView.layer removeAllAnimations];
}

//文字
-(void)showViewWithDes:(NSString *)des{
    self.hidden = NO;
    self.imageView.hidden = YES;
    self.desLabel.hidden = NO;
    self.retryBtn.hidden = YES;
    self.desLabel.text = des;
    CGSize textSize = [des boundingRectWithSize:CGSizeMake(self.size.width-25*LGPercent, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.labelFont} context:nil].size;
    self.desLabel.frame = CGRectMake(10*LGPercent, (self.size.height-self.margin)/2.0-textSize.height+self.offset, self.size.width-20*LGPercent, textSize.height);
    [self.imageView.layer removeAllAnimations];
}

-(void)startBuffer{
    self.hidden = NO;
    self.retryBtn.hidden = YES;
    self.imageView.hidden = NO;
    self.desLabel.text = @"加载中...";
    self.imageView.image = self.bufferImage;
    
    CGSize imageSize = self.bufferImage.size;//图片大小
    self.imageView.center = CGPointMake(self.size.width/2.0, (self.size.height-self.margin-imageSize.height*LGPercent)/2.0+self.offset);
    self.imageView.bounds = CGRectMake(0, 0, imageSize.width*LGPercent, imageSize.height*LGPercent);
    
    CGSize textSize = [@"加载中..." boundingRectWithSize:CGSizeMake(self.size.width-25*LGPercent, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.labelFont} context:nil].size;
    self.desLabel.frame = CGRectMake(10*LGPercent, (self.size.height+self.margin)/2.0+self.offset, self.size.width-20*LGPercent, textSize.height+5.0*LGPercent);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    animation.duration = 1;
    animation.cumulative = YES;
    animation.repeatCount = ULLONG_MAX;
    [_imageView.layer addAnimation:animation forKey:@"rotationAnimation"];
}

-(void)showViewWithImageName:(NSString *)image andDes:(NSString *)des offset:(CGFloat)offset{
    self.hidden = NO;
    self.imageView.hidden = NO;
    self.desLabel.hidden = NO;
    self.retryBtn.hidden = YES;
    //坐标
    self.desLabel.text = des;
    self.imageView.image = [UIImage imageNamed:image];
    CGSize imageSize = [UIImage imageNamed:image].size;//图片大小
    self.imageView.center = CGPointMake(self.size.width/2.0, (self.size.height-self.margin-imageSize.height*LGPercent)/2.0+offset);
    self.imageView.bounds = CGRectMake(0, 0, imageSize.width*LGPercent, imageSize.height*LGPercent);
    
    CGSize textSize = [des boundingRectWithSize:CGSizeMake(self.size.width-25*LGPercent, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.labelFont} context:nil].size;
    self.desLabel.frame = CGRectMake(10*LGPercent, (self.size.height+self.margin)/2.0+offset, self.size.width-20*LGPercent, textSize.height+5.0*LGPercent);
    
    [self.imageView.layer removeAllAnimations];


}
-(void)showFaildViewWithDes:(NSString *)des offset:(CGFloat)offset{
    self.hidden = NO;
    self.imageView.hidden = YES;
    self.desLabel.hidden = NO;
    self.retryBtn.hidden = NO;
    self.desLabel.text = des;
    CGSize textSize = [des boundingRectWithSize:CGSizeMake(self.size.width-25*LGPercent, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.labelFont} context:nil].size;
    self.desLabel.frame = CGRectMake(0, (self.size.height-self.margin)/2.0-textSize.height+offset, Screen_W, textSize.height);
    self.retryBtn.center = CGPointMake(self.size.width/2.0, (self.size.height + self.margin + self.retryBtn.size.height)/2.0+offset);
    [self.imageView.layer removeAllAnimations];

}
-(void)showViewWithDes:(NSString *)des offset:(CGFloat)offset{
    self.hidden = NO;
    self.imageView.hidden = YES;
    self.desLabel.hidden = NO;
    self.retryBtn.hidden = YES;
    self.desLabel.text = des;
    CGSize textSize = [des boundingRectWithSize:CGSizeMake(self.size.width-25*LGPercent, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.labelFont} context:nil].size;
    self.desLabel.frame = CGRectMake(10*LGPercent, (self.size.height-self.margin)/2.0-textSize.height+offset, self.size.width-20*LGPercent, textSize.height);
    [self.imageView.layer removeAllAnimations];

}
-(void)startBufferWithOffset:(CGFloat)offset{
    self.hidden = NO;
    self.retryBtn.hidden = YES;
    self.imageView.hidden = NO;
    self.desLabel.text = @"加载中...";
    self.imageView.image = self.bufferImage;
    
    CGSize imageSize = self.bufferImage.size;//图片大小
    self.imageView.center = CGPointMake(self.size.width/2.0, (self.size.height-self.margin-imageSize.height*LGPercent)/2.0+offset);
    self.imageView.bounds = CGRectMake(0, 0, imageSize.width*LGPercent, imageSize.height*LGPercent);
    
    CGSize textSize = [@"加载中..." boundingRectWithSize:CGSizeMake(self.size.width-25*LGPercent, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.labelFont} context:nil].size;
    self.desLabel.frame = CGRectMake(10*LGPercent, (self.size.height+self.margin)/2.0+offset, self.size.width-20*LGPercent, textSize.height+5.0*LGPercent);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    animation.duration = 1;
    animation.cumulative = YES;
    animation.repeatCount = ULLONG_MAX;
    [_imageView.layer addAnimation:animation forKey:@"rotationAnimation"];
}



-(void)stopBuffer{
    self.hidden = YES;
    [self.imageView.layer removeAllAnimations];
}

-(void)retryBtnAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(retryBtnAction)]) {
        [self.delegate retryBtnAction];
    }
    
    if ([self.delegate respondsToSelector:@selector(retryBtnAction:)]) {
        [self.delegate retryBtnAction:self];
    }
    [self startBuffer];
}

#pragma mark---懒加载+布局
-(UIImageView *)imageView{
    if(!_imageView){
        _imageView =  [[UIImageView alloc]init];
    }
    return _imageView;
}

-(UILabel *)desLabel{
    if(!_desLabel){
        _desLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:[UIColor colorWithString:@"666666"] font:14 textAlignment:NSTextAlignmentCenter lines:0];
    }
    return _desLabel;
}

-(UIButton *)retryBtn{
    if(!_retryBtn){
        _retryBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        _retryBtn.center = CGPointMake(Screen_W/2.0, (self.size.height + self.margin + 15*LGPercent)/2.0+self.offset);
        _retryBtn.bounds = CGRectMake(0, 0, 110*LGPercent, 30*LGPercent);
        _retryBtn.layer.borderColor = [UIColor colorWithString:@"cccccc" alpha:0.7].CGColor;
        _retryBtn.layer.borderWidth = 1.0;
        _retryBtn.layer.cornerRadius = 15*LGPercent;
        _retryBtn.clipsToBounds = YES;
        _retryBtn.titleLabel.font = LGFont(14);
        [_retryBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [_retryBtn setTitleColor:[UIColor colorWithString:@"cccccc"] forState:UIControlStateNormal];
        [_retryBtn addTarget:self action:@selector(retryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _retryBtn.hidden = YES;
    }
    return _retryBtn;
}


-(void)dealloc{
    self.delegate = nil;
}

@end
