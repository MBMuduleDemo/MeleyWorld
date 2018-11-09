//
//  LGUserMoneyIntegralModel.h
//  meyley
//
//  Created by Bovin on 2018/9/16.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGUserMoneyIntegralModel : NSObject

@property (nonatomic, copy) NSString *rankPoints;
@property (nonatomic, copy) NSString *userMoney;    //用户余额
@property (nonatomic, copy) NSString *frozenMoney; //冻结余额
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *payPoints; //支付积分

@end
