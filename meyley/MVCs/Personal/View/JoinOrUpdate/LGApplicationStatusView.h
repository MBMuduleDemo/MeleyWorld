//
//  LGApplicationStatusView.h
//  meyley
//
//  Created by Bovin on 2018/10/25.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, LGApplicationStatus) {
    LGApplicationStatusWaitReview,  //审核中
    LGApplicationStatusApproved,    //审核通过
    LGApplicationStatusSuccessed,   //加盟或升级成功
};

@interface LGApplicationStatusView : UIView

@property (nonatomic, assign) LGApplicationStatus status;

@property (nonatomic, copy) void(^userActionComplementBlock)(LGApplicationStatus status);


@end
