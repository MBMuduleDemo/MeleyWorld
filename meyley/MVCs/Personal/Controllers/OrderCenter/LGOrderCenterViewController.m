//
//  LGOrderCenterViewController.m
//  meyley
//
//  Created by Bovin on 2018/10/8.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGOrderCenterViewController.h"
#import "MBPageContentView.h"
#import "MBSegmentStyle.h"
#import "MBSegmentScrollView.h"

//各种状态的VC
#import "LGAllOrderViewController.h"
#import "LGWaitPayViewController.h"
#import "LGWaitReceiveViewController.h"
#import "LGWaitCommentViewController.h"
#import "LGAfterSalesViewController.h"


@interface LGOrderCenterViewController ()

@property (nonatomic, strong) MBPageContentView *contentView;
@property (nonatomic, strong) MBSegmentScrollView *segmentView;

@property (nonatomic, strong) NSArray *vcArray;
@property (nonatomic, strong) NSArray *nameArray;

@property (nonatomic, assign) BOOL isFirstEnter;//第一次进入该界面

@end

@implementation LGOrderCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单中心";
    self.vcArray = @[[LGAllOrderViewController new],[LGWaitPayViewController new],[LGWaitReceiveViewController new],[LGWaitCommentViewController new],[LGAfterSalesViewController new]];
    self.nameArray = @[@"全部",@"待付款",@"待收货",@"待评价",@"退货/售后"];
    self.isFirstEnter = YES;
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.contentView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //第一次进入该界面时，判断跳转到那个界面
    if (self.isFirstEnter || self.allowChangeState) {
        if (self.stateName.length>0) {
            int i = 0;
            for (NSString *name in self.nameArray) {
                if ([name isEqualToString:self.stateName]) {
                    [self.segmentView setSelectedIndex:i animated:YES];
                }
                i++;
            }
        }else {
            [self.segmentView setSelectedIndex:0 animated:YES];
        }
        self.isFirstEnter = NO;
        self.allowChangeState = NO;
    }
    
}
- (void)setStateName:(NSString *)stateName {
    _stateName = stateName;
    if (self.allowChangeState) {  //在订单中心操作时，改变订单状态使用
        if (stateName.length>0) {
            int i = 0;
            for (NSString *name in self.nameArray) {
                if ([name isEqualToString:stateName]) {
                    [self.segmentView setSelectedIndex:i animated:YES];
                }
                i++;
            }
        }
        self.allowChangeState = NO;
    }
}

#pragma mark--lazy------
- (MBPageContentView *)contentView {
    
    if (!_contentView) {
        
        _contentView = [[MBPageContentView alloc]initWithFrame:CGRectMake(0, 49, Screen_W, Screen_H-topBarHeight-49) segmentView:self.segmentView childVCs:self.vcArray parentViewController:self];
    }
    return _contentView;
}

- (MBSegmentScrollView *)segmentView {
    
    if (!_segmentView) {
        MBSegmentStyle *style = [[MBSegmentStyle alloc]init];
        style.showLine = YES;
        style.titleMargin = ((Screen_W-20)/5)-40;
        style.edgeMargin = 0;
        style.scrollLineWidth = 50;
        style.titleFont = [UIFont systemFontOfSize:14];
        style.scrollLineColor = RGB(255, 0, 82);
        style.scrollLineBottomMargin = 0;
        style.normalTitleColor = RGB(66, 62, 62);
        style.selectedTitleColor = RGB(255, 0, 82);
        __weak typeof(self)weakSelf = self;
        _segmentView = [[MBSegmentScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 49) segmentStyle:style titles:self.nameArray margin:0 titleDidClick:^(UILabel *titleLabel, NSInteger index) {
            [weakSelf.contentView setSelectItemIndex:index];
        }];
        _segmentView.backgroundColor = [UIColor whiteColor];
    }
    return _segmentView;
}
@end
