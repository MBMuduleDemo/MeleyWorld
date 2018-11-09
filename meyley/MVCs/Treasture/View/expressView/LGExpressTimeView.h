//
//  LGExpressTimeView.h
//  meyley
//
//  Created by Bovin on 2018/9/14.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGExpressTimeView : UIView

@property (nonatomic, copy) void(^expressTimeChooseBlock)(NSString *time);

@end
