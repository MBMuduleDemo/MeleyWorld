//
//  MLRegion.h
//  meyley
//
//  Created by chsasaw on 2017/6/1.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLBaseModel.h"

@interface MLRegion : MLBaseModel

@property (nonatomic, copy) NSNumber<Optional> *regionId;
@property (nonatomic, copy) NSNumber<Optional> *parentId;
@property (nonatomic, copy) NSString<Optional> *regionName;

@end
