//
//  LGSelectSectionModel.h
//  meyley
//
//  Created by mac on 2018/8/20.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGSelectSectionModel : NSObject

@property (nonatomic , copy)NSString *sectionTitle;
@property (nonatomic , copy)NSString *defaultCount;
@property (nonatomic , copy)NSString *open;
@property (nonatomic , strong)NSArray *dataArry;

@end
