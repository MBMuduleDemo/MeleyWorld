//
//  LGOrderDetailModel.m
//  meyley
//
//  Created by Bovin on 2018/10/11.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGOrderDetailModel.h"
#import "LGOrderListModel.h"

@implementation LGOrderDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goodsList":[LGOrderGoodsListModel class]};
}


@end


@implementation LGOrderDetailBounsModel


@end
