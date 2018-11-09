//
//  LGShoppingCartModel.m
//  meyley
//
//  Created by Bovin on 2018/9/5.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGShoppingCartModel.h"

@implementation LGShoppingCartModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goodsList":[LGShoppingGoodsModel class]};
}
@end

@implementation LGShoppingGoodsModel


@end
