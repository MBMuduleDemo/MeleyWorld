//
//  LGGoodsCategoryModel.h
//  meyley
//
//  Created by Bovin on 2018/8/30.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LGGoodsCategoryModel : NSObject

@property (nonatomic , copy)NSString *attrId;
@property (nonatomic , copy)NSString *attrType;
@property (nonatomic , copy)NSString *attrName;
@property (nonatomic , copy)NSString *selectIndex;
@property (nonatomic , strong)NSArray *attrValues;

@end
