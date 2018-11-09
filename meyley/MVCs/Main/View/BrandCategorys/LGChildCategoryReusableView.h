//
//  LGChildCategoryReusableView.h
//  meyley
//
//  Created by Bovin on 2018/8/15.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGChildCategoryReusableView : UICollectionReusableView

@property (nonatomic , copy)NSString *titleText;

@property (nonatomic , copy)void(^secondCategoryHeaderAction)();

@end
