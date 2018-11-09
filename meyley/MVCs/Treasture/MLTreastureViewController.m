//
//  MLTreastureViewController.m
//  meyley
//
//  Created by chsasaw on 2017/2/19.
//  Copyright © 2017年 Meyley. All rights reserved.
//  宝贝

#import "MLTreastureViewController.h"
//区头与cell
#import "LGShoppingCartTableHeaderView.h"
#import "LGShoppingCartGoodsTableCell.h"
#import "LGShoppingCartBottomBar.h"
//数据model
#import "LGShoppingCartModel.h"
//填写订单界面
#import "LGCommitOrderViewController.h"
#import "HXSLoginViewController.h"

//商品详情界面
#import "LGGoodsDetailViewController.h"
//客服界面
#import "MLServiceCenterViewController.h"
//红包积分界面
#import "LGRedEnvelopsViewController.h"
#import "LGRedEnvelopModel.h" //红包model

#import "AppDelegate.h"
#import "HXSUserInfo.h"

@interface MLTreastureViewController ()<UITableViewDelegate,UITableViewDataSource,LGShoppingCartBottomBarDelegate,LGShoppingCartGoodsTableCellDelegate>

@property (nonatomic, strong) UITableView *cartTableView;
//底部结算条
@property (nonatomic, strong) LGShoppingCartBottomBar *bottomBar;
//数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
//编辑状态
@property (nonatomic, assign) BOOL isEditing;
//选中的商品，结算时传入订单页
@property (nonatomic, strong) NSMutableArray *selectArray;
//占位图,没有数据时
@property(nonatomic , strong) UIView * tableViewBackView;
//记录选择红包
@property (nonatomic, strong) LGRedEnvelopModel *redEnvelopModel;
//积分优惠金额
@property (nonatomic, copy) NSString *integralDiscount;
@end
static NSString *const cartGoodsTableCell = @"cartGoodsTableCell";
@implementation MLTreastureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = NO;
    self.view.backgroundColor = ML_BG_MAIN_COLOR;
    self.navigationItem.title = @"宝贝";
    self.navigationItem.leftBarButtonItem = nil;
    
    if ([HXSUserAccount currentAccount].isLogin) {
        self.bottomBar.waiterModel = [HXSUserAccount currentAccount].userInfo.myWaiter;
        [self getShoppingCartGoodsList];
    }
    
    [self.view addSubview:self.cartTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getShoppingCartGoodsList) name:LGRefreshShopingCartGoodsNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    if (![HXSUserAccount currentAccount].isLogin) {
        [self.dataArray removeAllObjects];
        [self.cartTableView reloadData];
        self.bottomBar.waiterModel = [HXSUserAccount currentAccount].userInfo.myWaiter;
        [self.bottomBar removeFromSuperview];
        self.bottomBar = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.cartTableView.backgroundView.hidden = NO;
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            self.bottomBar.waiterModel = [HXSUserAccount currentAccount].userInfo.myWaiter;
            [self setupNavBar];
            [self.view addSubview:self.bottomBar];
            self.cartTableView.backgroundView.hidden = YES;
            [self getShoppingCartGoodsList];
        }];
    }
}
- (void)setupNavBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
}
- (void)rightItemClick{
    NSLog(@"点击编辑");
    self.isEditing = !self.isEditing;
    if (self.isEditing) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
        self.bottomBar.state = LGCartStateEditing;
    }else{
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        self.bottomBar.state = LGCartStateDefault;
    }
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.isFromGoodsDetail) {
        self.cartTableView.frame = CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight-93);
        self.bottomBar.frame = CGRectMake(0, Screen_H-topBarHeight-93, Screen_W, 93);
    }else {
        self.cartTableView.frame = CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight-tabBarHeight-93);
        self.bottomBar.frame = CGRectMake(0, Screen_H-topBarHeight-tabBarHeight-93, Screen_W, 93);
    }
}
//下拉刷新
- (void)refreshShoppingCartData {
    //刷新时清空
    [self handleCurrentGoodsCountPriceAndState];
    [self getShoppingCartGoodsList];
}
#pragma mark--查询购物车商品列表-------
- (void)getShoppingCartGoodsList {
    
    NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
    NSString *action = [NSString stringWithFormat:@"userId=%@",userId];
    [RequestUtil withGET:@"/api/ecs/cart/list.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.cartTableView.mj_header endRefreshing];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            NSMutableArray *tmpArr = [LGShoppingCartModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            [self.dataArray addObjectsFromArray:tmpArr];
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
        if (self.dataArray.count) {
            [self setupNavBar];
            [self.view addSubview:self.bottomBar];
            self.cartTableView.backgroundView.hidden = YES;
        }else {
            [self.bottomBar removeFromSuperview];
            self.bottomBar = nil;
            self.navigationItem.rightBarButtonItem = nil;
            self.cartTableView.backgroundView.hidden = NO;
        }
        [self.cartTableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark--UITableViewDataSource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count>0) {
        LGShoppingCartModel *model = self.dataArray[section];
        return model.goodsList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGShoppingCartGoodsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cartGoodsTableCell forIndexPath:indexPath];
    if (self.dataArray.count) {
        LGShoppingCartModel *model = self.dataArray[indexPath.section];
        if (model.goodsList.count) {
            LGShoppingGoodsModel *goodsModel = model.goodsList[indexPath.row];
            goodsModel.indexPath = indexPath;
            cell.goodsModel = goodsModel;
        }
    }
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return viewPix(100);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return viewPix(44);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return viewPix(10);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LGShoppingCartTableHeaderView *header = [[LGShoppingCartTableHeaderView alloc]init];
    LGShoppingCartModel *model = self.dataArray[section];
    header.brandName = model.brandName;
    header.isShouldSelect = model.isSelected;
    __weak typeof(self)weakSelf = self;
    header.SelectAllBrandGoods = ^(BOOL isSelect) {
        model.isSelected = isSelect;
        for (LGShoppingGoodsModel *goodsModel in model.goodsList) {
            goodsModel.isSelected = isSelect;
        }
        [weakSelf.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf handleCurrentGoodsCountPriceAndState];
    };
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    return view;
}
#pragma mark---UITableViewDelegate------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LGGoodsDetailViewController *goodsDetail = [LGGoodsDetailViewController new];
    LGShoppingCartModel *model = self.dataArray[indexPath.section];
    if (model.goodsList.count) {
        LGShoppingGoodsModel *goodsModel = model.goodsList[indexPath.row];
        goodsDetail.goodsId = goodsModel.goodsId;
    }
    goodsDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsDetail animated:YES];
    
}
#pragma mark---DFMBCartGoodsTableCellDelegate---
- (void)selectCurrentGoodsWithIndexPath:(NSIndexPath *)indexPath {
    LGShoppingCartModel *model = self.dataArray[indexPath.section];
    if (model.goodsList.count) {
        LGShoppingGoodsModel *goodsModel = model.goodsList[indexPath.row];
        goodsModel.isSelected = !goodsModel.isSelected;
        if (goodsModel.isSelected) {
            model.isSelected = YES;
        }else {
            //需要判断该公司旗下产品是否全部被取消选中
            model.isSelected = NO;
            for (LGShoppingGoodsModel *productModel in model.goodsList) {
                if (productModel.isSelected) {
                    model.isSelected = YES;
                    break;
                }
            }
        }
        [self handleCurrentGoodsCountPriceAndState];
        [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)editGoodsCountWithTextField:(UITextField *)textField atIndexPath:(NSIndexPath *)indexPath {
    [self updateGoodsDataToServerWithIndexPath:indexPath];
}
- (void)reduceGoodsCountFinishWithIndexPath:(NSIndexPath *)indexPath {
    [self updateGoodsDataToServerWithIndexPath:indexPath];
}
- (void)addGoodsCountFinishWithIndexPath:(NSIndexPath *)indexPath {
    [self updateGoodsDataToServerWithIndexPath:indexPath];
}
//更新购物车商品数量
- (void)updateGoodsDataToServerWithIndexPath:(NSIndexPath *)indexPath {
    LGShoppingCartModel *model = self.dataArray[indexPath.section];
    LGShoppingGoodsModel *goodsModel = model.goodsList[indexPath.row];
    [RequestUtil withPOST:@"/api/ecs/cart/modify.action" parameters:@{@"cartId":goodsModel.cartId,@"goodsNumber":goodsModel.goodsNumber} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            [self handleCurrentGoodsCountPriceAndState];
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma DFMBCartBottomBarDelegate----
//全选
- (void)selectAllShoppingCartGoodsWithIsSelect:(BOOL)isSelect {
    int count = 0;
    CGFloat totalPrice = 0;
    for (LGShoppingCartModel *shopCartModel in self.dataArray) {
        shopCartModel.isSelected = isSelect;
        for (LGShoppingGoodsModel *productModel in shopCartModel.goodsList) {
            productModel.isSelected = isSelect;
            if (isSelect) {
                count++;
                NSInteger goodsCount = [productModel.goodsNumber integerValue];
                CGFloat goodsPrice = [productModel.goodsPrice floatValue];
                totalPrice += (goodsCount*goodsPrice);
            }
        }
    }
    self.bottomBar.goodsCount = count;
    self.bottomBar.totalPrice = [NSString stringWithFormat:@"%0.2f",totalPrice];
    [self.cartTableView reloadData];
}
//联系客服
- (void)contactCustomerService {
    MLServiceCenterViewController *controller = [[UIStoryboard storyboardWithName:@"Friends" bundle:nil]instantiateViewControllerWithIdentifier:@"MLServiceCenterViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
//使用红包积分优惠
- (void)goodsPrefrenceWithRedEnvelopOrIntegral {
    LGRedEnvelopsViewController *redVC = [LGRedEnvelopsViewController new];
    __weak typeof(self)weakSelf = self;
    redVC.chooseRedEnvelopFinish = ^(LGRedEnvelopModel *redEnvelopModel, NSString *disCount) {
        NSInteger totalDiscount = 0;
        if (redEnvelopModel) {
            weakSelf.redEnvelopModel = redEnvelopModel;
            totalDiscount += [redEnvelopModel.typeMoney integerValue];
        }
        weakSelf.integralDiscount = disCount.length?disCount:@"";
        totalDiscount += [weakSelf.integralDiscount integerValue];
        weakSelf.bottomBar.discountPrice = [NSString stringWithFormat:@"%ld",totalDiscount];
    };
    redVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:redVC animated:YES];
}
//结算
- (void)commitGoodsOrder {
    if ([self getSelectGoodsModel].count<=0) {
        [TooltipView showMessage:@"请选择要采购的商品" offset:0];
        return;
    }
    LGCommitOrderViewController *orderVC = [LGCommitOrderViewController new];
    orderVC.goodsArray = self.selectArray;
    orderVC.redEnvelopModel = self.redEnvelopModel;
    orderVC.integralDiscount = self.integralDiscount;
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}
//加入收藏
- (void)collectionAllSelectGoods {
    if (![self getSelectGoodsIds].length) {
        [TooltipView showMessage:@"请选择要移入收藏的商品" offset:0];
        return;
    }
    [TooltipView showMessage:@"正在开发中..." offset:0];
//    [self storeProductInShoppingCarWithStoreIds:[self getSelectGoodsIds]];
}
//删除
- (void)deleteAllSelectGoodsFromShoppingCart {
    if (![self getSelectGoodsIds].length) {
        [TooltipView showMessage:@"请选择要删除的商品" offset:0];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"你确定要删除该商品吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continuAciont = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *chartAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [RequestUtil withPOST:@"/api/ecs/cart/remove.action" parameters:@{@"cartId":[self getSelectGoodsIds]} success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
                [TooltipView showMessage:@"商品删除成功" offset:0];
                [self getShoppingCartGoodsList];
            }else {
                [TooltipView showMessage:responseObject[@"msg"] offset:0];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }];
    [alertController addAction:continuAciont];
    [alertController addAction:chartAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
//获取选中的商品的ids
- (NSString *)getSelectGoodsIds {
    NSString *selectIds = @"";
    for (LGShoppingCartModel *shopCartModel in self.dataArray) {
        for (LGShoppingGoodsModel *productModel in shopCartModel.goodsList) {
            if (productModel.isSelected) {
                if (!selectIds.length) {
                    selectIds = [NSString stringWithFormat:@"%@",productModel.cartId];
                }else {
                    selectIds = [NSString stringWithFormat:@"%@,%@",selectIds,productModel.cartId];
                }
            }
        }
    }
    return selectIds;
}
//计算当前选中的商品数量价格与选中状态
- (void)handleCurrentGoodsCountPriceAndState {
    int count = 0;
    CGFloat totalPrice = 0;
    BOOL isAllGoodsSelected = YES;
    for (LGShoppingCartModel *shopCartModel in self.dataArray) {
        
        for (LGShoppingGoodsModel *productModel in shopCartModel.goodsList) {
            
            if (productModel.isSelected) {
                count++;
                NSInteger goodsCount = [productModel.goodsNumber integerValue];
                CGFloat goodsPrice = [productModel.goodsPrice floatValue];
                totalPrice += (goodsCount*goodsPrice);
            }else{
                isAllGoodsSelected = NO;
            }
        }
    }
    self.bottomBar.goodsCount = count;
    self.bottomBar.isShouldSelect = isAllGoodsSelected;
    self.bottomBar.totalPrice = [NSString stringWithFormat:@"%0.2f",totalPrice];
}
/**获取选中的商品的model*/
- (NSMutableArray *)getSelectGoodsModel {
    [self.selectArray removeAllObjects];
    for (LGShoppingCartModel *shopCartModel in self.dataArray) {
        for (LGShoppingGoodsModel *productModel in shopCartModel.goodsList) {
            if (productModel.isSelected) {
                [self.selectArray addObject:productModel];
            }
        }
    }
    return self.selectArray;
}

//去首页商城逛逛
- (void)goToHomeMall {
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *ap = (AppDelegate *)[UIApplication sharedApplication].delegate;
        ap.rootViewController.selectedIndex = 0;
    });
}
#pragma mark--lazy------
- (UITableView *)cartTableView {
    
    if (!_cartTableView) {
        
        _cartTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight-tabBarHeight-93) style:UITableViewStyleGrouped];
        _cartTableView.dataSource = self;
        _cartTableView.delegate = self;
        _cartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cartTableView.backgroundColor = [UIColor clearColor];
        _cartTableView.showsVerticalScrollIndicator = NO;
        _cartTableView.showsHorizontalScrollIndicator = NO;
        _cartTableView.estimatedSectionFooterHeight = 0;
        _cartTableView.estimatedSectionHeaderHeight = 0;
        _cartTableView.estimatedRowHeight = 0;
        if (kAPIVersion11Later) {
            _cartTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _cartTableView.backgroundView = self.tableViewBackView;
        _cartTableView.backgroundView.hidden = YES;
        [_cartTableView registerClass:[LGShoppingCartGoodsTableCell class] forCellReuseIdentifier:cartGoodsTableCell];
        _cartTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshShoppingCartData)];
    }
    return _cartTableView;
}
- (UIView *)tableViewBackView {
    
    if (!_tableViewBackView) {
        
        _tableViewBackView = [[UIView alloc]initWithFrame:self.cartTableView.bounds];

        UIImageView * tableViewBackImageView= [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W - viewPix(50))/2, _tableViewBackView.frame.size.height/2-viewPix(38), viewPix(50), viewPix(50))];
        tableViewBackImageView.image = [UIImage imageNamed:@"shopCart"];
        [_tableViewBackView addSubview:tableViewBackImageView];
        
        UILabel * tableViewBackLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tableViewBackImageView.frame)+10, Screen_W, 50)];
        tableViewBackLabel.font = LGFont(15);
        tableViewBackLabel.textAlignment = NSTextAlignmentCenter;
        tableViewBackLabel.textColor = RGB(66, 62, 62);
        tableViewBackLabel.numberOfLines = 0;
        tableViewBackLabel.text = @"购物车还没有商品 \n 赶紧去逛逛吧";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:tableViewBackLabel.text];
        [string addAttribute:NSForegroundColorAttributeName value:RGB(140, 180, 240) range:NSMakeRange(tableViewBackLabel.text.length-6, 6)];
        tableViewBackLabel.attributedText = string;
        [_tableViewBackView addSubview:tableViewBackLabel];
        tableViewBackLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToHomeMall)];
        [tableViewBackLabel addGestureRecognizer:tap];
        
    }
    return _tableViewBackView;
}
- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)selectArray {
    
    if (!_selectArray) {
        
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
- (LGShoppingCartBottomBar *)bottomBar {
    
    if (!_bottomBar) {
        
        _bottomBar = [[LGShoppingCartBottomBar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cartTableView.frame), Screen_W, 93)];
        _bottomBar.delegate = self;
    }
    return _bottomBar;
}
#pragma mark-- dealloc---
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
