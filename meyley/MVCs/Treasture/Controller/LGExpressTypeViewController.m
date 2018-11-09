//
//  LGExpressTypeViewController.m
//  meyley
//
//  Created by Bovin on 2018/9/14.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGExpressTypeViewController.h"
#import "LGExpressTypeModel.h"
#import "LGExpressTypeView.h"
#import "LGExpressTimeView.h"

@interface LGExpressTypeViewController ()

@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) LGExpressTypeView *typeView;

@property (nonatomic, strong) LGExpressTimeView *timeView;

@property (nonatomic, strong) UIButton *sureBtn;

//记录选中的配送方式与时间
@property (nonatomic, strong) LGExpressTypeModel *typeModel;
@property (nonatomic, copy) NSString *bestTime;

@end

@implementation LGExpressTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"选择配送方式";
    [self.view addSubview:self.bgScrollView];
    [self getExpressTypeData];
}
#pragma mark--获取配送方式数据--
- (void)getExpressTypeData {

    NSString *action = [NSString stringWithFormat:@"cartIds=%@&addressId=%d",self.cartIds,[self.addressId intValue]];
    [RequestUtil withGET:@"/api/ecs/shipping/list.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.dataArray removeAllObjects];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            NSMutableArray *tmpArr = [LGExpressTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            [self.dataArray addObjectsFromArray:tmpArr];
            
            [self.bgScrollView addSubview:self.typeView];
            [self.bgScrollView addSubview:self.timeView];
            [self.bgScrollView addSubview:self.sureBtn];
            self.bgScrollView.contentSize = CGSizeMake(Screen_W, CGRectGetMaxY(self.sureBtn.frame)+20);
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark--action-----
- (void)sureChooseExpressType {
    if (!self.typeModel) {
        for (LGExpressTypeModel *model in self.dataArray) {
            if ([model.shippingStatus isEqualToString:@"0"]) {
                self.typeModel = model;
                break;
            }
        }
    }
    if (!self.bestTime.length) {
        self.bestTime = @"工作日";
    }
    if (self.chooseExpressFinishBlock) {
        self.chooseExpressFinishBlock(self.typeModel, self.bestTime);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark---lazy------
- (UIScrollView *)bgScrollView {
    
    if (!_bgScrollView) {
        
        _bgScrollView = [[UIScrollView alloc]init];
        _bgScrollView.frame = CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight);
        _bgScrollView.backgroundColor = [UIColor clearColor];
    }
    return _bgScrollView;
}
- (LGExpressTypeView *)typeView {
    
    if (!_typeView) {
        
        _typeView = [[LGExpressTypeView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 58+self.dataArray.count*53)];
        _typeView.expressArray = self.dataArray;
        __weak typeof(self)weakSelf =self;
        _typeView.expressTypeChooseBlock = ^(LGExpressTypeModel *model) {
            weakSelf.typeModel = model;
        };
    }
    return _typeView;
}

- (LGExpressTimeView *)timeView {
    
    if (!_timeView) {
        
        _timeView = [[LGExpressTimeView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.typeView.frame)+13, Screen_W, 108)];
        __weak typeof(self)weakSelf =self;
        _timeView.expressTimeChooseBlock = ^(NSString *time) {
            weakSelf.bestTime = time;
        };
    }
    return _timeView;
}

- (UIButton *)sureBtn {
    
    if (!_sureBtn) {
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(40, CGRectGetMaxY(self.timeView.frame)+50, Screen_W-80, 45);
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[UIImage imageWithColor:RGB(255, 0, 82)] forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[UIImage imageWithColor:RGB(255, 0, 82)] forState:UIControlStateHighlighted];
        [_sureBtn addTarget:self action:@selector(sureChooseExpressType) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _sureBtn.layer.cornerRadius = 5;
        _sureBtn.layer.masksToBounds = YES;
    }
    return _sureBtn;
}
- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
