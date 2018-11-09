//
//  LGExpressTypeView.h
//  meyley
//
//  Created by Bovin on 2018/9/14.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGExpressTypeModel;
@interface LGExpressTypeView : UIView

@property (nonatomic, strong) NSMutableArray<LGExpressTypeModel *> *expressArray;

@property (nonatomic, copy) void(^expressTypeChooseBlock)(LGExpressTypeModel *model);

@end
