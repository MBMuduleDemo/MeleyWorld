//
//  LGMineOrderCountModel.h
//  meyley
//
//  Created by Bovin on 2018/10/11.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGMineOrderCountModel : NSObject

@property (nonatomic, assign) int userId;
@property (nonatomic, assign) int returned;
@property (nonatomic, assign) int unevaluate;
@property (nonatomic, assign) int unpayed;
@property (nonatomic, assign) int unreceived;
@property (nonatomic, assign) int unshipped;
@property (nonatomic, assign) int userBonus;
@property (nonatomic, assign) int userPoints;
@property (nonatomic, assign) double userMoney;


@end
