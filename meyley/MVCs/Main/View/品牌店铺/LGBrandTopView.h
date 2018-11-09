//
//  LGBrandTopView.h
//  meyley
//
//  Created by Bovin on 2018/8/11.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGBrandTopViewDelegate <NSObject>

@optional

-(void)selectSearchKey:(NSString *)searchKey;

- (void)filterBrandChildCategoryGoods;

@end

@interface LGBrandTopView : UICollectionReusableView

@property (nonatomic , weak) id <LGBrandTopViewDelegate> delegate;

@end
