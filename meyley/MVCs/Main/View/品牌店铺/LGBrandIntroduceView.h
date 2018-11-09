//
//  LGBrandIntroduceView.h
//  meyley
//
//  Created by Bovin on 2018/9/26.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGBrandDetailModel;

@interface LGBrandIntroduceView : UIView

@property (nonatomic, strong) LGBrandDetailModel *model;

@property (nonatomic, copy) void(^BrandIntroduceActionBlock)(NSInteger index);

- (void)hideAnimation;
@end


@interface LGBrandIntroduceHeaderView : UIView

@property (nonatomic, strong) LGBrandDetailModel *model;

@end

@interface LGBrandIntroduceBottomBar : UIView

@property (nonatomic, copy) void(^userInfoActionBlock)(NSInteger index);

@end
