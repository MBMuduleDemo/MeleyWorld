//
//  MLPersonalViewController.m
//  meyley
//
//  Created by chsasaw on 2017/2/19.
//  Copyright © 2017年 Meyley. All rights reserved.
//  我的

#import "MLPersonalViewController.h"
#import "HXSUserAccount.h"
#import "HXSUserInfo.h"
#import "HXSUserBasicInfo.h"
//#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "HXSCommunityMyCenterViewController.h"
//#import "Masonry.h"
//设置
#import "LGSettingViewController.h"
#import "LGMineCommonTableCell.h"
#import "LGMineOrderTableCell.h"
#import "LGMineMoneyTableCell.h"

//订单中心
#import "LGOrderCenterViewController.h"
#import "LGReceiveAddressViewController.h"

#import "LGReceiveAddressModel.h"
#import "LGMineOrderCountModel.h"

//充值提现
#import "LGChargeWithdrawViewController.h"
//红包
#import "LGMyRedEnvelopsViewController.h"
//推广中心
#import "LGPromotionViewController.h"

@interface MLPersonalViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *signatureLabel;

@end

@implementation MLPersonalViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.width*0.5;
}

@end


@interface MLPersonalViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) LGReceiveAddressModel *defaultAddress;

@property (nonatomic, strong) LGMineOrderCountModel *countModel;
//订单状态
@property (nonatomic, strong) NSMutableArray *unHandlerNumArray;
//积分红包
@property (nonatomic, strong) NSMutableArray *moneyTypeArray;
@end

static NSString *const commonCell = @"commonCell";
static NSString *const orderStateCell = @"orderStateCell";
static NSString *const chargeCell = @"chargeCell";

@implementation MLPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = NO;
    
    self.dataArray = @[@[],@[@{@"logo":@"mine_zone",@"typeName":@"我的空间",@"subTitle":@"点击可查看修改空间信息"}],@[@{},@{@"logo":@"kongjian",@"typeName":@"默认收货地址",@"subTitle":@"修改"}],@[@{@"logo":@"",@"typeName":@"现金余额",@"subTitle":@""}],@[@{@"logo":@"mine_share",@"typeName":@"推广中心",@"subTitle":@"分享有奖励哦"}]
//                       ,@[@{@"logo":@"mine_note",@"typeName":@"我的留言",@"subTitle":@"建议反馈与留言"}],@[@{@"logo":@"kongjian",@"typeName":@"我的收藏",@"subTitle":@"收藏商品列表"}]
                       ];
    self.unHandlerNumArray = @[@"0",@"0",@"0",@"0"].mutableCopy;
    self.moneyTypeArray = @[@"0",@"0",@"0",@"0"].mutableCopy;
    self.navigationItem.title = @"我的";
    self.navigationItem.leftBarButtonItem = nil;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"my_setting"] style:UIBarButtonItemStylePlain target:self action:@selector(mySetting)];
    [self.tableView registerClass:[LGMineCommonTableCell class] forCellReuseIdentifier:commonCell];
    [self.tableView registerClass:[LGMineOrderTableCell class] forCellReuseIdentifier:orderStateCell];
    [self.tableView registerClass:[LGMineMoneyTableCell class] forCellReuseIdentifier:chargeCell];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 12, 0);
    
    //获取默认的收货地址
    [self getUserDefaultReceiveAddress];
}

- (void)mySetting {
    LGSettingViewController *settingVC = [[LGSettingViewController alloc]init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self allOrderStateCount];
    
    if([[AppDelegate sharedDelegate].rootViewController checkIsLoggedin]) {
        [self.tableView reloadData];
    }
}
- (void)getUserDefaultReceiveAddress {
    NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
    NSString *action = [NSString stringWithFormat:@"userId=%@",userId];
    [RequestUtil withGET:@"/api/ecs/address/list.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            
            NSMutableArray *tmpArr = [LGReceiveAddressModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            for (LGReceiveAddressModel *model in tmpArr) {
                if ([model.isDefault isEqualToString:@"1"]) {
                    self.defaultAddress = model;
                }
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//所有的订单状态
- (void)allOrderStateCount {
    NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
    NSString *action = [NSString stringWithFormat:@"userId=%@",userId];
    [RequestUtil withGET:@"/api/ecs/order/count.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);

        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            self.countModel = [LGMineOrderCountModel mj_objectWithKeyValues:responseObject[@"result"]];
            [self handlerOrderStateNum];
            [self.tableView reloadData];
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)handlerOrderStateNum {
    if (self.countModel.unpayed>0) {
        [self.unHandlerNumArray replaceObjectAtIndex:0 withObject:@(self.countModel.unpayed)];
    }else if (self.countModel.unreceived>0) {
        [self.unHandlerNumArray replaceObjectAtIndex:1 withObject:@(self.countModel.unreceived)];
    }else if (self.countModel.unevaluate>0) {
        [self.unHandlerNumArray replaceObjectAtIndex:2 withObject:@(self.countModel.unevaluate)];
    }else if (self.countModel.returned>0) {
        [self.unHandlerNumArray replaceObjectAtIndex:3 withObject:@(self.countModel.returned)];
    }else if (self.countModel.userBonus>0) {
        [self.moneyTypeArray replaceObjectAtIndex:1 withObject:@(self.countModel.userBonus)];
    }else if (self.countModel.userPoints>0) {
        [self.moneyTypeArray replaceObjectAtIndex:2 withObject:@(self.countModel.userPoints)];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 88;
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 105;
        }else {
            return 44;
        }
    }else if (indexPath.section == 3) {
        return 105;
    }else {
        return 49;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        MLPersonalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadCell"];
        if([[HXSUserAccount currentAccount] isLogin]) {
            HXSUserBasicInfo *basicInfo = [HXSUserAccount currentAccount].userInfo.basicInfo;
            if(basicInfo) {
                [cell.headImageView setContentMode:UIViewContentModeScaleAspectFill];
                [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:basicInfo.headPic] placeholderImage:[UIImage imageNamed:@"dsfdl-tx"]];
                cell.userNameLabel.text = basicInfo.userName;
                cell.signatureLabel.text = basicInfo.signature;
            }
        }
        
        return cell;
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        LGMineOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:orderStateCell forIndexPath:indexPath];
        cell.unreadNumberArray = self.unHandlerNumArray;
        cell.OrderCenterHandler = ^{
            [self enterOrderCenterWithStateName:@""];
        };
        cell.OrderStateDetailHandler = ^(NSString *stateName) {
            [self enterOrderCenterWithStateName:stateName];
        };
        return cell;

    }else if (indexPath.section == 3) {
        LGMineMoneyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:chargeCell forIndexPath:indexPath];
        cell.userMoney = [NSString stringWithFormat:@"%.2f",self.countModel.userMoney];
        cell.numbersArray = self.moneyTypeArray;
        cell.chargeOrWithdrawHandler = ^{ //充值与体现
            LGChargeWithdrawViewController *chargeVC = [LGChargeWithdrawViewController new];
            chargeVC.hidesBottomBarWhenPushed = YES;
            chargeVC.blanceMoney = [NSString stringWithFormat:@"%.2f",self.countModel.userMoney];
            [self.navigationController pushViewController:chargeVC animated:YES];
        };
        cell.oneModuleDetailHandler = ^(NSString *moduleName) {
            if ([moduleName isEqualToString:@"红包"]) {
                LGMyRedEnvelopsViewController *redVC = [LGMyRedEnvelopsViewController new];
                redVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:redVC animated:YES];
            }
        };
        return cell;
    }else {
        LGMineCommonTableCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCell];
        NSDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
        cell.icon = dic[@"logo"];
        cell.typeName = dic[@"typeName"];
        cell.detailValue = dic[@"subTitle"];
        if (indexPath.section == 2 && indexPath.row == 1) {
            if (self.defaultAddress) {
                cell.typeName = [NSString stringWithFormat:@"%@%@%@%@",self.defaultAddress.provinceName.length?self.defaultAddress.provinceName:@"",self.defaultAddress.cityName.length?self.defaultAddress.cityName:@"",self.defaultAddress.districtName.length?self.defaultAddress.districtName:@"",self.defaultAddress.address.length?self.defaultAddress.address:@""];
            }else {
                cell.typeName = @"默认收货地址";
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.section == 0 && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"ShowDetail" sender:nil];
    }else if (indexPath.section == 1) {
        HXSCommunityMyCenterViewController *controller = [HXSCommunityMyCenterViewController controllerFromXib];
        controller.hidesBottomBarWhenPushed = YES;
        controller.userIdNum = [[HXSUserAccount currentAccount] userID];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            LGReceiveAddressViewController *address = [LGReceiveAddressViewController new];
            address.motifyReceiveAddressBlock = ^(LGReceiveAddressModel *model) {
                self.defaultAddress = model;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
            };
            address.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:address animated:YES];
        }
    }else if (indexPath.section == 4){
        LGPromotionViewController *promotionVC = [LGPromotionViewController new];
        promotionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:promotionVC animated:YES];
    }
}

- (void)enterOrderCenterWithStateName:(NSString *)stateName {
    LGOrderCenterViewController *orderVC = [LGOrderCenterViewController new];
    orderVC.stateName = stateName;
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}
@end
