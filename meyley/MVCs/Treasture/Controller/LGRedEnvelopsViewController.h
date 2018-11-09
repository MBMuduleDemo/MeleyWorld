//
//  LGRedEnvelopsViewController.h
//  meyley
//
//  Created by Bovin on 2018/9/14.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "HKBaseViewController.h"
@class LGRedEnvelopModel;
@interface LGRedEnvelopsViewController : HKBaseViewController

//选择红包时object为LGRedEnvelopModel对象，不使用红包时为NSString
@property (nonatomic, copy) void(^chooseRedEnvelopFinish)(LGRedEnvelopModel *redEnvelopModel,NSString *disCount);

@end
