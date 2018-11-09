//
//  HKBaseViewController.h
//  Housekeeper
//
//  Created by chsasaw on 2017/2/16.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKBaseViewController : UIViewController

+ (instancetype)controllerFromStoryboard;
+ (NSString *)storyboardName;

- (void)back;

@end
