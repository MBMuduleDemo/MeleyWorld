//
//  LGMyCustomCenterViewController.m
//  meyley
//
//  Created by Bovin on 2018/10/19.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGMyCustomCenterViewController.h"

#import "LGMyPromotionVipViewController.h"
#import "LGMyServiceVipViewController.h"

@interface LGMyCustomCenterViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentView;
//推荐的VIP
@property (nonatomic, strong) LGMyPromotionVipViewController *proVip;
//服务的VIP
@property (nonatomic, strong) LGMyServiceVipViewController *serviceVip;


@end

@implementation LGMyCustomCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.segmentView;

    if (self.selectIndex == 0) {
        self.segmentView.selectedSegmentIndex = 0;
        [self setPromotionVCFront];
    }else {
        self.segmentView.selectedSegmentIndex = 1;
        [self setServiceVipVCFront];
    }
}
- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
}
- (void)changeMyCustomerInfo:(UISegmentedControl *)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            NSLog(@"我推荐的会员");
            [self setPromotionVCFront];
            break;
        case 1:
            NSLog(@"我服务的会员");
            [self setServiceVipVCFront];
            break;
            
        default:
            break;
    }
}
//设置当前显示的为推荐的数据
- (void)setPromotionVCFront {
    [self addChildViewController:self.proVip];
    self.proVip.view.frame = CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight);
    [self.view addSubview:self.proVip.view];
}
- (void)setServiceVipVCFront {
    [self addChildViewController:self.serviceVip];
    self.serviceVip.view.frame = CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight);
    [self.view addSubview:self.serviceVip.view];
}

#pragma mark---lazy-----
- (UISegmentedControl *)segmentView {
    
    if (!_segmentView) {
        
        _segmentView = [[UISegmentedControl alloc]initWithItems:@[@"我推荐的会员",@"我服务的会员"]];
        _segmentView.frame = CGRectMake(0, 0, 200, 30);
        [_segmentView addTarget:self action:@selector(changeMyCustomerInfo:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentView;
}

- (LGMyPromotionVipViewController *)proVip {
    
    if (!_proVip) {
        
        _proVip = [[LGMyPromotionVipViewController alloc]init];
    }
    return _proVip;
}

- (LGMyServiceVipViewController *)serviceVip {
    
    if (!_serviceVip) {
        
        _serviceVip = [[LGMyServiceVipViewController alloc]init];
    }
    return _serviceVip;
}


@end
