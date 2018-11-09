//
//  MLMainViewController.m
//  meyley
//
//  Created by chsasaw on 2017/2/19.
//  Copyright © 2017年 Meyley. All rights reserved.
//  首页

#import "MLMainViewController.h"
#import "LGTopSearchView.h"
#import "DCCycleScrollView.h"
#import "LGCategoryView.h"
#import "LGHomeFooterView.h"
#import "LGHomeActiveCell.h"
#import "LGHomeHotGoodsCell.h"
/**  跳转VC */
//搜索
#import "LGSearchResultController.h"
//优惠活动列表
#import "LGActiveListViewController.h"
//优惠活动详情
#import "LGActiveDetailViewController.h"
//品牌详情
#import "LGBrandDetailViewController.h"
//首页优惠活动
#import "LGActiveDetailViewController.h"
//品牌分类界面LGGoodsDetailViewController
#import "LGBrandCategoryController.h"
//商品列表
#import "LGGoodsListViewController.h"
//今日特惠
#import "LGBargainListViewController.h"
//商品详情
#import "LGGoodsDetailViewController.h"


@interface MLMainViewController ()<LGSearchViewDelegate,DCCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,LGHomeHotGoodsDelegate,LGCategoryViewDelegate>

@property (nonatomic , strong)UITableView *myTableView;
@property (nonatomic , strong)LGTopSearchView *searchView;

@property (nonatomic , strong)DCCycleScrollView *topBannerView;

@property (nonatomic , strong)LGCategoryView *categoryView;

@property (nonatomic , strong)LGHomeFooterView *footerView;
//顶部
@property (nonatomic , strong)UIButton *topBtn;

@property (nonatomic , strong)UILabel *totalActiveLabel;
@property (nonatomic , strong)NSArray *topBannerArry;
@property (nonatomic , strong)NSArray *categoryArry;
@property (nonatomic , strong)NSArray *activeArry;
@property (nonatomic , strong)NSMutableArray *goodsArry;
@property (nonatomic , assign)BOOL haveMoreData;
@property (nonatomic , copy)NSString *currentPage;
@property (nonatomic , copy)NSString *totalPage;

//记录数据是否请求完成，判断刷新
@property (nonatomic, assign) BOOL isDataLoadFinish;

@end

@implementation MLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.hidesBottomBarWhenPushed = NO;
    
    //检查是否有更新
    [self checkAppIfNeedUpdate];

    self.navigationItem.leftBarButtonItem = nil;
    self.haveMoreData = YES;
    self.currentPage = @"1";
    
    [self refreshDataAction];
    self.searchView.cityArry = @[@"北京",@"上海",@"广州",@"杭州"];
   
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.topBtn];
}

- (void)checkAppIfNeedUpdate {
    
    //1.取到当前应用的版本号
    NSString *currentAppVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"%@",currentAppVersion);
    //2.获取AppStore应用信息

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:LGAppLookupVersionUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError *error;
        if (data && data.length>0) {
            id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                id result = [dic objectForKey:LGAppStoreResponseResult];
                if (result && [result isKindOfClass:[NSArray class]]) {
                    NSDictionary *tmpDic = [(NSArray *)result firstObject];
                    NSString *appStoreVersion = [tmpDic objectForKey:LGAppStoreVersion];
                    if (currentAppVersion && appStoreVersion && [currentAppVersion compare:appStoreVersion] != NSOrderedSame) {
                        //需要升级
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self updateAppVersionAlert];
                        });
                    }
                }
            }
        }
        
    });
}
- (void)updateAppVersionAlert {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"更新提示" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continuAciont = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *chartAction = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:LGAppDownloadUrl];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }];
    [alertController addAction:continuAciont];
    [alertController addAction:chartAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchView.searchTF resignFirstResponder];
}


#pragma mark -- 接口请求
-(void)refreshDataAction{
    self.isDataLoadFinish = NO;
    //轮播图
    [self requestTopAddData];

    //分类
    [self requestGoodsCategory];

    //活动
    [self requestActiveGoods];

    //热卖
    self.currentPage = @"1";
    [self requestHotGoods];
    
}
//首页轮播图
-(void)requestTopAddData{
    [RequestUtil withGET:@"/api/ecs/shop/index/ad.action" parameters:@"" success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.myTableView.mj_header endRefreshing];
        self.topBannerArry = responseObject[@"result"][@"adList"];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.myTableView.mj_header endRefreshing];
    }];
}

//分类
-(void)requestGoodsCategory{
    [RequestUtil withGET:@"/api/ecs/goods/category.action" parameters:@"" success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.myTableView.mj_header endRefreshing];
        self.categoryArry = responseObject[@"result"];
        self.categoryView.categoryArry = responseObject[@"result"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.myTableView.mj_header endRefreshing];
    }];
}

//活动
-(void)requestActiveGoods{
    [RequestUtil withGET:@"/api/mw/activity/list.action" parameters:@"pageSize=10&page=1" success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.myTableView.mj_header endRefreshing];
        NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        if ([status isEqualToString:@"1"]) {
            self.activeArry = responseObject[@"result"][@"activityList"];
            self.totalActiveLabel.text = [NSString stringWithFormat:@"共%ld个活动",self.activeArry.count];
            if (self.isDataLoadFinish) {
                [self.myTableView reloadData];
            }
        }
        self.isDataLoadFinish = YES;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.isDataLoadFinish = YES;
        [self.myTableView.mj_header endRefreshing];
    }];
}

//热卖
-(void)requestHotGoods{
    NSString *parameter = [NSString stringWithFormat:@"pageSize=12&page=%@",self.currentPage];
    [RequestUtil withGET:@"/api/ecs/goods/hot/list.action" parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.myTableView.mj_header endRefreshing];
        [_myTableView.mj_footer endRefreshing];
        NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        if ([status isEqualToString:@"1"]) {
            if ([self.currentPage isEqualToString:@"1"]) {
                [self.goodsArry removeAllObjects];
            }
            NSDictionary *dic = responseObject[@"result"];
            if ([dic[@"curPage"] integerValue] < [dic[@"totalPage"] integerValue]) {
                self.currentPage = [NSString stringWithFormat:@"%ld",[dic[@"curPage"] integerValue]+1];
            }else{
                self.haveMoreData = NO;
                self.myTableView.tableFooterView = self.footerView;
                [_myTableView.mj_footer endRefreshingWithNoMoreData];
                _myTableView.mj_footer.hidden = YES;
            }
            
            [self.goodsArry addObjectsFromArray:dic[@"goodsList"]];
            if (self.isDataLoadFinish) {
                [self.myTableView reloadData];
            }
        }
        self.isDataLoadFinish = YES;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.isDataLoadFinish = YES;
        [self.myTableView.mj_header endRefreshing];
        [_myTableView.mj_footer endRefreshing];
    }];
}


-(void)setTopBannerArry:(NSArray *)topBannerArry{
    _topBannerArry = topBannerArry;
    NSMutableArray *tempArry = [NSMutableArray array];
    for (NSInteger i=0; i<topBannerArry.count; i++) {
        NSDictionary *dic = topBannerArry[i];
        NSString *image = [NSString stringWithFormat:@"%@",dic[@"adPic"]];
        [tempArry addObject:image];
    }
    self.topBannerView.imgArr = tempArry;
}

#pragma mark -- 点击跳转事件
/** 轮播图点击图片回调 */
- (void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSDictionary *dic = self.topBannerArry[index];
    NSString *type = [NSString stringWithFormat:@"%@",dic[@"type4app"]];
    if ([type isEqualToString:@"1"]) {
        //商品详情
        LGGoodsDetailViewController *controller = [[LGGoodsDetailViewController alloc]init];
        controller.goodsId = [NSString stringWithFormat:@"%@",dic[@"params4app"][@"goodsId"]];
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([type isEqualToString:@"2"]){
        //品牌页
        LGBrandDetailViewController *controller = [[LGBrandDetailViewController alloc]init];
        controller.brandId = [NSString stringWithFormat:@"%@",dic[@"params4app"][@"brandId"]];
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([type isEqualToString:@"3"]){
        //活动详情
        LGActiveDetailViewController *controller = [[LGActiveDetailViewController alloc]init];
        controller.activeId = [NSString stringWithFormat:@"%@",dic[@"params4app"][@"activityId"]];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if ([type isEqualToString:@"4"]){
        //分类
        LGGoodsListViewController *contrller = [[LGGoodsListViewController alloc]init];
        contrller.catId = [NSString stringWithFormat:@"%@",dic[@"params4app"][@"categoryId"]];
        [self.navigationController pushViewController:contrller animated:YES];
    }
    
}
//搜索
-(void)searchGoodsWithText:(NSString *)text{
    NSLog(@">>>????>>>搜索：%@",text);
    LGSearchResultController *searchVC = [LGSearchResultController new];
    searchVC.keywords = text;
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

//品牌
-(void)goToBrandPage{
    LGBrandCategoryController *brandVC = [LGBrandCategoryController new];
    brandVC.selectType = LGShowTypeBrand;
    [self.navigationController pushViewController:brandVC animated:YES];
}
//更多
-(void)goToMoreGoodsPage{
    LGBrandCategoryController *brandVC = [LGBrandCategoryController new];
    brandVC.selectType = LGShowTypeCategory;
    [self.navigationController pushViewController:brandVC animated:YES];
}
//分类列表
-(void)goToGoodsPageWithIndex:(NSInteger)index{
    LGGoodsListViewController *contrller = [[LGGoodsListViewController alloc]init];
    contrller.dataDic = self.categoryArry[index];
    [self.navigationController pushViewController:contrller animated:YES];
}

//今日特惠
-(void)goToTodayFavour{
    LGBargainListViewController *controller = [[LGBargainListViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}
//新品发布
-(void)goToNewGoodsActive{
    LGActiveListViewController *controller = [[LGActiveListViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

//最新热卖--商品
-(void)selectHotGoods:(NSDictionary *)dic{
    LGGoodsDetailViewController *controller = [[LGGoodsDetailViewController alloc]init];
    controller.goodsId = [NSString stringWithFormat:@"%@",dic[@"goodsId"]];
    [self.navigationController pushViewController:controller animated:YES];
}

//最新热卖--品牌
-(void)selectHotBrand:(NSDictionary *)dic{
    LGBrandDetailViewController *controller = [[LGBrandDetailViewController alloc]init];
    controller.brandId = [NSString stringWithFormat:@"%@",dic[@"brandId"]];
    controller.brandName = [NSString stringWithFormat:@"%@",dic[@"brandName"]];
    controller.brandImage = [NSString stringWithFormat:@"%@",dic[@"brandLogo"]];
    [self.navigationController pushViewController:controller animated:YES];
}

//回到顶部
-(void)goToTopAction{
    [self.myTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.myTableView.contentOffset.y>Screen_H*5) {
        self.topBtn.hidden = NO;
    }else{
        self.topBtn.hidden = YES;
    }
}

#pragma mark--UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.activeArry.count>0) {
            return (self.activeArry.count>6)?6:self.activeArry.count;
        }
        return 0;
    }else{
        return self.goodsArry.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LGHomeActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row < self.activeArry.count) {
            cell.dataDic = self.activeArry[indexPath.row];
            if (indexPath.row == [self.myTableView numberOfRowsInSection:0]-1) {
                cell.lineView.hidden = YES;
                
            }else{
                cell.lineView.hidden = NO;
            }
        }
        return cell;
    }else{
        LGHomeHotGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotGoodsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if (indexPath.row < self.goodsArry.count) {
            cell.dataDic = self.goodsArry[indexPath.row];
            if (indexPath.row == self.goodsArry.count-1) {
                cell.lineView.hidden = YES;
            }else{
                cell.lineView.hidden = NO;
                
            }
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row<self.activeArry.count) {
        NSDictionary *dic = self.activeArry[indexPath.row];
        LGActiveDetailViewController *controller = [[LGActiveDetailViewController alloc]init];
        controller.activeId = [NSString stringWithFormat:@"%@",dic[@"actId"]];
        controller.dataDic = dic;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return viewPix(235);
    }else{
        return viewPix(178);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return viewPix(40);
    }else{
        return 0.01;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 && self.activeArry.count>0) {
        return viewPix(85);
    }else if( section == 1 && self.haveMoreData == NO){
        return viewPix(60);
    }else{
        return 0.01;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(40))];
        UILabel *titleLabel = [UILabel lableWithFrame:CGRectZero text:@"最新热卖" textColor:RGB(34, 34, 34) font:15 textAlignment:NSTextAlignmentCenter lines:1];
        [baseView addSubview:titleLabel];
        
        UIView *leftLine = [[UIView alloc]init];
        leftLine.backgroundColor = RGB(34, 34, 34);
        [baseView addSubview:leftLine];
        
        UIView *rightLine = [[UIView alloc]init];
        rightLine.backgroundColor = RGB(34, 34, 34);
        [baseView addSubview:rightLine];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(baseView);
        }];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel);
            make.right.equalTo(titleLabel.mas_left).offset(-viewPix(10));
            make.width.equalTo(@(viewPix(50)));
            make.height.equalTo(@(1.0));
        }];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.width.height.equalTo(leftLine);
            make.left.equalTo(titleLabel.mas_right).offset(viewPix(10));
        }];
        return baseView;
    }else{
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 0.01)];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0 && self.activeArry.count>0) {
        UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(85))];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(viewPix(20), kMaxY(baseView.frame)-1.0, Screen_W-viewPix(40), 1.0)];
        lineView.backgroundColor = RGB(234, 234, 234);
        [baseView addSubview:lineView];
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame = CGRectMake((Screen_W-viewPix(121))/2.0, viewPix(20), viewPix(121), viewPix(40));
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"niu"] forState:UIControlStateNormal];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"niu"] forState:UIControlStateHighlighted];
        [moreBtn addTarget:self action:@selector(goToNewGoodsActive) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:moreBtn];
        
        UIImageView *tipImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon"]];//16*16
        [moreBtn addSubview:tipImageView];
        
        UILabel *titleLabel = [UILabel lableWithFrame:CGRectZero text:@"查看全部" textColor:RGB(255, 0, 102) font:13 textAlignment:NSTextAlignmentLeft lines:1];
        [moreBtn addSubview:titleLabel];
        [moreBtn addSubview:self.totalActiveLabel];
        
        
        [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(moreBtn);
            make.left.equalTo(moreBtn).offset(viewPix(15));
            make.width.height.equalTo(@(viewPix(16)));
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipImageView.mas_right).offset(viewPix(8));
            make.bottom.equalTo(moreBtn.mas_centerY);
        }];
        [self.totalActiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(moreBtn.mas_centerY).offset(viewPix(2));
        }];
        
        return baseView;
    }else if (section == 1 && self.haveMoreData == NO){
        UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(60))];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(viewPix(20), kMaxY(baseView.frame)-1.0, Screen_W-viewPix(40), 1.0)];
        lineView.backgroundColor = RGB(234, 234, 234);
        [baseView addSubview:lineView];
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame = CGRectMake((Screen_W-viewPix(103))/2.0, viewPix(5), viewPix(103), viewPix(30));
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"niu2"] forState:UIControlStateNormal];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"niu2"] forState:UIControlStateHighlighted];
        [moreBtn setTitleColor:RGB(255, 0, 102) forState:UIControlStateNormal];
        [moreBtn setTitleColor:RGB(255, 0, 102) forState:UIControlStateHighlighted];
        [moreBtn setTitle:@"更多品牌好货" forState:UIControlStateNormal];
        moreBtn.titleLabel.font = LGFont(12);
        [moreBtn addTarget:self action:@selector(goToMoreGoodsPage) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:moreBtn];
        return baseView;
    }else{
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 0.01)];
    }
}



#pragma mark -- 创建控件+布局
-(NSMutableArray *)goodsArry{
    if (!_goodsArry) {
        _goodsArry = [NSMutableArray array];
    }
    return _goodsArry;
}
-(LGTopSearchView *)searchView{
    if (!_searchView) {
        _searchView = [[LGTopSearchView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, topBarHeight+viewPix(25))];
        _searchView.delegate = self;
    }
    return _searchView;
}
-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMaxY(_searchView.frame), Screen_W, Screen_H-tabBarHeight-kMaxY(_searchView.frame)) style:UITableViewStyleGrouped];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_myTableView registerClass:[LGHomeActiveCell class] forCellReuseIdentifier:@"activeCell"];
        [_myTableView registerClass:[LGHomeHotGoodsCell class] forCellReuseIdentifier:@"hotGoodsCell"];
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataAction)];
        _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestHotGoods)];
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(150)+viewPix(278)+viewPix(25))];
        [headView addSubview:self.topBannerView];
        [headView addSubview:self.categoryView];
        _myTableView.tableHeaderView = headView;
        _myTableView.estimatedSectionHeaderHeight = 0;
        _myTableView.estimatedSectionFooterHeight = 0;
        _myTableView.estimatedRowHeight = 0;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        
    }
    return _myTableView;
}


-(DCCycleScrollView *)topBannerView{
    if (!_topBannerView) {
        _topBannerView = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Screen_W, viewPix(150)) shouldInfiniteLoop:YES imageGroups:nil];
        _topBannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _topBannerView.itemWidth = Screen_W - viewPix(60);
        _topBannerView.pageControl.currentPageIndicatorTintColor = RGB(250, 26, 104);
        _topBannerView.autoScrollTimeInterval = 2;
        _topBannerView.itemSpace = viewPix(10);
        _topBannerView.imgCornerRadius = 10;
        _topBannerView.autoScroll = YES;
        _topBannerView.delegate = self;
        _topBannerView.isZoom = NO;
    }
    return _topBannerView;
}


-(LGCategoryView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[LGCategoryView alloc]initWithFrame:CGRectMake(0, kMaxY(_topBannerView.frame)+viewPix(25), Screen_W, viewPix(278))];
        _categoryView.delegate = self;
    }
    return _categoryView;
}

-(LGHomeFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[LGHomeFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(175))];
        _footerView.delegate = self;
    }
    return _footerView;
}

-(UILabel *)totalActiveLabel{
    if (!_totalActiveLabel) {
        _totalActiveLabel = [UILabel lableWithFrame:CGRectZero text:@"共*个活动" textColor:RGB(153, 153, 153) font:10 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _totalActiveLabel;
}


-(UIButton *)topBtn{
    if (!_topBtn) {
        _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topBtn.frame = CGRectMake(Screen_W-viewPix(70), Screen_H-tabBarHeight-viewPix(75), viewPix(50), viewPix(50));
        [_topBtn setImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];
        [_topBtn setImage:[UIImage imageNamed:@"top"] forState:UIControlStateHighlighted];
        [_topBtn addTarget:self action:@selector(goToTopAction) forControlEvents:UIControlEventTouchUpInside];
        _topBtn.hidden = YES;
    }
    return _topBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}


@end
