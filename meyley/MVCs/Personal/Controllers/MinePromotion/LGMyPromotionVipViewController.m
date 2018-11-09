//
//  LGMyPromotionVipViewController.m
//  meyley
//
//  Created by Bovin on 2018/10/19.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGMyPromotionVipViewController.h"
#import "LGCustomVipTableViewCell.h"

#import "LGMyUserModel.h"


@interface LGMyPromotionVipViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

//占位图,没有数据时
@property(nonatomic , strong) UIView * tableViewBackView;

@end

@implementation LGMyPromotionVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    
    [self getMyInviteVipUserData];
}
- (void)getMyInviteVipUserData {
    NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
    NSString *action = [NSString stringWithFormat:@"userId=%@",userId];
    [RequestUtil withGET:@"/api/popCenter/getMyInviteUser.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            NSMutableArray *tmp = [LGMyUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"users"]];
            [self.dataArray addObjectsFromArray:tmp];
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
        if (self.dataArray.count) {
            self.tableView.backgroundView.hidden = YES;
            [self.tableView reloadData];
        }else {
            self.tableView.backgroundView.hidden = NO;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark--UITableViewDataSource------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGCustomVipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LGCustomVipTableViewCell class]) forIndexPath:indexPath];
    cell.userModel = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return viewPix(70);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return viewPix(12);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

#pragma mark---UITableViewDelegate------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark---lazy-----
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
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
        [_tableView registerClass:[LGCustomVipTableViewCell class] forCellReuseIdentifier:NSStringFromClass([LGCustomVipTableViewCell class])];
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
        tableViewBackLabel.text = @"你还没有推荐的会员哟";
        [_tableViewBackView addSubview:tableViewBackLabel];
    }
    return _tableViewBackView;
}
@end
