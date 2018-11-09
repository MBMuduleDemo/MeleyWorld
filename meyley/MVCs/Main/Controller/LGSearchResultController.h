//
//  LGSearchResultController.h
//  meyley
//
//  Created by Bovin on 2018/8/4.
//  Copyright © 2018年 Meyley. All rights reserved.
//  首页搜索

#import "HKBaseViewController.h"

@interface LGSearchResultController : HKBaseViewController

@property (nonatomic, copy) NSString *keywords;

//品牌内搜索时需要传
@property (nonatomic, copy) NSString *seachBrandId;

@end
