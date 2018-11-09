//
//  LGBargainListViewController.m
//  meyley
//
//  Created by Bovin on 2018/8/5.
//  Copyright © 2018年 Meyley. All rights reserved.
//  特价列表页

#import "LGBargainListViewController.h"
#import "LGCollectionFlowLayout.h"
#import "LGActiveDetailTopView.h"
#import "LGActiveGoodsCell.h"
/**  跳转页面 */
#import "LGGoodsDetailViewController.h"
@interface LGBargainListViewController ()<UICollectionViewDataSource , UICollectionViewDelegate>

@property (nonatomic , strong)UICollectionView *collectionView;
@property (nonatomic , strong)NSArray *goodsArry;


@end

@implementation LGBargainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"今日特价";
    [self.view addSubview:self.collectionView];
    [self requestData];
}

-(void)requestData{
    NSString *action = [NSString stringWithFormat:@"page=1&pageSize=1000&actId=%@",@"all"];
    [RequestUtil withGET:@"/api/mw/activity/goods/list.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]){
            self.goodsArry = responseObject[@"result"][@"goodsList"];
            [self.collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark -- collectionViewDelegate
//返回cell的个数，默认一组
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsArry.count;
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




#pragma mark -- 懒加载
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //创建layer层
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
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
