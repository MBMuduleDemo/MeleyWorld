//
//  LGSelectSectionView.h
//  meyley
//
//  Created by Bovin on 2018/8/19.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGSelectSectionViewDelegate <NSObject>

-(void)selectSection:(NSInteger)section open:(NSString *)open;

@end;

@interface LGSelectSectionView : UICollectionReusableView

@property (nonatomic , weak) id <LGSelectSectionViewDelegate> delegate;

@property (nonatomic , copy)NSString *title;

@property (nonatomic , assign)NSInteger section;

@property (nonatomic , assign)BOOL showLine;
//记录按钮的状态
@property (nonatomic, assign) BOOL shouldSelected;

@end
