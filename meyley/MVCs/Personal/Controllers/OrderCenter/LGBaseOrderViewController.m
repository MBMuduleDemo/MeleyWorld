//
//  LGBaseOrderViewController.m
//  meyley
//
//  Created by Bovin on 2018/10/8.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGBaseOrderViewController.h"

#import "LGOrderStateTableViewCell.h"
#import "LGOrderListModel.h"

//详情页
#import "LGOrderDetailViewController.h"
//付款界面
#import "LGPayViewController.h"
#import "LGCommitOrderResultModel.h"
#import "LGOrderCenterViewController.h"
//晒单评价
#import "HXSCommunityPostingViewController.h"
@interface LGBaseOrderViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger  currentPage;

@end

static NSString *const orderStateCell = @"orderStateCell";
@implementation LGBaseOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.isLoadData = NO;
    self.dataArray = [NSMutableArray array];
    
    [self setupUI];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isLoadData) {
        [self.tableView.mj_header beginRefreshing];
    }
}
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}
- (void)setupUI {
    self.view.backgroundColor = ML_BG_MAIN_COLOR;
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    if (kAPIVersion11Later) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.tableView registerClass:[LGOrderStateTableViewCell class] forCellReuseIdentifier:orderStateCell];
    [self setUpRefresh];
    self.tableView.frame = self.view.frame;
   
}
- (void)setUpRefresh
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    self.tableView.mj_header = header;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    self.tableView.mj_footer = footer;
}
- (void)headerRefreshing{
    self.currentPage = 1;
    [self getOrderStateDataWithPage:self.currentPage];
}
- (void)footerRefreshing {
    self.currentPage++;
    [self getOrderStateDataWithPage:self.currentPage];
}
- (void)getOrderStateDataWithPage:(NSInteger)page {
    
    NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
    NSString *loadPage = [NSString stringWithFormat:@"%ld",page];
    NSString *action;
    if (self.orderStatus != LGOrderInfoStatusAll) {
        NSString *status = [NSString stringWithFormat:@"%ld",self.orderStatus];
        action = [NSString stringWithFormat:@"pageSize=10&page=%@&userId=%@&status=%@",loadPage,userId,status];
    }else {
        action = [NSString stringWithFormat:@"pageSize=10&page=%@&userId=%@",loadPage,userId];
    }
    [RequestUtil withGET:@"/api/ecs/order/list.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            if (self.currentPage == 1) {
                [self.dataArray removeAllObjects];
                self.isLoadData = YES;
            }
            NSMutableArray *tmpArr = [LGOrderListModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"orderList"]];
            [self.dataArray addObjectsFromArray:tmpArr];
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
        if (self.dataArray.count) {
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGOrderStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderStateCell forIndexPath:indexPath];
    LGOrderListModel *model = self.dataArray[indexPath.section];
    NSInteger status = [model.orderStatus integerValue];
    if (status == 0 || status == 2 || status == 3 || status == 4) {
        cell.cellType = LGOrderCellTypeOneAction;
    }else if (status == 1 || status == 5) {
        cell.cellType = LGOrderCellTypeDefault;
    }else {
        cell.cellType = LGOrderCellTypeTwoAction;
    }
    __weak typeof(self) weakSelf = self;
    cell.OrderCancelActionHandler = ^{ //卖家：驳回退货
//        [weakSelf cancelActionWithIndexPath:indexPath];
    };
    cell.OrderSureActionHandler = ^{ //付款，确认收货 评价 退货/售后
        [weakSelf userActionWithType:status atIndexPath:indexPath];
    };
    cell.orderModel = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGOrderListModel *model = self.dataArray[indexPath.section];
    CGFloat status = [model.orderStatus integerValue];
    if (status == 1 || status == 5) {
        return viewPix(140);
    }
    return viewPix(188);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = ML_BG_MAIN_COLOR;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return viewPix(10);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LGOrderListModel *model = self.dataArray[indexPath.section];
    CGFloat status = [model.orderStatus integerValue];
    LGOrderDetailType type;
    if (status == 0) {
        type = LGOrderDetailTypeWaitPay;
    }else if (status == 1) {
        type = LGOrderDetailTypeWaitSend;
    }else if (status == 2) {
        type = LGOrderDetailTypeWaitReceive;
    }else if (status == 3) {
        type = LGOrderDetailTypeWaitComment;
    }else if (status == 4) {
        type = LGOrderDetailTypeReturned;
    }else if (status == 5) {
        type = LGOrderDetailTypeCancel;
    }else {
        type = LGOrderDetailTypeFinished;
    }
    LGOrderDetailViewController *detailVC = [LGOrderDetailViewController new];
    detailVC.type = type;
    detailVC.orderModel = model;
    __weak typeof(self)weakSelf = self;
    detailVC.refreshOrderStateBlock = ^{
        weakSelf.isLoadData = NO;
        [self headerRefreshing];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark--userAction---
- (void)userActionWithType:(NSInteger)status atIndexPath:(NSIndexPath *)indexPath {
    if (status == 0) { //待付款
        LGOrderListModel *model = self.dataArray[indexPath.section];
        
        LGCommitOrderResultModel *resultModel = [LGCommitOrderResultModel new];
        resultModel.orderId = model.orderId;
        resultModel.orderSn = model.orderSn;
        resultModel.orderAmount = model.orderAmount;
        LGPayViewController *payVC= [LGPayViewController new];
        payVC.model = resultModel;
        payVC.payFinishBlock = ^(BOOL paySuccess) {
            if (paySuccess) {
                [self headerRefreshing];
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
    }else if (status == 2) { //待收货
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"你确认收到商品了吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *continuAciont = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *chartAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //确认收货
            [self userMakeSureReceiveGoodsWithIndexPath:indexPath];
        }];
        [alertController addAction:continuAciont];
        [alertController addAction:chartAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (status == 3) { //晒单评价
        HXSCommunityPostingViewController *communityPostingViewController = [[HXSCommunityPostingViewController alloc] initWithNibName:NSStringFromClass([HXSCommunityPostingViewController class]) bundle:nil];
        if([self.navigationController.topViewController isKindOfClass:[HXSCommunityPostingViewController class]]) {
            return;
        }
        [self.navigationController pushViewController:communityPostingViewController animated:YES];
    }else if (status == 4) { //退货/售后
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
    }else if (status == 5) { //已取消，删除
        
    }
}

//确认收货
- (void)userMakeSureReceiveGoodsWithIndexPath:(NSIndexPath *)indexPath {
    LGOrderListModel *model = self.dataArray[indexPath.section];
    NSDictionary *action = @{@"orderId":model.orderId};
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

@end
