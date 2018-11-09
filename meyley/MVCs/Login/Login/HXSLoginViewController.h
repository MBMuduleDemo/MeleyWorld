//
//  HXSLoginViewController.h
//  store
//
//  Created by chsasaw on 14-10-16.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HKBaseViewController.h"

typedef void (^LoginCompletion)(void);

@interface HXSLoginViewController : HKBaseViewController

- (void)actionCompletion;

+ (void)showLoginController:(UIViewController *)fromController
            loginCompletion: (LoginCompletion)completion;

+ (void)showLoginController:(UIViewController *)fromController
            loginCompletion: (LoginCompletion)completion
              loginCanceled:(void (^)(void))cancelCompletion;

@end
