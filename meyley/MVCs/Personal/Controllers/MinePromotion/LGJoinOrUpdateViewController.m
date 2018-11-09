//
//  LGJoinOrUpdateViewController.m
//  meyley
//
//  Created by Bovin on 2018/10/19.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGJoinOrUpdateViewController.h"
#import "LGTopIndicatorBar.h"
//申请填写view
#import "LGApplicationJoinView.h"
//审核状态的view
#import "LGApplicationStatusView.h"

#import "LGJoinStatusModel.h"
//客服等级
#import "LGWaiterGradeModel.h"
//选择所在区域
#import "LGChooseAddressView.h"

@interface LGJoinOrUpdateViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) LGTopIndicatorBar *topBar;

@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) LGApplicationJoinView *applicationView;

@property (nonatomic, strong) LGApplicationStatusView *reviewView;
@property (nonatomic, strong) LGApplicationStatusView *approveView;
@property (nonatomic, strong) LGApplicationStatusView *successView;

@property (nonatomic, strong) LGJoinStatusModel *statusModel;

@property (nonatomic, strong) NSMutableArray *waiterListArray;

@property (nonatomic, strong) LGChooseAddressView *addressView;

@end

@implementation LGJoinOrUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"申请加盟/升级";
    
    self.waiterListArray = [NSMutableArray array];

    //获取申请加盟的状态（判断是初次还是有加盟过）
    [self getJoinOrUpdateStatusData];
    
    //获取客服等级数据
    [self getWaiterTypeListData];
    
}
- (void)setupSubviews {
        [self.view addSubview:self.topBar];
        [self.view addSubview:self.bgScrollView];
        [self.bgScrollView addSubview:self.applicationView];
        [self.bgScrollView addSubview:self.reviewView];
        [self.bgScrollView addSubview:self.approveView];
        [self.bgScrollView addSubview:self.successView];
}

//获取加盟或升级状态的数据
- (void)getJoinOrUpdateStatusData {
    [MBProgressHUD showInView:self.view];
    NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
    NSString *action = [NSString stringWithFormat:@"userId=%@",userId];
    [RequestUtil withGET:@"/api/popCenter/getApplyForm.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self setupSubviews];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) { //能够查询到
            NSDictionary *dic = responseObject[@"result"];
            if (dic && dic.count && [dic isKindOfClass:[NSDictionary class]] && ![dic isKindOfClass:[NSNull class]]) {
                self.statusModel = [LGJoinStatusModel mj_objectWithKeyValues:dic];
                
                //根据状态展示对应的界面
                [self handleUserJoiningStatus];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
//处理用户的状态
- (void)handleUserJoiningStatus {
    //申请状态status。0:审核中，1:申请通过，2:已拒绝，3：已冻结，4：已付款 ，5：主动取消
    if ([self.statusModel.status isEqualToString:@"0"]) { //审核中
        [self.bgScrollView setContentOffset:CGPointMake(Screen_W, 0) animated:NO];
    }else if ([self.statusModel.status isEqualToString:@"1"]) { //审核通过待付款
        [self.bgScrollView setContentOffset:CGPointMake(Screen_W*2, 0) animated:NO];
    }else if ([self.statusModel.status isEqualToString:@"4"]) {
        [self.bgScrollView setContentOffset:CGPointMake(Screen_W*3, 0) animated:NO];
    }
    
}
//获取客服等级数据
- (void)getWaiterTypeListData {
   
    [RequestUtil withGET:@"/api/mw/waiter/rank/list.action" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) { //能够查询到
            [self.waiterListArray removeAllObjects];
            NSMutableArray *tmpArr = [LGWaiterGradeModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            [self.waiterListArray addObjectsFromArray:tmpArr];
            self.applicationView.waiterListArray = self.waiterListArray;
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//用户放弃申请(提交申请后放弃)
- (void)userGiveUpApplyToJoin {
    
    NSDictionary *action = @{@"id":@([self.statusModel.Id intValue])};
    [RequestUtil withPOST:@"/api/popCenter/giveUpApply.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark--UIScrollViewDelegate---
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/Screen_W;
    if (index == 0) {
        self.topBar.currentType = @"";
    }else if (index == 1) {
        self.topBar.currentType = @"平台审核";
    }else if (index == 2) {
        self.topBar.currentType = @"支付费用";
    }else if (index == 3) {
        self.topBar.currentType = @"加盟成功";
    }
}
#pragma mark--lazy-----
- (LGTopIndicatorBar *)topBar {
    
    if (!_topBar) {
        
        _topBar = [[LGTopIndicatorBar alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(44))];
    }
    return _topBar;
}
- (UIScrollView *)bgScrollView {
    
    if (!_bgScrollView) {
        
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, viewPix(44), Screen_W, Screen_H-topBarHeight-viewPix(44))];
        _bgScrollView.backgroundColor = [UIColor clearColor];
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.delegate = self;
        _bgScrollView.scrollEnabled = NO;
        _bgScrollView.contentSize = CGSizeMake(Screen_W*4, _bgScrollView.height);
    }
    return _bgScrollView;
}

- (LGApplicationJoinView *)applicationView {
    
    if (!_applicationView) {
        
        _applicationView = [[LGApplicationJoinView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, self.bgScrollView.frame.size.height)];
        __weak typeof(self)weakSelf = self;
        _applicationView.waiterListArray = self.waiterListArray;
        _applicationView.sureApplicationJoinBlock = ^{
            [weakSelf.bgScrollView setContentOffset:CGPointMake(Screen_W, 0) animated:NO];
        };
        _applicationView.cancelApplicationBlock = ^{ //放弃申请
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _applicationView.showUserProtocolBlock = ^{ //查看用户协议
            
        };
        _applicationView.chooseUserAddressBlock = ^(UITextField *textField) {
            weakSelf.addressView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            weakSelf.addressView.chooseAddressIdsAndNames = ^(NSDictionary *dic) {
//                weakSelf.provinceName = dic[@"provinceName"];
//                weakSelf.province = dic[@"provinceId"];
//                weakSelf.cityName = dic[@"cityName"];
//                weakSelf.city = dic[@"cityId"];
//                weakSelf.areaName = dic[@"areaName"];
//                weakSelf.area = dic[@"areaId"];
//                NSString *add = [NSString stringWithFormat:@"%@%@%@",weakSelf.provinceName.length?weakSelf.provinceName:@"",weakSelf.cityName.length?weakSelf.cityName:@"",weakSelf.areaName.length?weakSelf.areaName:@""];
//                textField.text = add;
            };
            [self presentViewController:self.addressView animated:NO completion:^{
                self.addressView.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
            }];        };
    }
    return _applicationView;
}
//正在审核
- (LGApplicationStatusView *)reviewView {
    
    if (!_reviewView) {
        
        _reviewView = [[LGApplicationStatusView alloc]initWithFrame:CGRectMake(Screen_W, 0, Screen_W, self.bgScrollView.frame.size.height)];
        _reviewView.status = LGApplicationStatusWaitReview;
        __weak typeof(self)weakSelf = self;
        _reviewView.userActionComplementBlock = ^(LGApplicationStatus status) {
            //取消审核
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *commit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf userGiveUpApplyToJoin];
            }];
            [alert addAction:action];
            [alert addAction:commit];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        };
    }
    return _reviewView;
}
//审核通过
- (LGApplicationStatusView *)approveView {
    
    if (!_approveView) {
        
        _approveView = [[LGApplicationStatusView alloc]initWithFrame:CGRectMake(Screen_W*2, 0, Screen_W, self.bgScrollView.frame.size.height)];
        _approveView.status = LGApplicationStatusApproved;
        __weak typeof(self)weakSelf = self;
        _approveView.userActionComplementBlock = ^(LGApplicationStatus status) {
            [weakSelf.bgScrollView setContentOffset:CGPointMake(Screen_W*3, 0) animated:NO];
        };
    }
    return _approveView;
}
//加盟成功
- (LGApplicationStatusView *)successView {
    
    if (!_successView) {
        
        _successView = [[LGApplicationStatusView alloc]initWithFrame:CGRectMake(Screen_W*3, 0, Screen_W, self.bgScrollView.frame.size.height)];
        _successView.status = LGApplicationStatusSuccessed;
        __weak typeof(self)weakSelf = self;
        _successView.userActionComplementBlock = ^(LGApplicationStatus status) {
            [weakSelf.bgScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        };
    }
    return _successView;
}

- (LGChooseAddressView *)addressView {
    
    if (!_addressView) {
        
        _addressView = [[LGChooseAddressView alloc]init];
    }
    return _addressView;
}
@end
