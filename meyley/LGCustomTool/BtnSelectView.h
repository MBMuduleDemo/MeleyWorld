//
//  BtnSelectView.h
//  haoshuimian
//
//  Created by apple on 16/10/29.
//  Copyright © 2016年 CYY. All rights reserved.
//  症状选择

#import <UIKit/UIKit.h>

@protocol BtnSelectViewDelegate <NSObject>

@optional
-(void)btnSelectResult:(NSDictionary *)result andIndex:(NSInteger)index;

-(void)sendViewHeight:(CGFloat)height;

@end

@interface BtnSelectView : UIView

@property (nonatomic , assign)id <BtnSelectViewDelegate>delegate;

@property (nonatomic , strong)NSArray *dataArry;

@end
