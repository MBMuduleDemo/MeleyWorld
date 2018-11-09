//
//  MLWaiterCollectionViewDelegate.h
//  meyley
//
//  Created by chsasaw on 2017/6/2.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLWaiterCollectionViewDelegate : NSObject<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UIViewController *superViewController;
@property (nonatomic, strong) NSMutableArray *waiters;
@property (nonatomic, assign) BOOL showRecommendView;
@property (nonatomic, copy) NSString *descString;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView superController:(UIViewController *)controller;

@end
