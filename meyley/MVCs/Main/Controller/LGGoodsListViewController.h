//
//  LGGoodsListViewController.h
//  meyley
//
//  Created by Bovin on 2018/8/5.
//  Copyright © 2018年 Meyley. All rights reserved.
//  商品列表页

#import "HKBaseViewController.h"

@interface LGGoodsListViewController : HKBaseViewController

@property (nonatomic , strong)NSDictionary *dataDic;
@property (nonatomic , copy)NSString *catId;
@property (nonatomic , assign)NSInteger selectIndex;


@end
