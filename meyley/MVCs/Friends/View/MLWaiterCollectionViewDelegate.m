//
//  MLWaiterCollectionViewDelegate.m
//  meyley
//
//  Created by chsasaw on 2017/6/2.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLWaiterCollectionViewDelegate.h"
#import "MLServiceCollectionViewCell.h"
#import "HXSCommunityMyCenterViewController.h"
#import "MLRecommendWaiterView.h"

@interface MLWaiterCollectionViewDelegate()

@end

@implementation MLWaiterCollectionViewDelegate

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView superController:(UIViewController *)controller {
    if(self = [super init]) {
        self.showRecommendView = YES;
        
        self.collectionView = collectionView;
        self.superViewController = controller;
        
        [self.collectionView setDelegate:self];
        [self.collectionView setDataSource:self];
        
        NSString *cellName = NSStringFromClass([MLServiceCollectionViewCell class]);
        [self.collectionView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellWithReuseIdentifier:cellName];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    }
    
    return self;
}

- (void)setWaiters:(NSMutableArray *)waiters {
    if(_waiters != waiters) {
        _waiters = waiters;
        
        [self.collectionView reloadData];
    }
}
#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _waiters.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MLServiceCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MLServiceCollectionViewCell class]) forIndexPath:indexPath];
    [cell setWaiter:_waiters[indexPath.item]];
    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter && self.waiters.count == 0 && self.showRecommendView) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        reusableView = footerview;
        MLRecommendWaiterView *waiterView = [reusableView viewWithTag:101];
        if(!waiterView) {
            waiterView = [MLRecommendWaiterView waiterView];
            [reusableView addSubview:waiterView];
            waiterView.tag = 101;
            [waiterView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(reusableView.mas_left);
                make.top.equalTo(reusableView.mas_top);
                make.right.equalTo(reusableView.mas_right);
                make.bottom.equalTo(reusableView.mas_bottom);
            }];
            [waiterView showInViewController:self.superViewController];
        }
        
        if(self.descString) {
            [waiterView setDescText:self.descString];
        }
    }
    
    return reusableView;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){collectionView.frame.size.width/3, collectionView.frame.size.width/3 * 1.2};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return (CGSize){SCREEN_WIDTH,44};
//}
//
//
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){SCREEN_WIDTH, _waiters.count == 0 && _showRecommendView ? SCREEN_WIDTH*0.4+150 : 0};
}

#pragma mark ---- UICollectionViewDelegate

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//// 点击高亮
//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor greenColor];
//}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell layoutSubviews];
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MLWaiterModel *waiter = self.waiters[indexPath.row];
    HXSCommunityMyCenterViewController *communityOthersCenterViewController = [HXSCommunityMyCenterViewController controllerFromXib];
    
    communityOthersCenterViewController.userIdNum = waiter.userId;
    
    [self.superViewController.navigationController pushViewController:communityOthersCenterViewController animated:YES];
}

@end
