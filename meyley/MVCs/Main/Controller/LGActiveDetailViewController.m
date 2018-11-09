//
//  LGActiveDetailViewController.m
//  meyley
//
//  Created by Bovin on 2018/8/5.
//  Copyright © 2018年 Meyley. All rights reserved.
//  活动详情页

#import "LGActiveDetailViewController.h"
#import "LGCollectionFlowLayout.h"
#import "LGActiveDetailTopView.h"
#import "LGActiveGoodsCell.h"
/**  跳转页面 */
#import "LGGoodsDetailViewController.h"
@interface LGActiveDetailViewController ()<UICollectionViewDataSource , UICollectionViewDelegate>
@property (nonatomic , strong)UICollectionView *collectionView;
@property (nonatomic , copy)NSString *endTime;
@property (nonatomic , copy)NSString *actName;
@property (nonatomic , copy)NSString *logoImage;
@property (nonatomic , strong)NSArray *goodsArry;
@property (nonatomic , strong)NSTimer *timer;
@end

@implementation LGActiveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    self.navigationItem.title = [NSString stringWithFormat:@"%@",self.dataDic[@"actName"]];
    [self.view addSubview:self.collectionView];
}

-(void)setActName:(NSString *)actName{
    _actName = actName;
    self.navigationItem.title = actName;
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.endTime = [NSString stringWithFormat:@"%@",dataDic[@"endTime"]];
    self.logoImage = [NSString stringWithFormat:@"%@",dataDic[@"logo"]];
}

-(void)requestData{
    NSString *paramer = [NSString stringWithFormat:@"pageSize=10000&page=1&actId=%@",self.activeId.length?self.activeId:self.dataDic[@"actId"]];
    [RequestUtil withGET:@"/api/mw/activity/goods/list.action" parameters:paramer success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        if ([status isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"result"];
            self.logoImage = [NSString stringWithFormat:@"%@",dic[@"logo"]];
            self.actName = [NSString stringWithFormat:@"%@",dic[@"actName"]];
            self.endTime = [NSString stringWithFormat:@"%ld",[dic[@"endTime"] integerValue]/1000];
            self.goodsArry = dic[@"goodsList"];
            [self.collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}



#pragma mark -- collectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
//返回cell的个数，默认一组
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 1) {
        return self.goodsArry.count;
    }
    return 0;
}

//加载cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LGActiveGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsCell" forIndexPath:indexPath];
    if (indexPath.item < self.goodsArry.count) {
        cell.dataDic = self.goodsArry[indexPath.item];
    }
    return cell;
}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item<self.goodsArry.count) {
        NSDictionary *dic = self.goodsArry[indexPath.item];
        LGGoodsDetailViewController *contrller = [[LGGoodsDetailViewController alloc]init];
        contrller.goodsId = [NSString stringWithFormat:@"%@",dic[@"goodsId"]];
        [self.navigationController pushViewController:contrller animated:YES];
    }
}

// 设置头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(Screen_W, viewPix(150));
    }else{
        return CGSizeMake(Screen_W, viewPix(60));
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
        UICollectionReusableView *topView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewLogoBG" forIndexPath:indexPath];
        for (UIImageView *imageView in topView.subviews) {
            [imageView removeFromSuperview];
        }
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(150))];
        [bgImageView sd_setImageWithURL:[NSURL URLWithString:self.logoImage]];
        [topView addSubview:bgImageView];
        return topView;
    }else{
        LGActiveDetailTopView *topView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewTimeBG" forIndexPath:indexPath];
        topView.endTime = self.endTime;
        topView.logoImage = self.logoImage;
        return topView;
    }
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
        
        //设置cell的宽高
        layout.itemSize = CGSizeMake((Screen_W-viewPix(10))/2.0, viewPix(275));
        //滚动方向
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        //创建UICollectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight) collectionViewLayout:layout];
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
        [self.collectionView registerClass:[LGActiveGoodsCell class] forCellWithReuseIdentifier:@"goodsCell"];
        //创建头部视图
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewLogoBG"];
        
        [self.collectionView registerClass:[LGActiveDetailTopView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewTimeBG"];
    }
    return _collectionView ;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
