//
//  TooltipView.m
//  haoshuimian
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 CYY. All rights reserved.
//

#import "TooltipView.h"

@implementation TooltipView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

+(void)showMessage:(NSString *)message offset:(CGFloat)offset
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor colorWithString:@"1f2242"];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
//    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    NSAttributedString *attributeStr = [[NSAttributedString alloc]initWithString:message attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    CGRect rect = [attributeStr boundingRectWithSize:CGSizeMake(300, 9000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    label.frame = CGRectMake(10, 12, rect.size.width+2.0, rect.size.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.numberOfLines = 0;
    [showview addSubview:label];
    showview.frame = CGRectMake((Screen_W - rect.size.width - 20)/2, Screen_H/2.0+offset, rect.size.width+20, rect.size.height+24);
    [UIView animateWithDuration:1.5 animations:^{
        showview.alpha = 0.9;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

+(void)showAlertView:(NSString *)title content:(NSString *)content offset:(CGFloat)offset{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor colorWithString:@"000000"];//1f2242
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 0.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    
    [window addSubview:showview];
    
    UILabel *titleLabel = [UILabel lableWithFrame:CGRectZero text:title textColor:[UIColor whiteColor] font:16 textAlignment:NSTextAlignmentCenter lines:2];
    [showview addSubview:titleLabel];
    UILabel *contentLabel = [UILabel lableWithFrame:CGRectZero text:content textColor:[UIColor whiteColor] font:12 textAlignment:NSTextAlignmentCenter lines:0];
    [showview addSubview:contentLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showview).offset(13*LGPercent);
        make.left.equalTo(showview).offset(10*LGPercent);
        make.right.equalTo(showview).offset(-10*LGPercent);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(6*LGPercent);
        make.left.equalTo(showview).offset(10*LGPercent);
        make.right.equalTo(showview).offset(-10*LGPercent);
    }];
    
    CGRect titleRect = CGRectZero;
    CGRect contentRect = CGRectZero;
    
    if (title.length>0) {
        NSAttributedString *titleAttStr = [[NSAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:LGFont(17)}];
        titleRect = [titleAttStr boundingRectWithSize:CGSizeMake(170*LGPercent, 9000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    }else{
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(showview);
        }];
    }
    
    if (content.length>0) {
        NSAttributedString *contentAttStr = [[NSAttributedString alloc]initWithString:content attributes:@{NSFontAttributeName:LGFont(14)}];
        contentRect = [contentAttStr boundingRectWithSize:CGSizeMake(170*LGPercent, 9000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    }else{
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(showview);
        }];
    }
    
    
    CGFloat width = titleRect.size.width;
    width = width>contentRect.size.width?width:contentRect.size.width;
    width = width>180*LGPercent?200*LGPercent:width+30*LGPercent;
    
    showview.frame = CGRectMake((Screen_W - width)/2, Screen_H/2.0+offset, width, titleRect.size.height+contentRect.size.height+30*LGPercent);
    showview.transform = CGAffineTransformScale(showview.transform, 0.001, 0.001);
    
    [UIView animateWithDuration:0.4 animations:^{
        showview.transform = CGAffineTransformScale(showview.transform, 1000, 1000);
        showview.alpha = 0.9;
    }];
    [UIView animateWithDuration:0.6 delay:1.8 options:UIViewAnimationOptionCurveLinear animations:^{
        showview.alpha = 0.01;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

+(void)showAlertView:(NSString *)title content:(NSString *)content offset:(CGFloat)offset rotation:(BOOL)rotation{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor colorWithString:@"000000"];//1f2242
    showview.alpha = 0.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *titleLabel = [UILabel lableWithFrame:CGRectZero text:title textColor:[UIColor whiteColor] font:16 textAlignment:NSTextAlignmentCenter lines:2];
    [showview addSubview:titleLabel];
    UILabel *contentLabel = [UILabel lableWithFrame:CGRectZero text:content textColor:[UIColor whiteColor] font:12 textAlignment:NSTextAlignmentCenter lines:0];
    [showview addSubview:contentLabel];
    
    CGRect titleRect = CGRectZero;
    CGRect contentRect = CGRectZero;
    
    if (title.length>0) {
        NSAttributedString *titleAttStr = [[NSAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:LGFont(17)}];
        titleRect = [titleAttStr boundingRectWithSize:CGSizeMake(170*LGPercent, 9000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    }
    
    if (content.length>0) {
        NSAttributedString *contentAttStr = [[NSAttributedString alloc]initWithString:content attributes:@{NSFontAttributeName:LGFont(14)}];
        contentRect = [contentAttStr boundingRectWithSize:CGSizeMake(170*LGPercent, 9000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    }
    CGFloat width = titleRect.size.width;
    width = width>contentRect.size.width?width:contentRect.size.width;
    width = width>180*LGPercent?200*LGPercent:width+30*LGPercent;
    
    CGFloat height = titleRect.size.height+contentRect.size.height+30*LGPercent;
    
    showview.frame = CGRectMake((Screen_W - width)/2, Screen_H/2.0+offset, width, height);
    titleLabel.frame = CGRectMake(10*LGPercent, 10*LGPercent, showview.width-20*LGPercent, titleRect.size.height);
    contentLabel.frame = CGRectMake(10*LGPercent, titleRect.size.height+17*LGPercent, showview.width-20*LGPercent, contentRect.size.height);
    
    if (rotation == YES) {
        showview.frame = CGRectMake((Screen_H - width)/2, Screen_W/2.0+offset-height/2.0, width, height);
        showview.transform = CGAffineTransformRotate(showview.transform, M_PI_2);
    }
    showview.transform = CGAffineTransformScale(showview.transform, 0.001, 0.001);
    
    [UIView animateWithDuration:0.5 animations:^{
        if (rotation == YES) {
            showview.transform = CGAffineTransformScale(showview.transform, 600, 600);
        }else{
            showview.transform = CGAffineTransformScale(showview.transform, 1000, 1000);
        }
        showview.alpha = 0.9;
    }];
    
    [UIView animateWithDuration:0.7 delay:1.8 options:UIViewAnimationOptionCurveLinear animations:^{
        showview.alpha = 0.01;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
    
}


@end
