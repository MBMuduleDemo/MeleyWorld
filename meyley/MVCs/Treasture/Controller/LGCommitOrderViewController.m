//
//  LGCommitOrderViewController.m
//  meyley
//
//  Created by Bovin on 2018/9/11.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGCommitOrderViewController.h"
#import "LGCommitOrderBottomBar.h"
//cell
#import "LGReceiveAddressTableCell.h"
#import "LGOrderCommonTableCell.h"
#import "LGOrderGoodsTableViewCell.h"

//model
#import "LGShoppingCartModel.h"
#import "LGReceiveAddressModel.h" //收货地址model
#import "LGExpressTypeModel.h"  //快递类型model
#import "LGRedEnvelopModel.h"   //红包model
#import "LGCommitOrderResultModel.h" //提交订单结果model
//收货地址管理界面
#import "LGReceiveAddressViewController.h"
//新建收货地址
#import "LGAddReceiveAddressViewController.h"
//商品详情
#import "LGGoodsDetailViewController.h"
//配送方式
#import "LGExpressTypeViewController.h"
//红包
#import "LGRedEnvelopsViewController.h"
//发票信息
#import "LGBillInfoViewController.h"
//支付界面
#import "LGPayViewController.h"
#import "AppDelegate.h"
#import "HXSUserInfo.h"
#import "MLWaiterModel.h"

@interface LGCommitOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *orderTableView;
@property (nonatomic, strong) LGCommitOrderBottomBar *bottomBar;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) LGReceiveAddressModel *addressModel;
@property (nonatomic, strong) LGCommitOrderResultModel *resultModel;
//记录数据
@property (nonatomic, strong) LGExpressTypeModel *expressModel;
@property (nonatomic, copy) NSString *bestTime;
@property (nonatomic, copy) NSString *buyerMsg;
@property (nonatomic, copy) NSString *goodsTotalCost;//所有商品价格
@property (nonatomic, copy) NSString *orderPrice;//订单的价格

@property (nonatomic, assign) BOOL isShowAllGoods;
@end
static NSString *const commonOrderCell = @"commonOrderCell";
static NSString *const receiveAddressCell = @"receiveAddressCell";
static NSString *const orderGoodsCell = @"orderGoodsCell";
@implementation LGCommitOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"填写订单";
    self.dataArray = @[@[@""],@[@{@"typeName":@"配送",@"placeHolder":@"选择配送方式"}],@[@""],@[@{@"typeName":@"发票管理",@"placeHolder":@""},@{@"typeName":@"订单留言",@"placeHolder":@"选填:给商家留言(40字以内)"}],@[@{@"typeName":@"商品金额",@"placeHolder":@""},@{@"typeName":@"优惠金额",@"placeHolder":@""},@{@"typeName":@"运费",@"placeHolder":@""}]];
    [self.view addSubview:self.orderTableView];
    [self.view addSubview:self.bottomBar];
    //第一次进入时获取默认的收货地址
    [self getReceivingAddressListData];
    //计算商品的总价格
    self.bottomBar.totalCost = [self makeSureCurrentOrderTotalCost];
}
- (void)back {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"亲,确认要取消该订单吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continuAciont = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //返回
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *chartAction = [UIAlertAction actionWithTitle:@"不" style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:continuAciont];
    [alertController addAction:chartAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
//获取默认收货地址
- (void)getReceivingAddressListData {
    NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
    NSString *action = [NSString stringWithFormat:@"userId=%@",userId];
    [RequestUtil withGET:@"/api/ecs/address/list.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);

        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {

            NSMutableArray *tmpArr = [LGReceiveAddressModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            for (LGReceiveAddressModel *model in tmpArr) {
                if ([model.isDefault isEqualToString:@"1"]) {
                    self.addressModel = model;
                }
            }
            [self.orderTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark--UITableViewDataSource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }else if (section == 2) {
        if (self.isShowAllGoods) {
            return self.goodsArray.count;
        }
        return 1;
    }else if (section == 3) {
        return 2;
    }else if (section == 4) {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LGReceiveAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:receiveAddressCell forIndexPath:indexPath];
        if (self.addressModel) {
            cell.isHasDefaultAddress = YES;
            if ([self.addressModel.isDefault isEqualToString:@"1"]) {
                cell.isDefault = YES;
            }else {
                cell.isDefault = NO;
            }
            cell.model = self.addressModel;
        }else {
            cell.isHasDefaultAddress = NO;
        }
        return cell;
    }else if (indexPath.section == 2) {
        LGOrderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderGoodsCell forIndexPath:indexPath];
        cell.model = self.goodsArray[indexPath.row];
        return cell;
    }else {
        LGOrderCommonTableCell *cell = [tableView dequeueReusableCellWithIdentifier:commonOrderCell forIndexPath:indexPath];
        __weak typeof(self)weakSelf = self;
        cell.orderTipsMessageBlock = ^(NSString *msg) {
            weakSelf.buyerMsg = msg;
        };
        id object = self.dataArray[indexPath.section][indexPath.row];
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)object;
            cell.typeName = [dic objectForKey:@"typeName"];
            cell.placeHolder = [dic objectForKey:@"placeHolder"];
        }
        if (indexPath.section == 1) {   //配送方式
            if (self.expressModel && self.bestTime.length) {
                if (self.expressModel.shippingFee && self.expressModel.shippingFee.length >0) {
                    cell.valueString = [NSString stringWithFormat:@"%@,%@配送,配送费%@元",self.expressModel.shippingName,self.bestTime,self.expressModel.shippingFee];
                }else {
                    cell.valueString = [NSString stringWithFormat:@"%@,%@配送",self.expressModel.shippingName,self.bestTime];
                }
            }
        }else if (indexPath.section == 3) {
            if (indexPath.row == 0) {//发票管理
                cell.valueString = @"不开发票";
            }
        }else if (indexPath.section == 4) {
            if (indexPath.row == 0) {   //商品金额
                cell.valueString = [NSString stringWithFormat:@"￥%@",self.goodsTotalCost];
            }else if (indexPath.row == 1) { //优惠金额
                NSString *discount;
                if (self.redEnvelopModel && self.redEnvelopModel.typeMoney.length>0) {
                    discount = [NSString stringWithFormat:@"%0.2f",[self.redEnvelopModel.typeMoney floatValue]];
                }else {
                    discount = @"0.00";
                }
                cell.valueString = [NSString stringWithFormat:@"-￥%@",discount];
            }else { //运费
                NSString *shippingFee;
                if (self.expressModel.shippingFee && self.expressModel.shippingFee.length>0) {
                    shippingFee = [NSString stringWithFormat:@"%0.2f",[self.expressModel.shippingFee floatValue]];
                }else {
                    shippingFee = @"0.00";
                }
                cell.valueString = [NSString stringWithFormat:@"￥%@",shippingFee];
            }
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return viewPix(76);
    }else if (indexPath.section == 1 || indexPath.section == 3 || indexPath.section == 4) {
        return 44;
    }else if (indexPath.section == 2) {
        return viewPix(100);
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 44;
    }
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14];
    label.attributedText = [MBTools typeString:@"商品明细" typeStringColor:RGB(66, 62, 62) valueString:[NSString stringWithFormat:@" (共%ld件)",self.goodsArray.count] valueStringColor:RGB(149, 149, 149)];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        make.left.equalTo(view.mas_left).offset(viewPix(12));
    }];
    if (self.goodsArray.count>1) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"NoramlDown"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"NoramlUp"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(showAllGoods:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        if (self.isShowAllGoods) {
            button.selected = YES;
        }
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(view);
            make.width.mas_equalTo(viewPix(45));
        }];
    }
    
    
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = ML_BG_MAIN_COLOR;
    return view;
}
#pragma mark---UITableViewDelegate------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) { //收货地址列表
        LGReceiveAddressViewController *addressVC = [LGReceiveAddressViewController new];
        addressVC.hidesBottomBarWhenPushed = YES;
        __weak typeof(self)weakSelf = self;
        addressVC.motifyReceiveAddressBlock = ^(LGReceiveAddressModel *model) {
            weakSelf.addressModel = model;
            [weakSelf.orderTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:addressVC animated:YES];
    }else if (indexPath.section == 1) { //配送方式选择列表
        if (!self.addressModel) {
            [TooltipView showMessage:@"请添加收货地址" offset:0];
            return;
        }
        LGExpressTypeViewController *expressVC = [LGExpressTypeViewController new];
        expressVC.cartIds = [self getGoodsCartIds];
        expressVC.addressId = self.addressModel.addressId;
        __weak typeof(self)weakSelf = self;
        expressVC.chooseExpressFinishBlock = ^(LGExpressTypeModel *typeModel, NSString *sendTime) {
            weakSelf.expressModel = typeModel;
            weakSelf.bestTime = sendTime;
            weakSelf.bottomBar.totalCost = [weakSelf makeSureCurrentOrderTotalCost]; //更新实付价
            [weakSelf.orderTableView reloadData];
        };
        expressVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:expressVC animated:YES];
    }else if (indexPath.section == 2) { //查看商品详情
        LGGoodsDetailViewController *goodsDetail = [LGGoodsDetailViewController new];
        LGShoppingGoodsModel *model = self.goodsArray[indexPath.row];
        goodsDetail.goodsId = model.goodsId;
        goodsDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsDetail animated:YES];
    }else if (indexPath.section == 3) { //发票与留言
        if (indexPath.row == 0) { //发票管理
            LGBillInfoViewController *billVC= [LGBillInfoViewController new];
            billVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:billVC animated:YES];
        }
    }
}
//获取选中的商品的ids
- (NSString *)getGoodsCartIds {
    NSString *selectIds = @"";
    for (LGShoppingGoodsModel *productModel in self.goodsArray) {
        if (!selectIds.length) {
            selectIds = [NSString stringWithFormat:@"%@",productModel.cartId];
        }else {
            selectIds = [NSString stringWithFormat:@"%@,%@",selectIds,productModel.cartId];
        }
    }
    return selectIds;
}
//计算商品价格
- (NSString *)makeSureCurrentOrderTotalCost {
    CGFloat totalCost = 0;
    for (LGShoppingGoodsModel *model in self.goodsArray) {
        NSInteger goodsCount = [model.goodsNumber integerValue];
        CGFloat goodsPrice = [model.goodsPrice floatValue];
        totalCost += (goodsPrice*goodsCount);
    }
    self.goodsTotalCost = [NSString stringWithFormat:@"%0.2f",totalCost];
    if (self.expressModel) { //如果有运费计算加运费后总价钱
        CGFloat shippingFee = [self.expressModel.shippingFee floatValue];
        totalCost += shippingFee;
    }
    //如果使用红包获积分减掉优惠的价格，计算总价
    if (self.redEnvelopModel) {
        CGFloat redEnvelop = [self.redEnvelopModel.typeMoney floatValue];
        totalCost -= redEnvelop;
    }
    self.orderPrice = [NSString stringWithFormat:@"%0.2f",totalCost];
    return [NSString stringWithFormat:@"%0.2f",totalCost];
}
#pragma mark--action------
//提交订单
- (void)commitOrder {
    NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
    MLWaiterModel *waiterModel;
    if ([HXSUserAccount currentAccount].userInfo.myWaiter) {
        waiterModel = [HXSUserAccount currentAccount].userInfo.myWaiter;
    }
    NSString *sendTime;
    if ([self.bestTime isEqualToString:@"工作日"]) {
        sendTime = @"1";
    }else if ([self.bestTime isEqualToString:@"周末"]) {
        sendTime = @"0";
    }else {
        sendTime = @"2";
    }
    if (!self.addressModel) {
        [TooltipView showMessage:@"请添加收货地址" offset:0];
        return;
    }
    if (!self.expressModel) {
        [TooltipView showMessage:@"请选择收货方式" offset:0];
        return;
    }
    NSDictionary *action = @{@"userId":userId,@"addressId":self.addressModel.addressId,@"shippingId":self.expressModel.shippingId,@"bestTime":sendTime,@"postscript":self.buyerMsg.length?self.buyerMsg:@"",@"cartIds":[self getGoodsCartIds],@"goodsAmount":self.goodsTotalCost,@"shippingFee":self.expressModel.shippingFee,@"orderAmount":self.orderPrice,@"bonusId":self.redEnvelopModel?self.redEnvelopModel.bonusId:@"",@"waiterId":waiterModel?waiterModel.waiterId:@"",@"surplus":@"",@"integral":self.integralDiscount.length?self.integralDiscount:@""};
    [RequestUtil withPOST:@"/api/ecs/order/add.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            NSLog(@"%@",responseObject);
            [[NSNotificationCenter defaultCenter]postNotificationName:LGRefreshShopingCartGoodsNotification object:nil];
            self.resultModel = [LGCommitOrderResultModel mj_objectWithKeyValues:responseObject[@"result"]];
            LGPayViewController *payVC= [LGPayViewController new];
            payVC.model = self.resultModel;
            payVC.payFinishBlock = ^(BOOL paySuccess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    AppDelegate *ap = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    if (paySuccess) {
                        [self.navigationController popToRootViewControllerAnimated:NO];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            ap.rootViewController.selectedIndex = 4;
                        });
                    }else {
                        [self.navigationController popToRootViewControllerAnimated:NO];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            ap.rootViewController.selectedIndex = 0;
                        });
                    }
                });
            };
            
            payVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:payVC animated:NO completion:^{
                payVC.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
            }];
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)showAllGoods:(UIButton *)button {
    button.selected =! button.selected;
    self.isShowAllGoods = button.selected;
    [self.orderTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark--lazy------
- (UITableView *)orderTableView {
    
    if (!_orderTableView) {
        
        _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight-bottomSafeBarHeight-49) style:UITableViewStyleGrouped];
        _orderTableView.dataSource = self;
        _orderTableView.delegate = self;
        _orderTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _orderTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        _orderTableView.backgroundColor = [UIColor clearColor];
        _orderTableView.showsVerticalScrollIndicator = NO;
        _orderTableView.showsHorizontalScrollIndicator = NO;
        if (kAPIVersion11Later) {
            _orderTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _orderTableView.estimatedRowHeight = 0;
        _orderTableView.estimatedSectionFooterHeight = 0;
        _orderTableView.estimatedSectionHeaderHeight = 0;
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 13)];
        headerView.backgroundColor = ML_BG_MAIN_COLOR;
        _orderTableView.tableHeaderView = headerView;
        [_orderTableView registerClass:[LGOrderCommonTableCell class] forCellReuseIdentifier:commonOrderCell];
        [_orderTableView registerClass:[LGReceiveAddressTableCell class] forCellReuseIdentifier:receiveAddressCell];
        [_orderTableView registerClass:[LGOrderGoodsTableViewCell class] forCellReuseIdentifier:orderGoodsCell];
    }
    return _orderTableView;
}
- (LGCommitOrderBottomBar *)bottomBar {
    
    if (!_bottomBar) {
        
        _bottomBar = [[LGCommitOrderBottomBar alloc]initWithFrame:CGRectMake(0, Screen_H-bottomSafeBarHeight-topBarHeight-49, Screen_W, 49)];
        __weak typeof(self)weakSelf = self;
        _bottomBar.CommitOrderBlock = ^{
            [weakSelf commitOrder];
        };
    }
    return _bottomBar;
}

@end
