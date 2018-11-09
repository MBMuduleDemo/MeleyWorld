//
//  LGGoodsDetailParamView.h
//  meyley
//
//  Created by mac on 2018/9/3.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGGoodsDetailParamView : UIView
//参数
@property (nonatomic , strong)NSArray *categoryArry;
//包装说明
@property (nonatomic , copy)NSString *packDes;
//售后说明
@property (nonatomic , copy)NSString *salesDes;

@end
