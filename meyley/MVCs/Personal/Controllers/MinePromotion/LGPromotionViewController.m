//
//  LGPromotionViewController.m
//  meyley
//
//  Created by Bovin on 2018/10/17.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGPromotionViewController.h"

#import "LGUserInfoView.h"
#import "LGUserQRCodeView.h"
#import "LGMyPerformanceView.h"
#import "LGMyCustomerView.h"

#import "LGPromotionHomeModel.h"

#import "LGCommissionViewController.h"
//我的客户
#import "LGMyCustomCenterViewController.h"
//申请加盟升级
#import "LGJoinOrUpdateViewController.h"

@interface LGPromotionViewController ()

@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) LGUserInfoView *infoView;
@property (nonatomic, strong) LGUserQRCodeView *rcCodeView;
@property (nonatomic, strong) LGMyPerformanceView *performanceView;
@property (nonatomic, strong) LGMyCustomerView *customView;

@property (nonatomic, strong) UIImageView *bannerImageView;

@property (nonatomic, strong) LGPromotionHomeModel *homeModel;

@end

@implementation LGPromotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"推广中心";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_center_share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareToPromotionApp)];
    
    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView addSubview:self.infoView];
    [self.bgScrollView addSubview:self.rcCodeView];
    [self.bgScrollView addSubview:self.performanceView];
    [self.bgScrollView addSubview:self.customView];
    
    [self getUserDataWithFilterDays:@""];
}
//分享
- (void)shareToPromotionApp {
    
}
#pragma mark--网络请求---
- (void)getUserDataWithFilterDays:(NSString *)days {
    NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
    NSString *action = [NSString stringWithFormat:@"userId=%@&days=%@",userId,days];
    [RequestUtil withGET:@"/api/popCenter/index.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {

        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            self.homeModel = [LGPromotionHomeModel mj_objectWithKeyValues:responseObject[@"result"]];
            if (!days.length) {
                self.rcCodeView.model = self.homeModel;
                self.performanceView.model = self.homeModel;
                self.customView.model = self.homeModel;
            }
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.bgScrollView.contentSize = CGSizeMake(Screen_W, CGRectGetMaxY(self.bannerImageView.frame)+20);
}

#pragma mark--action-----
- (void)goToMyCommissionRecodeList {
    LGCommissionViewController *commissionVC = [LGCommissionViewController new];
    commissionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commissionVC animated:YES];
}
//我的客户中心
- (void)goToMyCustomCenterWithIndex:(NSInteger)index {
    LGMyCustomCenterViewController *customVC = [LGMyCustomCenterViewController new];
    customVC.hidesBottomBarWhenPushed = YES;
    customVC.selectIndex = index;
    [self.navigationController pushViewController:customVC animated:YES];
}
#pragma mark--lazy----
- (UIScrollView *)bgScrollView {
    
    if (!_bgScrollView) {
        
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight)];
        _bgScrollView.backgroundColor = [UIColor clearColor];
        _bgScrollView.showsVerticalScrollIndicator = NO;
    }
    return _bgScrollView;
}
- (LGUserInfoView *)infoView {
    
    if (!_infoView) {
        
        _infoView = [[LGUserInfoView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(59))];
        __weak typeof(self)weakSelf = self;
        _infoView.applicationToJoinOrUpdate = ^{
            LGJoinOrUpdateViewController *joinVC = [LGJoinOrUpdateViewController new];
            joinVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:joinVC animated:YES];
        };
    }
    return _infoView;
}
- (LGUserQRCodeView *)rcCodeView {
    
    if (!_rcCodeView) {
        
        _rcCodeView = [[LGUserQRCodeView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoView.frame), Screen_W, viewPix(59))];
    }
    return _rcCodeView;
}
- (LGMyPerformanceView *)performanceView {
    
    if (!_performanceView) {
        
        _performanceView = [[LGMyPerformanceView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.rcCodeView.frame), Screen_W, viewPix(148))];
        __weak typeof(self)weakSelf = self;
        _performanceView.checkMyCommissionRecode = ^{
            [weakSelf goToMyCommissionRecodeList];
        };
    }
    return _performanceView;
}
- (LGMyCustomerView *)customView {
    
    if (!_customView) {
        
        _customView = [[LGMyCustomerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.performanceView.frame), Screen_W, viewPix(82))];
        __weak typeof(self)weakSelf = self;
        _customView.myCustomDetailInfo = ^(NSInteger index) {
            if (index == 0) {
                [weakSelf goToMyCommissionRecodeList];
            }else {
                [weakSelf goToMyCustomCenterWithIndex:(index-1)];
            }
        };
    }
    return _customView;
}

- (UIImageView *)bannerImageView {
    
    if (!_bannerImageView) {
        
        _bannerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.customView.frame), Screen_W, viewPix(200))];
    }
    return _bannerImageView;
}
@end
