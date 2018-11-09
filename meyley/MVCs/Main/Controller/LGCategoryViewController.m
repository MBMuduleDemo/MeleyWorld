//
//  LGCategoryViewController.m
//  meyley
//
//  Created by Bovin on 2018/8/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGCategoryViewController.h"
#import "LGCategoryTableViewCell.h"
#import "LGCategoryCollectionCell.h"
#import "LGChildCategoryReusableView.h"
#import "LGGoodsListViewController.h"

@interface LGCategoryViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UITableView *categoryTableView;

@property (nonatomic, strong) UICollectionView *detailCollectionView;

@property (nonatomic, strong) NSArray *categoryArray;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSIndexPath *selectCategoryIndexPath;


@end

static NSString *const categoryTableViewCell = @"categoryTableViewCell";
static NSString *const categoryCollectionCell = @"categoryCollectionCell";
static NSString *const categoryCollectionHeader = @"categoryCollectionHeader";
@implementation LGCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(245, 245, 245);
    self.selectCategoryIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.view addSubview:self.categoryTableView];
    [self.view addSubview:self.detailCollectionView];
    [self requestGoodsCategory];
}
#pragma mark--网络请求-----
-(void)requestGoodsCategory{
    [RequestUtil withGET:@"/api/ecs/goods/category.action" parameters:@"" success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.categoryArray = responseObject[@"result"];
        [self.categoryTableView reloadData];
        [self tableView:self.categoryTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)setCategoryArray:(NSArray *)categoryArray{
    _categoryArray = categoryArray;
    self.dataArray = categoryArray[0][@"children"];
    [self.detailCollectionView reloadData];
}


#pragma mark--UITableViewDataSource------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.categoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryTableViewCell forIndexPath:indexPath];
    if (indexPath.row < self.categoryArray.count) {
        NSDictionary *dic = self.categoryArray[indexPath.row];
        cell.titleText = [NSString stringWithFormat:@"%@",dic[@"catName"]];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return viewPix(49);
}
#pragma mark---UITableViewDelegate------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LGCategoryTableViewCell *cell = (LGCategoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (self.selectCategoryIndexPath != indexPath) {
        LGCategoryTableViewCell *selectCell = (LGCategoryTableViewCell *)[tableView cellForRowAtIndexPath:self.selectCategoryIndexPath];
        selectCell.selected = NO;
    }
    cell.selected = YES;
    self.selectCategoryIndexPath = indexPath;
    self.dataArray = self.categoryArray[indexPath.row][@"children"];
    [self.detailCollectionView reloadData];
}
#pragma mark--UICollectionViewDataSource------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *tempArry = self.dataArray[section][@"children"];
    return tempArry.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LGCategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:categoryCollectionCell forIndexPath:indexPath];
    NSArray *tempArry = self.dataArray[indexPath.section][@"children"];
    if (indexPath.item < tempArry.count) {
        cell.titleText = [NSString stringWithFormat:@"%@",tempArry[indexPath.item][@"catName"]];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        LGChildCategoryReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:categoryCollectionHeader forIndexPath:indexPath];
        header.titleText = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.section][@"catName"]];
        __weak typeof(self) weakSelf = self;
        header.secondCategoryHeaderAction = ^{
            LGGoodsListViewController *contrller = [[LGGoodsListViewController alloc]init];
            contrller.dataDic = weakSelf.dataArray[indexPath.section];
            contrller.selectIndex = 0;
            [weakSelf.navigationController pushViewController:contrller animated:YES];
        };
        return header;
    }
    return nil;
}
#pragma mark--UICollectionViewDelegateFlowLayout---
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((Screen_W-viewPix(125)-2)/3, viewPix(44));
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(1, viewPix(49));
}
#pragma mark---UICollectionViewDelegate----
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LGGoodsListViewController *contrller = [[LGGoodsListViewController alloc]init];
    contrller.dataDic = self.dataArray[indexPath.section];
    contrller.selectIndex = indexPath.item+1;
    [self.navigationController pushViewController:contrller animated:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.categoryTableView.frame = CGRectMake(0, 0, viewPix(100), self.view.frame.size.height);
    self.detailCollectionView.frame = CGRectMake(CGRectGetMaxX(self.categoryTableView.frame), 0, Screen_W-viewPix(100), self.view.frame.size.height);
}
#pragma mark---lazy------
- (UITableView *)categoryTableView {
    
    if (!_categoryTableView) {
        
        _categoryTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _categoryTableView.dataSource = self;
        _categoryTableView.delegate = self;
        _categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _categoryTableView.bounces = NO;
        _categoryTableView.backgroundColor = [UIColor whiteColor];
        _categoryTableView.showsVerticalScrollIndicator = NO;
        _categoryTableView.showsHorizontalScrollIndicator = NO;
        [_categoryTableView registerClass:[LGCategoryTableViewCell class] forCellReuseIdentifier:categoryTableViewCell];
        if (kAPIVersion11Later) {
            _categoryTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _categoryTableView;
}
- (UICollectionView *)detailCollectionView {
    
    if (!_detailCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.sectionInset = UIEdgeInsetsMake(0, viewPix(11), 0, viewPix(14));
        layout.minimumLineSpacing = 1.0;
        layout.minimumInteritemSpacing = 1.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _detailCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _detailCollectionView.dataSource = self;
        _detailCollectionView.delegate = self;
        _detailCollectionView.allowsMultipleSelection = YES;
        _detailCollectionView.backgroundColor = RGB(245, 245, 245);
        if (kAPIVersion11Later) {
            _detailCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_detailCollectionView registerClass:[LGCategoryCollectionCell class] forCellWithReuseIdentifier:categoryCollectionCell];
        [_detailCollectionView registerClass:[LGChildCategoryReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:categoryCollectionHeader];
    }
    return _detailCollectionView;
}
@end
