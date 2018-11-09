//
//  LGPhoneLoginViewController.h
//  meyley
//
//  Created by Bovin on 2018/10/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "HKBaseViewController.h"

typedef NS_ENUM(NSUInteger, LGInterfaceType) {
    LGInterfaceTypeLogin, //用户手机登录
    LGInterfaceTypeModify,  //用户修改手机号码
};

@interface LGPhoneLoginViewController : HKBaseViewController

@property (nonatomic, assign) LGInterfaceType type;

@end
