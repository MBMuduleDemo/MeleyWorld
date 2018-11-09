//
//  LGAddressRegionModel.h
//  meyley
//
//  Created by Bovin on 2018/9/17.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGAddressRegionModel : NSObject

@property (nonatomic, copy) NSString *regionId;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *regionName;

@property (nonatomic, copy) NSString *regionType;
@property (nonatomic, copy) NSString *agencyId;

@end


