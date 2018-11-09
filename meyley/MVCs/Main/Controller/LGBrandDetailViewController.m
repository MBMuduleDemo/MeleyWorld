//
//  LGBrandDetailViewController.m
//  meyley
//
//  Created by Bovin on 2018/8/5.
//  Copyright © 2018年 Meyley. All rights reserved.
//  品牌详情页

#import "LGBrandDetailViewController.h"
#import "LGCollectionFlowLayout.h"
#import "LGBrandTopView.h"
#import "LGBrandGoodsCell.h"
//商品详情
#import "LGGoodsDetailViewController.h"
//model
#import "LGBrandDetailModel.h"
//顶部品牌简介
#import "LGBrandTopHeaderView.h"
//点击品牌展示
#import "LGBrandIntroduceView.h"
#import "LGBrandCategoryView.h"

#import "AppDelegate.h"
#import "WKWebViewController.h"
//搜索结果
#import "LGSearchResultController.h"
//分类
#import "LGBrandCategoryController.h"


@interface LGBrandDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,LGBrandTopViewDelegate>

@property(nonatomic , strong)NSArray *dataArry;
@property(nonatomic , strong)UICollectionView *collectionView;

@property (nonatomic, strong) LGBrandDetailModel *detailModel;

@property (nonatomic, strong) LGBrandIntroduceView *introduceView;

@property (nonatomic, strong) LGBrandCategoryView *categoryView;

@end

@implementation LGBrandDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:@"#201341"] alpha:0.0]  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self.view addSubview:self.collectionView];
    [self requestData:@"latest" catId:@""];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:@"#201341"] alpha:0.0]  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewDidDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:ML_MAIN_COLOR]  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:ML_MAIN_COLOR];
    self.navigationController.navigationBar.translucent = NO;
  
    [super viewDidDisappear:animated];
    
}

-(void)requestData:(NSString *)sortBy catId:(NSString *)catId {
    NSString *action = [NSString stringWithFormat:@"page=1&pageSize=1000&sortBy=%@&brandId=%@&catId=%@",sortBy,self.brandId,catId];
    [RequestUtil withGET:@"/api/ecs/brand/detail.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"result"];
            self.detailModel = [LGBrandDetailModel mj_objectWithKeyValues:dic];
            self.brandId = [NSString stringWithFormat:@"%@",dic[@"brandId"]];
            self.brandName = [NSString stringWithFormat:@"%@",dic[@"brandName"]];
            self.brandImage = [NSString stringWithFormat:@"%@",dic[@"brandLogo"]];
           
            self.dataArry = dic[@"goodsList"];
            [self.collectionView reloadData];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
#pragma mark--LGBrandTopViewDelegate---
-(void)selectSearchKey:(NSString *)searchKey{
    [self requestData:searchKey catId:@""];
}
- (void)filterBrandChildCategoryGoods {
    self.categoryView = [[LGBrandCategoryView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    self.categoryView.model = self.detailModel;
    __weak typeof(self)weakSelf = self;
    self.categoryView.SearchGoodsBlock = ^(NSString *keyWords) {
        LGSearchResultController *searchVC = [LGSearchResultController new];
        searchVC.seachBrandId = weakSelf.detailModel.brandId;
        searchVC.keywords = keyWords;
        searchVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:searchVC animated:YES];
    };
    self.categoryView.FilterGoodsBlock = ^(NSString *catId) {
        [weakSelf requestData:@"latest" catId:catId];
    };
    [self.view.window addSubview:self.categoryView];
}

#pragma mark--UICollectionViewDataSource---
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
//返回cell的个数，默认一组
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 1) {
        return self.dataArry.count;
    }
    return 0;
}

//加载cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LGBrandGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsCell" forIndexPath:indexPath];
    if (indexPath.item < self.dataArry.count) {
        cell.dataDic = self.dataArry[indexPath.item];
    }
    return cell;
}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item < self.dataArry.count) {
        NSDictionary *dic = self.dataArry[indexPath.item];
        LGGoodsDetailViewController *contrller = [[LGGoodsDetailViewController alloc]init];
        contrller.goodsId = [NSString stringWithFormat:@"%@",dic[@"goodsId"]];
        [self.navigationController pushViewController:contrller animated:YES];
    }
}

// 设置头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(Screen_W, viewPix(200));
    }else{
        return CGSizeMake(Screen_W, viewPix(45));
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return UIEdgeInsetsMake(0, 0, viewPix(10), 0);//分别为上、左、下、右
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}

//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        LGBrandTopHeaderView *topView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewLogoBG" forIndexPath:indexPath];
        topView.model = self.detailModel;
        __weak typeof(self)weakSelf = self;
        topView.showBrandIntroduceBlock = ^{
            [weakSelf showBrandIntroduce];
        };
        return topView;
    }else{
        LGBrandTopView *topView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewTimeBG" forIndexPath:indexPath];
        topView.backgroundColor = [UIColor whiteColor];
        topView.delegate = self;
//        topView.endTime = self.endTime;
//        topView.logoImage = self.logoImage;
        return topView;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = self.collectionView.contentOffset.y;
    CGFloat alpha = (CGFloat)offset/(viewPix(195)-topBarHeight);
    if (alpha<1.0) {
        self.navigationItem.title = @"";
        self.navigationController.navigationBar.translucent = YES;
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"%@%@",self.detailModel.brandName.length?self.detailModel.brandName:@"",self.detailModel.englishName.length?self.detailModel.englishName:@""];
        self.navigationController.navigationBar.translucent = NO;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:@"#201341"] alpha:alpha]  forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView.alpha = alpha;
}

#pragma mark--action---
//展示品牌简介
- (void)showBrandIntroduce {
    self.introduceView = [[LGBrandIntroduceView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    self.introduceView.model = self.detailModel;
    __weak typeof(self)weakSelf = self;
    self.introduceView.BrandIntroduceActionBlock = ^(NSInteger index) {
        if (index == 0) {   //品牌首页
            [weakSelf.introduceView hideAnimation];
        }else if (index == 1) { //关于品牌
            WKWebViewController *webVC = [WKWebViewController new];
            [webVC loadHTMLString:weakSelf.detailModel.desc withTitle:@"关于品牌"];
            webVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:webVC animated:YES];
        }else if (index == 2){ //购物车
            AppDelegate *ap = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            ap.rootViewController.selectedIndex = 3;
        }else if (index == 3) { //用户头像
            [weakSelf.introduceView hideAnimation];
            AppDelegate *ap = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            ap.rootViewController.selectedIndex = 4;
        }else if (index == 4) {//分类
            [weakSelf.introduceView hideAnimation];
            LGBrandCategoryController *controller = [[LGBrandCategoryController alloc]init];
            controller.selectType = LGShowTypeCategory;
            controller.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }else { //品牌商城
            [weakSelf.introduceView hideAnimation];
            AppDelegate *ap = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            ap.rootViewController.selectedIndex = 0;
        }
    };
    [self.view.window addSubview:self.introduceView];
}

#pragma mark -- 懒加载
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //创建layer层
        LGCollectionFlowLayout *layout = [[LGCollectionFlowLayout alloc] init];
        //设置同行之间cell的间隙
        layout.minimumInteritemSpacing = viewPix(10);
        //设置两行之间的间隙
        layout.minimumLineSpacing = 0;
        layout.navHeight = topBarHeight;
        //设置cell的宽高
        layout.itemSize = CGSizeMake((Screen_W-viewPix(10))/2.0, viewPix(248));
        //滚动方向
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        //创建UICollectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -topBarHeight, Screen_W, Screen_H) collectionViewLayout:layout];
        //滚动条
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        //设置背景
        _collectionView.backgroundColor = RGB(245, 245, 245);
        //设置是否可以滚动
        _collectionView.scrollEnabled = YES;
        // 取消弹簧效果
        _collectionView.bounces = YES;
        //代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        //注册cell   ->代码cell
        [self.collectionView registerClass:[LGBrandGoodsCell class] forCellWithReuseIdentifier:@"goodsCell"];
        //创建头部视图
        [self.collectionView registerClass:[LGBrandTopHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewLogoBG"];
        
        [self.collectionView registerClass:[LGBrandTopView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewTimeBG"];
    }
    return _collectionView ;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
