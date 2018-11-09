//
//  LGBrandTopHeaderView.h
//  meyley
//
//  Created by Bovin on 2018/9/26.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGBrandDetailModel;

@interface LGBrandTopHeaderView : UICollectionReusableView

@property (nonatomic, strong) LGBrandDetailModel *model;

@property (nonatomic, copy) void(^showBrandIntroduceBlock)(void);

@end
