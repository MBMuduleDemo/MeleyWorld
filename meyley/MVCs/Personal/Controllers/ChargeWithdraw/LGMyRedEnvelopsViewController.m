//
//  LGMyRedEnvelopsViewController.m
//  meyley
//
//  Created by Bovin on 2018/10/17.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGMyRedEnvelopsViewController.h"

#import "LGMyBunsTableViewCell.h"
#import "LGRedEnvelopModel.h"

//添加红包弹框
#import "LGAddRedEnvelopAlertView.h"

@interface LGMyRedEnvelopsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
//添加红包
@property (nonatomic, strong) UIButton *addRedEnvelopBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;

//占位图,没有数据时
@property(nonatomic , strong) UIView * tableViewBackView;

//红包弹框
@property (nonatomic, strong) LGAddRedEnvelopAlertView *alertView;
//红包码
@property (nonatomic, copy) NSString *redCode;

@end

static NSString *const myRedEnvelopCell = @"myRedEnvelopCell";
@implementation LGMyRedEnvelopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.navigationItem.title = @"我的红包";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addRedEnvelopBtn];
    
    //获取所有可用的红包
    [self getAllEnableRedEnvelops];
}
- (void)getAllEnableRedEnvelops {
    
    NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
    NSString *action = [NSString stringWithFormat:@"userId=%@",userId];
    [RequestUtil withGET:@"/api/mw/user/bonus/list.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            NSNumber *total = [responseObject objectForKey:@"total"];
            if ([total integerValue]>0) {
                NSMutableArray *tmpArr = [LGRedEnvelopModel mj_objectArrayWithKeyValuesArray:responseObject[@"bonusList"]];
                [self.dataArray addObjectsFromArray:tmpArr];
            }
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
        if (self.dataArray.count) {
            for (NSInteger i = 0; i<self.dataArray.count; i++) {
                LGRedEnvelopModel *model = self.dataArray[i];
                if (model.isUsed) {
                    [self.dataArray removeObject:model];
                }
                if ([[NSDate date] compare:[MBTools transformDateFromDateString:model.useEndDate]] == NSOrderedDescending) { //过期的红包
                    [self.dataArray removeObject:model];
                }
            }
            self.tableView.backgroundView.hidden = YES;
            [self.tableView reloadData];
        }else {
            self.tableView.backgroundView.hidden = NO;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.addRedEnvelopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(viewPix(40));
        make.right.equalTo(self.view.mas_right).offset(-viewPix(40));
        make.bottom.equalTo(self.view.mas_bottom).offset(-viewPix(10));
        make.height.mas_equalTo(viewPix(45));
    }];
}
#pragma mark--UITableViewDataSource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGMyBunsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myRedEnvelopCell forIndexPath:indexPath];
    cell.redEnvelopModel = self.dataArray[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return viewPix(65);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return viewPix(15);
    }
    return viewPix(12);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

#pragma mark---UITableViewDelegate------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark--action---
- (void)addNewRedEnvelop {
    self.alertView = [[LGAddRedEnvelopAlertView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H) title:@"添加红包" commitBtnTitle:@"提交"];
    __weak typeof(self)weakSelf = self;
    self.alertView.redEnvelopCode = ^(NSString *redCode) {
        weakSelf.redCode = redCode;
    };
    self.alertView.sureBtnClickBlock = ^{
        [weakSelf.alertView removeFromSuperview];
        weakSelf.alertView = nil;
        [weakSelf requestToAddRedEnvelop];
    };
    
    [self.view.window addSubview:self.alertView];
}
//添加红包接口
- (void)requestToAddRedEnvelop {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [TooltipView showMessage:@"正在开发中..." offset:0];
    });
}
#pragma mark--lazy----
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight-viewPix(65)) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        if (kAPIVersion11Later) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.backgroundView = self.tableViewBackView;
        [_tableView registerClass:[LGMyBunsTableViewCell class] forCellReuseIdentifier:myRedEnvelopCell];
    }
    return _tableView;
}
- (UIView *)tableViewBackView {
    
    if (!_tableViewBackView) {
        
        _tableViewBackView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        
        UIImageView * tableViewBackImageView= [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W - viewPix(50))/2, _tableViewBackView.frame.size.height/2-viewPix(38), viewPix(50), viewPix(50))];
        tableViewBackImageView.image = [UIImage imageNamed:@""];
        [_tableViewBackView addSubview:tableViewBackImageView];
        
        UILabel * tableViewBackLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tableViewBackImageView.frame)+10, Screen_W, 50)];
        tableViewBackLabel.font = LGFont(15);
        tableViewBackLabel.textAlignment = NSTextAlignmentCenter;
        tableViewBackLabel.textColor = RGB(66, 62, 62);
        tableViewBackLabel.text = @"你还没有红包哟";
        [_tableViewBackView addSubview:tableViewBackLabel];
    }
    return _tableViewBackView;
}
- (UIButton *)addRedEnvelopBtn {
    
    if (!_addRedEnvelopBtn) {
        
        _addRedEnvelopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addRedEnvelopBtn setTitle:@"添加红包" forState:UIControlStateNormal];
        [_addRedEnvelopBtn setBackgroundColor:RGB(255, 0, 82) forState:UIControlStateNormal];
        [_addRedEnvelopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addRedEnvelopBtn addTarget:self action:@selector(addNewRedEnvelop) forControlEvents:UIControlEventTouchUpInside];
        _addRedEnvelopBtn.layer.cornerRadius = 5;
        _addRedEnvelopBtn.layer.masksToBounds = YES;
    }
    return _addRedEnvelopBtn;
}
@end
