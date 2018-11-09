//
//  LGWaiterGradeModel.h
//  meyley
//
//  Created by 李保洋 on 2018/11/6.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGWaiterGradeModel : NSObject

@property (nonatomic, copy) NSString *rankId;       //客服等级ID
@property (nonatomic, copy) NSString *serviceCommision;      //服务佣金比例
@property (nonatomic, copy) NSString *rankName;   //客服等级名称
@property (nonatomic, copy) NSString *minPoints;  //获得积分比例
@property (nonatomic, copy) NSString *desc;  //条件


@end
