//
//  LGAddRedEnvelopAlertView.h
//  meyley
//
//  Created by Bovin on 2018/9/16.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LGAddRedEnvelopAlertView : UIView

@property (nonatomic, copy) void(^redEnvelopCode)(NSString *redCode);

@property (nonatomic, copy) void(^sureBtnClickBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title commitBtnTitle:(NSString *)commitTitle;

@end
