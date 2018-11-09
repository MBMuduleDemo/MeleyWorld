//
//  DFCornerNumView.h
//  DFJC_201609
//
//  Created by 汪泽煌 on 2016/12/9.
//  Copyright © 2016年 汪泽煌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DFCornerViewDelegate <NSObject>

@optional
- (void)cornerViewClick;

- (void)cornerViewClickWithView:(id)view;

@end


@interface DFCornerNumView : UIView

+ (DFCornerNumView *)instanceCornerNumView;

//未读数量
@property (nonatomic, copy) NSString * unreadNumStr;

@property (nonatomic, copy) NSString * imgName;

//是否隐藏数字
@property (nonatomic, assign) BOOL  shouldNumHidden;

@property (nonatomic, copy) NSString * viewName;


@property (nonatomic, assign) id<DFCornerViewDelegate>  delegate;

@end
