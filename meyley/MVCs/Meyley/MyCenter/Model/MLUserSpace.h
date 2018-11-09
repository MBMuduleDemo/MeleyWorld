//
//  MLUserSpace.h
//  meyley
//
//  Created by chsasaw on 2017/3/8.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "HXSUserBasicInfo.h"
#import "HXSPost.h"

@interface MLUserSpace : HXSUserBasicInfo

@property (nonatomic, copy) NSNumber<Optional> *followCount;
@property (nonatomic, copy) NSNumber<Optional> *praiseCount;
@property (nonatomic, copy) NSNumber<Optional> *fansCount;
@property (nonatomic, copy) NSArray<HXSPost> *dynamicsList;

@property (nonatomic, copy) NSNumber<Optional> *isFollow;

@end
