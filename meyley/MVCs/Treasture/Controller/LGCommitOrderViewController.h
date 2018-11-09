//
//  LGCommitOrderViewController.h
//  meyley
//
//  Created by Bovin on 2018/9/11.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "HKBaseViewController.h"
@class LGRedEnvelopModel;

@interface LGCommitOrderViewController : HKBaseViewController

//选中的商品
@property (nonatomic, strong) NSMutableArray *goodsArray;
//如果使用红包
@property (nonatomic, strong) LGRedEnvelopModel *redEnvelopModel;
//积分优惠
@property (nonatomic, copy) NSString *integralDiscount;

@end
