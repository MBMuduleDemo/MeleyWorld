//
//  LGCategorySelectView.h
//  meyley
//
//  Created by Bovin on 2018/8/19.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGCategorySelectDelegate <NSObject>

-(void)selectLowPrice:(NSString *)lowPrice highPrice:(NSString *)highPrice brands:(NSString *)brandIds;

@end;



@interface LGCategorySelectView : UIView

@property (nonatomic , weak) id <LGCategorySelectDelegate> delegate;

@property (nonatomic , strong)NSMutableArray *dataArry;

-(void)showAnimation;

@end
