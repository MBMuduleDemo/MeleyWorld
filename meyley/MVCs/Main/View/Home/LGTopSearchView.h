//
//  LGTopSearchView.h
//  meyley
//
//  Created by mac on 2018/7/31.
//  Copyright © 2018年 Meyley. All rights reserved.
//  搜索

#import <UIKit/UIKit.h>

@protocol LGSearchViewDelegate <NSObject>

@optional
-(void)searchGoodsWithText:(NSString *)text;

@end

@interface LGTopSearchView : UIView
@property (nonatomic , weak) id <LGSearchViewDelegate> delegate;
@property (nonatomic , strong)UITextField *searchTF;
@property (nonatomic , strong)UIButton *categoryBtn;
@property (nonatomic , strong)UIButton *shareBtn;
@property (nonatomic , strong)NSArray *cityArry;

@end
