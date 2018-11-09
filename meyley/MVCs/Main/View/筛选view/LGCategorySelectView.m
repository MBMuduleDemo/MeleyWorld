//
//  LGCategorySelectView.m
//  meyley
//
//  Created by Bovin on 2018/8/19.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGCategorySelectView.h"
#import "LGSelectPriceView.h"
#import "LGSelectSectionView.h"
#import "LGSelectCollectionCell.h"
#import "LGSelectSectionModel.h"
#import "LGSelectItemModel.h"

@interface LGCategorySelectView()<UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,LGSelectPriceViewDelegate,LGSelectSectionViewDelegate>

@property (nonatomic , strong)UICollectionView *collectionView;
@property (nonatomic , strong)LGSelectPriceView *topView;
@property (nonatomic , strong)UIButton *resetBtn;
@property (nonatomic , strong)UIButton *sureBtn;
@property (nonatomic , copy)NSString *lowPrice;
@property (nonatomic , copy)NSString *highPrice;

@end

@implementation LGCategorySelectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapGester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAnimation)];
        tapGester.delegate = self;
        [self addGestureRecognizer:tapGester];
        [self addSubview:self.collectionView];
        [self addSubview:self.resetBtn];
        [self addSubview:self.sureBtn];
        [self showAnimation];
        self.lowPrice = @"";
        self.highPrice = @"";
        [self.collectionView reloadData];
    }
    return self;
}


-(void)selectSection:(NSInteger)section open:(NSString *)open{
    LGSelectSectionModel *model = self.dataArry[section-1];
    model.open = open;
    [self.dataArry replaceObjectAtIndex:section-1 withObject:model];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
}

-(void)selectLowPrice:(NSString *)lowPrice{
    self.lowPrice = lowPrice.length>0?lowPrice:@"";
}

-(void)selectHighPrice:(NSString *)highPrice{
    self.highPrice = highPrice.length>0?highPrice:@"";
}
//重置
-(void)resetBtnTapAction{
    self.lowPrice = @"";
    self.highPrice = @"";
    [self.topView restAction];
    for (NSInteger i=0; i<self.dataArry.count; i++) {
        LGSelectSectionModel *sectionModel = self.dataArry[i];
        NSArray *itemArry = sectionModel.dataArry;
        NSMutableArray *tempArry = [NSMutableArray array];
        for (NSInteger j=0; j<itemArry.count; j++) {
            LGSelectItemModel *itemModel = itemArry[j];
            itemModel.status = @"N";
            [tempArry addObject:itemModel];
        }
        sectionModel.dataArry = tempArry;
        [self.dataArry replaceObjectAtIndex:i withObject:sectionModel];
    }
    [self.collectionView reloadData];
}

//确定
-(void)sureBtnTapAction{
    NSString *brandIds = @"";
    for (NSInteger i=0; i<self.dataArry.count; i++) {
        LGSelectSectionModel *sectionModel = self.dataArry[i];
        NSArray *itemArry = sectionModel.dataArry;
        for (NSInteger j=0; j<itemArry.count; j++) {
            LGSelectItemModel *itemModel = itemArry[j];
            if ([itemModel.status isEqualToString:@"Y"]) {
                if (brandIds.length>0) {
                    brandIds =[NSString stringWithFormat:@"%@,%@",brandIds,itemModel.itemId];
                }else{
                    brandIds =[NSString stringWithFormat:@"%@",itemModel.itemId];
                }
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(selectLowPrice:highPrice:brands:)]) {
        [self.delegate selectLowPrice:self.lowPrice highPrice:self.highPrice brands:brandIds];
        [self removeAnimation];
    }
}

-(void)showAnimation{
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundColor = [UIColor colorWithString:@"000000" alpha:0.5];
        self.collectionView.frame = CGRectMake(Screen_W-viewPix(290), 0, viewPix(290), Screen_H);
        self.resetBtn.frame = CGRectMake(Screen_W-viewPix(290), Screen_H-viewPix(45), viewPix(290)/2.0, viewPix(45));
        self.sureBtn.frame = CGRectMake(Screen_W-viewPix(290)/2.0, Screen_H-viewPix(45), viewPix(290)/2.0, viewPix(45));
    }];
}

-(void)removeAnimation{
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundColor = [UIColor colorWithString:@"000000" alpha:0];
        self.collectionView.frame = CGRectMake(Screen_W, 0, viewPix(290), Screen_H);
        self.resetBtn.frame = CGRectMake(Screen_W, Screen_H-viewPix(45), viewPix(290)/2.0, viewPix(45));
        self.sureBtn.frame = CGRectMake(Screen_W+viewPix(290)/2.0, Screen_H-viewPix(45), viewPix(290)/2.0, viewPix(45));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.collectionView.frame, point)) {
        [self endEditing:YES];
        return NO;
    }
    return YES;
}


#pragma mark -- collectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArry.count+1;
}
//返回cell的个数，默认一组
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        LGSelectSectionModel *sectionModel = self.dataArry[section-1];
        NSArray *tempArry = sectionModel.dataArry;
        NSInteger maxCount = [sectionModel.defaultCount integerValue];
        if (tempArry.count<=maxCount) {
            return tempArry.count;
        }else{
            if ([sectionModel.open isEqualToString:@"Y"]) {
                return tempArry.count;
            }else{
                return maxCount;
            }
        }
    }
}

//加载cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LGSelectCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsCell" forIndexPath:indexPath];
    LGSelectSectionModel *sectionModel = self.dataArry[indexPath.section-1];
    NSArray *tempArry = sectionModel.dataArry;
    cell.model = tempArry[indexPath.item];
    return cell;
}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section>0) {
        LGSelectCollectionCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        cell.baseBtn.selected = !cell.baseBtn.selected;
        LGSelectSectionModel *sectionModel = self.dataArry[indexPath.section-1];
        NSMutableArray *tempArry = [NSMutableArray arrayWithArray:sectionModel.dataArry];
        LGSelectItemModel *itemModel = tempArry[indexPath.item];
        if ([itemModel.status isEqualToString:@"Y"]) {
            itemModel.status = @"N";
        }else{
            itemModel.status = @"Y";
        }
        [tempArry replaceObjectAtIndex:indexPath.item withObject:itemModel];
        sectionModel.dataArry = tempArry;
        [self.dataArry replaceObjectAtIndex:indexPath.section-1 withObject:sectionModel];
        
    }
}

// 设置头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(Screen_W, topBarHeight+viewPix(17));
    }else if(section == 1){
        return CGSizeMake(Screen_W, viewPix(45));
    }else{
        return CGSizeMake(Screen_W, viewPix(60));
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, viewPix(8), 0, viewPix(8));//分别为上、左、下、右
}

//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LGSelectPriceView *topView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"priceView" forIndexPath:indexPath];
        topView.delegate = self;
        self.topView = topView;
        return topView;
    }else{
        LGSelectSectionModel *model = self.dataArry[indexPath.section-1];
        LGSelectSectionView *topView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionView" forIndexPath:indexPath];
        topView.title = model.sectionTitle;
        topView.section = indexPath.section;
        if ([model.open isEqualToString:@"Y"]) {
            topView.shouldSelected = YES;
        }else{
            topView.shouldSelected = NO;
        }
        topView.delegate = self;
        if (indexPath.section == 1) {
            topView.showLine = NO;
        }else{
            topView.showLine = YES;
        }
        return topView;
    }
}

#pragma mark -- 懒加载+布局
-(NSMutableArray *)dataArry{
    if (!_dataArry) {
        _dataArry = [NSMutableArray array];
    }
    return _dataArry;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //创建layer层
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置同行之间cell的间隙
        layout.minimumInteritemSpacing = viewPix(8);
        //设置两行之间的间隙
        layout.minimumLineSpacing = viewPix(8);
        //设置cell的宽高
        layout.itemSize = CGSizeMake(viewPix(85), viewPix(36));
        //滚动方向
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        //创建UICollectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(Screen_W, 0, viewPix(290), Screen_H-viewPix(45)) collectionViewLayout:layout];
        //滚动条
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        //设置背景
        _collectionView.backgroundColor = [UIColor whiteColor];
        //设置是否可以滚动
        _collectionView.scrollEnabled = YES;
        // 取消弹簧效果
        _collectionView.bounces = YES;
        //代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        //注册cell   ->代码cell
        [self.collectionView registerClass:[LGSelectCollectionCell class] forCellWithReuseIdentifier:@"goodsCell"];
        //创建头部视图
        [self.collectionView registerClass:[LGSelectPriceView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"priceView"];
        //创建头部视图
        [self.collectionView registerClass:[LGSelectSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionView"];
    }
    return _collectionView;
}

-(UIButton *)resetBtn{
    if (!_resetBtn) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetBtn.frame = CGRectMake(Screen_W, Screen_H-viewPix(45), viewPix(290)/2.0, viewPix(45));
        [_resetBtn setTitleColor:RGB(255, 0, 82) forState:UIControlStateHighlighted];
        [_resetBtn setTitleColor:RGB(255, 0, 82) forState:UIControlStateNormal];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        _resetBtn.backgroundColor = RGB(251, 233, 233);
        _resetBtn.titleLabel.font = LGFont(17);
        [_resetBtn addTarget:self action:@selector(resetBtnTapAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}

-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(Screen_W+viewPix(290)/2.0, Screen_H-viewPix(45), viewPix(290)/2.0, viewPix(45));
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.backgroundColor = RGB(252, 17, 86);
        _sureBtn.titleLabel.font = LGFont(17);
        [_sureBtn addTarget:self action:@selector(sureBtnTapAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end
