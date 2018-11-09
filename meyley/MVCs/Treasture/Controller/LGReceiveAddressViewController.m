//
//  LGReceiveAddressViewController.m
//  meyley
//
//  Created by Bovin on 2018/9/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGReceiveAddressViewController.h"
#import "LGAddressTableViewCell.h"
#import "LGReceiveAddressBottomBar.h"
//model
#import "LGReceiveAddressModel.h"
//没有收货地址时展示的view
#import "LGReceiveAddressTableCell.h"
//新建收货地址
#import "LGAddReceiveAddressViewController.h"

@interface LGReceiveAddressViewController ()<UITableViewDelegate,UITableViewDataSource,LGAddressTableViewCellDelegate>

@property (nonatomic, strong) UITableView *addressTableView;

@property (nonatomic, strong) LGReceiveAddressBottomBar *addBar;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL isMotifyDefaultAddress;

@end

static NSString *const receiveAddressCell = @"receiveAddressCell";
@implementation LGReceiveAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"地址选择";
    [self.view addSubview:self.addressTableView];
    [self.view addSubview:self.addBar];
    
    [self getReceivingAddressListData];
    
}
#pragma mark--网络请求--------
//获取收货地址列表
- (void)getReceivingAddressListData {
    NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
    NSString *action = [NSString stringWithFormat:@"userId=%@",userId];
    [RequestUtil withGET:@"/api/ecs/address/list.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.addressTableView.mj_header endRefreshing];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            NSMutableArray *tmpArr = [LGReceiveAddressModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            [self.dataArray addObjectsFromArray:tmpArr];
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
        if (self.dataArray.count) {
            if (!self.isMotifyDefaultAddress) {
                NSSortDescriptor *isDefault = [NSSortDescriptor sortDescriptorWithKey:@"isDefault" ascending:NO];
                [self.dataArray sortUsingDescriptors:@[isDefault]];
            }
            [self.addressTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark--UITableViewDataSource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:receiveAddressCell forIndexPath:indexPath];
    if (indexPath.row<self.dataArray.count) {
        LGReceiveAddressModel *model = self.dataArray[indexPath.section];
        model.indexPath = indexPath;
        cell.model = model;
    }
    cell.delegate = self;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return viewPix(98);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return viewPix(12);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = ML_BG_MAIN_COLOR;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}
#pragma mark---UITableViewDelegate------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LGReceiveAddressModel *model = self.dataArray[indexPath.section];
    if (self.motifyReceiveAddressBlock) {
        self.motifyReceiveAddressBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--action-------
//删除某一条收货地址
- (void)deleteCurrentReceivingAddressWithIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"你确定要删除该收货地址吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continuAciont = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *chartAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        LGReceiveAddressModel *model = self.dataArray[indexPath.section];
        [RequestUtil withPOST:@"/api/ecs/address/remove.action" parameters:@{@"addressId":model.addressId} success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
                [TooltipView showMessage:@"收货地址删除成功" offset:0];
                
                [self getReceivingAddressListData];
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
//编辑收货地址
- (void)editCurrentReceivingAddressWithIndexPath:(NSIndexPath *)indexPath {
    LGReceiveAddressModel *model = self.dataArray[indexPath.section];
    LGAddReceiveAddressViewController *addVC = [LGAddReceiveAddressViewController new];
    addVC.model = model;
    addVC.style = LGAddressStyleEditing;
    addVC.refreshReceiveAddress = ^{
        [self getReceivingAddressListData];
    };
    addVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addVC animated:YES];
}
//设置为默认的收货地址
- (void)setDefaultReceivingAddressWithIndexPath:(NSIndexPath *)indexPath {
    LGReceiveAddressModel *model = self.dataArray[indexPath.section];
    for (LGReceiveAddressModel *address in self.dataArray) {
        if ([address.addressId isEqualToString:model.addressId]) {
            address.isDefault = @"1";
            [self motifyDefaultReceiveAddressWithModel:address];
        }else {
            address.isDefault = @"0";
        }
    }
    [self.addressTableView reloadData];
}
//添加新地址
- (void)addNewReceivingAddress {
    self.isMotifyDefaultAddress = NO;
    LGAddReceiveAddressViewController *addVC = [LGAddReceiveAddressViewController new];
    addVC.hidesBottomBarWhenPushed = YES;
    addVC.style = LGAddressStyleNew;
    addVC.refreshReceiveAddress = ^{
        [self getReceivingAddressListData];
    };
    [self.navigationController pushViewController:addVC animated:YES];
}

//修改默认的收货地址
- (void)motifyDefaultReceiveAddressWithModel:(LGReceiveAddressModel *)addModel {
    self.isMotifyDefaultAddress = YES;
    NSDictionary *action = @{@"addressId":addModel.addressId,@"userId":addModel.userId,@"consignee":addModel.consignee,@"mobile":addModel.mobile,@"province":addModel.province,@"city":addModel.city,@"district":addModel.district,@"address":addModel.address,@"isDefault":addModel.isDefault};
    [RequestUtil withPOST:@"/api/ecs/address/modify.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            [self getReceivingAddressListData];
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark--lazy------
- (UITableView *)addressTableView {
    
    if (!_addressTableView) {
        
        _addressTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight-viewPix(65)) style:UITableViewStyleGrouped];
        _addressTableView.dataSource = self;
        _addressTableView.delegate = self;
        _addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _addressTableView.backgroundColor = [UIColor clearColor];
        _addressTableView.showsVerticalScrollIndicator = NO;
        _addressTableView.showsHorizontalScrollIndicator = NO;
        if (kAPIVersion11Later) {
            _addressTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _addressTableView.estimatedSectionHeaderHeight = 0;
        _addressTableView.estimatedSectionFooterHeight = 0;
        [_addressTableView registerClass:[LGAddressTableViewCell class] forCellReuseIdentifier:receiveAddressCell];
        _addressTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getReceivingAddressListData)];
    }
    return _addressTableView;
}
- (LGReceiveAddressBottomBar *)addBar {

    if (!_addBar) {

        _addBar = [[LGReceiveAddressBottomBar alloc]initWithFrame:CGRectMake(0, Screen_H-topBarHeight-viewPix(65), Screen_W, viewPix(65))];
        __weak typeof(self)weakSelf = self;
        _addBar.addNewReceiveAddress = ^{
            [weakSelf addNewReceivingAddress];
        };
    }
    return _addBar;
}
- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
