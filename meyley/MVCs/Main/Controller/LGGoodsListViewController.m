//
//  LGGoodsListViewController.m
//  meyley
//
//  Created by Bovin on 2018/8/5.
//  Copyright © 2018年 Meyley. All rights reserved.
//  商品列表页

#import "LGGoodsListViewController.h"
#import "MBSegmentScrollView.h"
#import "MBSegmentStyle.h"
#import "LGCategoryGoodsCell.h"
#import "LGCategorySelectView.h"
#import "LGGoodsDetailViewController.h"
#import "LGSelectSectionModel.h"
#import "LGSelectItemModel.h"
#import "LGEmptyView.h"
@interface LGGoodsListViewController ()<UITableViewDataSource,UITableViewDelegate,LGCategorySelectDelegate>

@property (nonatomic , strong)MBSegmentScrollView *topScrollView;

@property (nonatomic , strong)UITableView *myTableView;

@property (nonatomic, strong)LGEmptyView *emptyView;

@property (nonatomic , strong)NSArray *titleArry;

@property (nonatomic , strong)NSArray *dataArry;
//筛选相关
@property (nonatomic , strong)NSArray *categoryArry;
@property (nonatomic , strong)NSArray *brandArry;
@property (nonatomic , assign)NSInteger index;

@property (nonatomic , copy)NSString *currentCatId;
@end

@implementation LGGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    MBSegmentStyle *style = [[MBSegmentStyle alloc]init];
    style.titleCornerRadius = viewPix(15);
    style.selectedTitleColor = [UIColor whiteColor];
    style.normalTitleColor = RGB(102, 102, 102);
    style.normalBackColor = [UIColor colorWithString:@"e0e0e0"];
    style.selectedBackColor = RGB(255, 0, 102);
    style.titleMargin = viewPix(30);
    style.edgeMargin = viewPix(5);
    self.topScrollView = [[MBSegmentScrollView alloc]initWithFrame:CGRectMake(0, viewPix(20), Screen_W-viewPix(50), viewPix(30)) segmentStyle:style titles:self.titleArry margin:viewPix(15) titleDidClick:^(UILabel *titleLabel, NSInteger index) {
        NSLog(@">>???>>>%ld--%@",index,titleLabel.text);
        self.index = index;
        if (index == 0) {
            [self requestDataWithCatId:self.catId];
        }else{
            NSDictionary *dic = self.dataDic[@"children"][index-1];
            if ([dic[@"children"] count]>0) {
                //跳转
                LGGoodsListViewController *contrller = [[LGGoodsListViewController alloc]init];
                contrller.dataDic = dic;
                contrller.catId = [NSString stringWithFormat:@"%@",dic[@"catId"]];
                [self.navigationController pushViewController:contrller animated:YES];
                [self.topScrollView setSelectedIndex:0 animated:NO];
            }else{
                //刷新
                [self requestDataWithCatId:[NSString stringWithFormat:@"%@",dic[@"catId"]]];
            }
        }
    }];
    [self.topScrollView setSelectedIndex:self.selectIndex animated:YES];
    [self.view addSubview:self.topScrollView];
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(Screen_W-viewPix(50), viewPix(20), viewPix(50), viewPix(30));
    [moreBtn setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateHighlighted];
    [moreBtn addTarget:self action:@selector(selectBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];
    [self requestDataWithCatId:@""];
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.emptyView];
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.navigationItem.title = dataDic[@"catName"];
    self.catId = [NSString stringWithFormat:@"%@",dataDic[@"catId"]];
    NSMutableArray *tempArry = [NSMutableArray array];
    NSMutableArray *titleArry = [NSMutableArray array];
    LGSelectItemModel *model = [LGSelectItemModel mj_objectWithKeyValues:@{@"status":@"Y",@"title":@"综合",@"itemId":self.catId}];
    [tempArry addObject:model];
    [titleArry addObject:@"综合"];
    NSArray *childArry = dataDic[@"children"];
    for (NSInteger i=0; i<childArry.count; i++) {
        LGSelectItemModel *model = [LGSelectItemModel mj_objectWithKeyValues:@{@"status":@"N",@"title":childArry[i][@"catName"],@"itemId":[NSString stringWithFormat:@"%@",childArry[i][@"catId"]]}];
        [tempArry addObject:model];
        [titleArry addObject:childArry[i][@"catName"]];
    }
    self.titleArry = titleArry;
    self.categoryArry = tempArry;
}

-(void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
}

-(void)requestDataWithCatId:(NSString *)catId{
    self.currentCatId = catId;
    NSString *action = [NSString stringWithFormat:@"page=1&pageSize=1000&catId=%@&sortBy=%@",catId,@"latest"];
    [RequestUtil withGET:@"/api/ecs/goods/list.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            //            self.emptyView.hidden = YES;
            self.dataArry = responseObject[@"result"][@"goodsList"];
            [self.myTableView reloadData];
            //品牌列表
            NSArray *tempArry = responseObject[@"result"][@"brandList"];
            NSMutableArray *brandArry = [NSMutableArray array];
            for (NSInteger i=0; i<tempArry.count; i++) {
                NSDictionary *dic = tempArry[i];
                LGSelectItemModel *model = [LGSelectItemModel mj_objectWithKeyValues:@{@"status":@"N",@"title":dic[@"brandName"],@"itemId":[NSString stringWithFormat:@"%@",dic[@"brandId"]]}];
                [brandArry addObject:model];
            }
            self.brandArry = brandArry;
        }else{
            //            [self.emptyView showViewWithDes:@"暂无商品"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //        [self.emptyView showViewWithDes:@"网络请求失败，请重试"];
    }];
}

-(void)selectLowPrice:(NSString *)lowPrice highPrice:(NSString *)highPrice brands:(NSString *)brandIds{
    NSString *action = [NSString stringWithFormat:@"page=1&pageSize=1000&catId=%@&startPrice=%@&endPrice=%@&brandIds=%@",self.currentCatId,lowPrice,highPrice,brandIds];

    [RequestUtil withGET:@"/api/ecs/goods/list.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        if ([status isEqualToString:@"1"]) {
            self.emptyView.hidden = YES;
            self.dataArry = responseObject[@"result"][@"goodsList"];
            [self.myTableView reloadData];
           
        }else{
            [self.emptyView showViewWithDes:@"暂无商品"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self.emptyView showViewWithDes:@"网络请求失败，请重试"];
    }];
}

-(void)selectBtnAction{
    LGCategorySelectView *selectView = [[LGCategorySelectView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
//    LGSelectSectionModel *categoryModel = [LGSelectSectionModel mj_objectWithKeyValues:@{@"sectionTitle":@"分类",@"defaultCount":@"9",@"open":@"N",@"dataArry":self.categoryArry}];
    LGSelectSectionModel *brandModel = [LGSelectSectionModel mj_objectWithKeyValues:@{@"sectionTitle":@"品牌",@"defaultCount":@"12",@"open":@"N",@"dataArry":self.brandArry}];
//    [selectView.dataArry addObject:categoryModel];
    [selectView.dataArry addObject:brandModel];
    selectView.delegate = self;
    [self.view.window addSubview:selectView];
}

#pragma mark -- collectionViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGCategoryGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[LGCategoryGoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row < self.dataArry.count) {
        cell.dataDic = self.dataArry[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataArry.count) {
        LGGoodsDetailViewController *controller = [[LGGoodsDetailViewController alloc]init];
        controller.goodsId = [NSString stringWithFormat:@"%@",self.dataArry[indexPath.row][@"goodsId"]];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma mark -- 懒加载
-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, viewPix(70), Screen_W, Screen_H-topBarHeight-viewPix(70)) style:UITableViewStylePlain];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.rowHeight = viewPix(120);
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
    }
    return _myTableView;
}

-(LGEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[LGEmptyView alloc]initWithFrame:CGRectMake(0, viewPix(70), Screen_W, Screen_H-topBarHeight-viewPix(70))];
        _emptyView.backgroundColor = [UIColor whiteColor];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}


@end
