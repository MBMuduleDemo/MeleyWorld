//
//  LGOrderListModel.m
//  meyley
//
//  Created by Bovin on 2018/10/11.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGOrderListModel.h"

@implementation LGOrderListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goodsList":[LGOrderGoodsListModel class]};
}

@end


@implementation LGOrderGoodsListModel


@end
