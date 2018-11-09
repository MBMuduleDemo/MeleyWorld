//
//  LGBrandViewController.m
//  meyley
//
//  Created by Bovin on 2018/8/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGBrandViewController.h"
#import "LGBrandCollectionCell.h"
#import "LGBrandDetailViewController.h"
@interface LGBrandViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *brandCollectionView;
@property (nonatomic, strong)NSMutableArray *brandArry;
@property (nonatomic , copy)NSString *currentPage;
@end
static NSString *const brandCollectionCell = @"brandCollectionCell";
@implementation LGBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(245, 245, 245);
    [self.view addSubview:self.brandCollectionView];
    self.currentPage = @"1";
    [self requestBrandList];
}
/**获取所有的品牌数据*/
-(void)requestBrandList{
    NSString *parameter = [NSString stringWithFormat:@"pageSize=12&page=%@",self.currentPage];
    [RequestUtil withGET:@"/api/ecs/brand/list.action" parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        if ([status isEqualToString:@"1"]) {
            if ([self.currentPage isEqualToString:@"1"]) {
                [self.brandArry removeAllObjects];
            }
            NSDictionary *dic = responseObject[@"result"];
            if ([dic[@"curPage"] integerValue] < [dic[@"totalPage"] integerValue]) {
                self.currentPage = [NSString stringWithFormat:@"%ld",[dic[@"curPage"] integerValue]+1];
                [self.brandCollectionView.mj_footer endRefreshing];
            }else {
                [self.brandCollectionView.mj_footer endRefreshingWithNoMoreData];
            }
            NSArray *tmpArr = responseObject[@"result"][@"brandList"];
            [self.brandArry addObjectsFromArray:tmpArr];
            [self.brandCollectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark---UICollectionViewDataSource---
//返回cell的个数，默认一组
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.brandArry.count;
}

//加载cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LGBrandCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:brandCollectionCell forIndexPath:indexPath];
    if (indexPath.item < self.brandArry.count) {
        cell.dataDic = self.brandArry[indexPath.item];
    }
    return cell;
}
#pragma mark--UICollectionViewDelegate-----
//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item<self.brandArry.count) {
        NSDictionary *dic = self.brandArry[indexPath.item];
        LGBrandDetailViewController *controller = [[LGBrandDetailViewController alloc]init];
        controller.brandId = [NSString stringWithFormat:@"%@",dic[@"brandId"]];
        controller.brandName = [NSString stringWithFormat:@"%@",dic[@"chineseName"]];
        controller.brandImage = [NSString stringWithFormat:@"%@",dic[@"brandLogo"]];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    
}


#pragma mark--lazy------

- (UICollectionView *)brandCollectionView {
    
    if (!_brandCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
        layout.minimumInteritemSpacing = 8;
        layout.minimumLineSpacing = 10;
        layout.itemSize = CGSizeMake((Screen_W-36)/3, (Screen_W-36)/3);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _brandCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight-44) collectionViewLayout:layout];
        _brandCollectionView.dataSource = self;
        _brandCollectionView.delegate = self;
        _brandCollectionView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        if (kAPIVersion11Later) {
            _brandCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_brandCollectionView registerClass:[LGBrandCollectionCell class] forCellWithReuseIdentifier:brandCollectionCell];
        _brandCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestBrandList)];
        
    }
    return _brandCollectionView;
}
- (NSMutableArray *)brandArry {
    if (!_brandArry) {
        _brandArry = [NSMutableArray array];
    }
    return _brandArry;
}
@end
