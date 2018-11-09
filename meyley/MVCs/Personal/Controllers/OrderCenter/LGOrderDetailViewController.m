//
//  LGOrderDetailViewController.m
//  meyley
//
//  Created by Bovin on 2018/10/9.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGOrderDetailViewController.h"
#import "LGOrderListModel.h"
#import "LGOrderDetailModel.h"
//cell
#import "LGReceiveAddressTableCell.h"
#import "LGOrderCommonTableCell.h"
#import "LGOrderGoodsTableViewCell.h"
#import "LGOrderDetailCostTableCell.h"
#import "LGPayOrExpressTypeTableCell.h"

#import "LGOrderDetailBottomBar.h"

//商品详情
#import "LGGoodsDetailViewController.h"
//付款界面
#import "LGPayViewController.h"
#import "LGCommitOrderResultModel.h"
#import "LGOrderCenterViewController.h"
//评价
#import "HXSCommunityPostingViewController.h"

@interface LGOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LGOrderDetailModel *detailModel;

@property (nonatomic, strong) LGOrderDetailBottomBar *bottomBar;

//展开所有的商品
@property (nonatomic, assign) BOOL isShowAllGoods;


@end


static NSString *const receiveAddressCell = @"receiveAddressCell";
static NSString *const orderGoodsCell = @"orderGoodsCell";
static NSString *const commonCell = @"commonCell";
static NSString *const priceCostCell = @"priceCostCell";
static NSString *const payTypeCell = @"payTypeCell";

@implementation LGOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"订单详情";
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.bottomBar];
    //获取订单详情
    [self getOrderDetailData];

}

//根据订单号获取订单详情
- (void)getOrderDetailData {
    NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
    NSString *action = [NSString stringWithFormat:@"userId=%@&orderId=%@",userId,self.orderModel.orderId];
    [RequestUtil withGET:@"/api/ecs/order/detail.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            self.detailModel = [LGOrderDetailModel mj_objectWithKeyValues:responseObject[@"result"]];
            [self.tableView reloadData];
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (self.type == LGOrderDetailTypeWaitPay || self.type == LGOrderDetailTypeWaitSend || self.type == LGOrderDetailTypeWaitReceive || self.type == LGOrderDetailTypeWaitComment || self.type == LGOrderDetailTypeCancel) {
        [self.view addSubview:self.bottomBar];
        self.bottomBar.frame = CGRectMake(0, Screen_H-topBarHeight-viewPix(49), Screen_W, viewPix(49));
        if (self.type == LGOrderDetailTypeWaitPay) {
            self.bottomBar.type = LGOrderDetailBottomBarTypeWaitPay;
        }else if (self.type == LGOrderDetailTypeWaitSend) {
            self.bottomBar.type = LGOrderDetailBottomBarTypeWaitSend;
        }else if (self.type == LGOrderDetailTypeWaitReceive) {
            self.bottomBar.type = LGOrderDetailBottomBarTypeWaitReceive;
        }else if (self.type == LGOrderDetailTypeWaitComment) {
            self.bottomBar.type = LGOrderDetailBottomBarTypeWaitComment;
        }else {
            self.bottomBar.type = LGOrderDetailBottomBarTypeCancel;
        }
        self.tableView.frame = CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight-viewPix(49));
        
    }else {
        self.tableView.frame = CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight);
    }
}

#pragma mark--UITableViewDataSource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.type == LGOrderDetailTypeWaitPay || self.type == LGOrderDetailTypeCancel) {
        return 5;
    }else {
        return 7;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        if (self.isShowAllGoods) {
            return self.detailModel.goodsList.count;
        }
        return 1;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        LGReceiveAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:receiveAddressCell forIndexPath:indexPath];
        cell.isHasDefaultAddress = YES;
        cell.isDefault = NO;
        cell.detailModel = self.detailModel;
        return cell;
    }else if (indexPath.section == 2) {
        LGOrderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderGoodsCell forIndexPath:indexPath];
        
        cell.detailModel = self.detailModel.goodsList[indexPath.row];
        return cell;
    }else if (indexPath.section == 3) {
        LGOrderDetailCostTableCell *cell = [tableView dequeueReusableCellWithIdentifier:priceCostCell forIndexPath:indexPath];
        cell.detailModel = self.detailModel;
        return cell;
    }else if (indexPath.section == 0 || indexPath.section == 4) {
        LGOrderCommonTableCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCell forIndexPath:indexPath];
        cell.disableInteraction = YES;
        if (indexPath.section == 0) {
            cell.typeName = [NSString stringWithFormat:@"订单号:%@",self.detailModel.orderSn];
            cell.valueString = @"";
            cell.placeHolder = @"";
        }else {
            cell.typeName = @"订单留言";
            cell.valueString = self.detailModel.payNote.length?self.detailModel.payNote:@"";
            cell.placeHolder = @"";
        }
        return cell;
    }else {
        LGPayOrExpressTypeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:payTypeCell forIndexPath:indexPath];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 4) {
        return 44;
    }else if (indexPath.section == 1) {
        return viewPix(76);
    }
    else if (indexPath.section == 2) {
        return viewPix(100);
    }else if (indexPath.section == 3) {
        return viewPix(166);
    }else {
        return viewPix(55);
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
    label.attributedText = [MBTools typeString:@"商品明细" typeStringColor:RGB(66, 62, 62) valueString:[NSString stringWithFormat:@" (共%ld件)",self.detailModel.goodsList.count] valueStringColor:RGB(149, 149, 149)];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        make.left.equalTo(view.mas_left).offset(viewPix(12));
    }];
    if (self.detailModel.goodsList.count>1) {
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
  
    if (indexPath.section == 2) { //商品详情
        LGGoodsDetailViewController *goodsDetail = [LGGoodsDetailViewController new];
        LGOrderGoodsListModel *model = self.detailModel.goodsList[indexPath.row];
        goodsDetail.goodsId = model.goodsId;
        goodsDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsDetail animated:YES];
    }
}
//展示所有的商品
- (void)showAllGoods:(UIButton *)button {
    button.selected =! button.selected;
    self.isShowAllGoods = button.selected;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}
//用户取消操作
- (void)cancelActionWithOrderType:(LGOrderDetailBottomBarType)type {
    if (type == LGOrderDetailBottomBarTypeWaitPay) { //取消订单
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"你确认要取消订单吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *continuAciont = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *chartAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //取消订单
            [self cancelCurrentOrder];
        }];
        [alertController addAction:continuAciont];
        [alertController addAction:chartAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (type == LGOrderDetailBottomBarTypeWaitComment) { //售后
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请联系专属客服为您提供售后服务或关注”魅力网“公众号留言或者致电服务中心:0571-85775109" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *continuAciont = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *chartAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //呼叫客服中心
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"0571-85775109"]];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }];
        [alertController addAction:continuAciont];
        [alertController addAction:chartAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)cancelCurrentOrder {
    NSDictionary *action = @{@"orderId":self.detailModel.orderId};
    [RequestUtil withPOST:@"/api/ecs/order/cancel.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LGOrderCenterViewController class]]) {
                    LGOrderCenterViewController *orderCenter = (LGOrderCenterViewController *)vc;
                    orderCenter.allowChangeState = YES;
                    orderCenter.stateName = @"全部";
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

//用户收货，付款，评价等
- (void)sureActionWithOrderType:(LGOrderDetailBottomBarType)type {
    if (type == LGOrderDetailBottomBarTypeWaitPay) { //去支付
        LGCommitOrderResultModel *resultModel = [LGCommitOrderResultModel new];
        resultModel.orderId = self.detailModel.orderId;
        resultModel.orderSn = self.detailModel.orderSn;
        resultModel.orderAmount = self.detailModel.orderAmount;
        LGPayViewController *payVC= [LGPayViewController new];
        payVC.model = resultModel;
        payVC.payFinishBlock = ^(BOOL paySuccess) {
            if (paySuccess) {
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[LGOrderCenterViewController class]]) {
                        LGOrderCenterViewController *orderCenter = (LGOrderCenterViewController *)vc;
                        orderCenter.allowChangeState = YES;
                        orderCenter.stateName = @"待收货";
                    }
                }
            }
        };
        
        payVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:payVC animated:NO completion:^{
            payVC.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        }];
    }else if (type == LGOrderDetailBottomBarTypeWaitReceive) { //确认收货
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"你确认收到商品了吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *continuAciont = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *chartAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //确认收货
            [self userMakeSureReceiveGoods];
        }];
        [alertController addAction:continuAciont];
        [alertController addAction:chartAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else if (type == LGOrderDetailBottomBarTypeWaitComment) { //晒单
        HXSCommunityPostingViewController *communityPostingViewController = [[HXSCommunityPostingViewController alloc] initWithNibName:NSStringFromClass([HXSCommunityPostingViewController class]) bundle:nil];
        if([self.navigationController.topViewController isKindOfClass:[HXSCommunityPostingViewController class]]) {
            return;
        }
        [self.navigationController pushViewController:communityPostingViewController animated:YES];
    }
}

//确认收货
- (void)userMakeSureReceiveGoods {
    NSDictionary *action = @{@"orderId":self.detailModel.orderId};
    [RequestUtil withPOST:@"/api/ecs/order/received.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LGOrderCenterViewController class]]) {
                    LGOrderCenterViewController *orderCenter = (LGOrderCenterViewController *)vc;
                    orderCenter.allowChangeState = YES;
                    orderCenter.stateName = @"待评价";
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark--lazy--
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight-viewPix(49)) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        if (kAPIVersion11Later) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 10)];
        _tableView.tableHeaderView = headerView;
        [_tableView registerClass:[LGReceiveAddressTableCell class] forCellReuseIdentifier:receiveAddressCell];
        [_tableView registerClass:[LGOrderGoodsTableViewCell class] forCellReuseIdentifier:orderGoodsCell];
        [_tableView registerClass:[LGOrderCommonTableCell class] forCellReuseIdentifier:commonCell];
        [_tableView registerClass:[LGOrderDetailCostTableCell class] forCellReuseIdentifier:priceCostCell];
        [_tableView registerClass:[LGPayOrExpressTypeTableCell class] forCellReuseIdentifier:payTypeCell];
       
    }
    return _tableView;
}
- (LGOrderDetailBottomBar *)bottomBar {
    
    if (!_bottomBar) {
        
        _bottomBar = [[LGOrderDetailBottomBar alloc]initWithFrame:CGRectZero];
        __weak typeof(self)weakSelf = self;
        _bottomBar.cancelActionBlock = ^(LGOrderDetailBottomBarType type) {
            [weakSelf cancelActionWithOrderType:type];
        };
        _bottomBar.sureActionBlock = ^(LGOrderDetailBottomBarType type) {
            [weakSelf sureActionWithOrderType:type];
        };
        
    }
    return _bottomBar;
}
@end
