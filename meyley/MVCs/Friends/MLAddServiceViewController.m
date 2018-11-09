//
//  MLAddServiceViewController.m
//  meyley
//
//  Created by chsasaw on 2017/5/29.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLAddServiceViewController.h"
#import "MLLocationSelectView.h"
#import "MLServiceRequestModel.h"
#import "MLWaiterModel.h"
#import "HXSCommunityMyCenterViewController.h"
#import "MLRecommendWaiterView.h"
#import "MLWaiterTableViewCell.h"

@interface MLAddServiceViewController ()<UITableViewDelegate, UITableViewDataSource, MLLocationSelectViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *selectViewContainer;

@property (nonatomic, weak) IBOutlet UITableView *locationTableView;
@property (nonatomic, weak) IBOutlet UITableView *serviceTableView;

@property (nonatomic, strong) NSMutableArray<MLWaiterModel *> *waiters;

@end

@implementation MLAddServiceViewController

+ (NSString *)storyboardName {
    return @"Friends";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全部客服";
    
    MLLocationSelectView *selectView = [MLLocationSelectView selectView];
    selectView.delegate = self;
    [selectView setTableView:self.locationTableView];
    [self.selectViewContainer addSubview:selectView];
    
    self.locationTableView.hidden = YES;
    self.locationTableView.rowHeight = 40;
    self.serviceTableView.rowHeight = 64;
    self.locationTableView.tableFooterView = [[UIView alloc] init];
    self.serviceTableView.tableFooterView = [[UIView alloc] init];
    self.serviceTableView.separatorColor = ML_SEPERATOR_COLOR;
    
    [self.serviceTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MLWaiterTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MLWaiterTableViewCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma MLLocationSelectViewDelegate
- (void)selectView:(MLLocationSelectView *)view onSelectProvince:(NSNumber *)provinceId city:(NSNumber *)cityId district:(NSNumber *)districtId {
    [MBProgressHUD showInView:self.view];
    [MLServiceRequestModel getWaiterListWithProvince:provinceId city:cityId district:districtId complete:^(HXSErrorCode code, NSString *message, NSArray<MLWaiterModel *> *waiters) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if(code == kHXSNoError) {
            [self.waiters removeAllObjects];
            [self.waiters addObjectsFromArray:waiters];
            [self.serviceTableView reloadData];
            if(self.waiters.count == 0) {
                MLRecommendWaiterView *waiterView = [MLRecommendWaiterView waiterView];
                self.serviceTableView.tableFooterView = waiterView;
                [waiterView showInViewController:self];
            }else {
                self.serviceTableView.tableFooterView = [[UIView alloc] init];
            }
        }else {
            [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:2];
        }
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.waiters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLWaiterModel *waiter = self.waiters[indexPath.row];
    MLWaiterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLWaiterTableViewCell"];
    cell.nameLabel.text = waiter.waiterName;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:waiter.headPic] placeholderImage:[UIImage imageNamed:@"dsfdl-tx"]];
    cell.locationLabel.text = [NSString stringWithFormat:@"%@ %@", waiter.provinceName, waiter.cityName];
    cell.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.headImageView.layer setCornerRadius:cell.headImageView.frame.size.width * 0.5];
    [cell.nameLabel setTextColor:ML_TEXT_MAIN_COLOR];
    [cell.nameLabel setFont:[UIFont systemFontOfSize:17]];
    [cell.locationLabel setTextColor:ML_TEXT_SUB_COLOR];
    [cell.locationLabel setFont:[UIFont systemFontOfSize:13]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MLWaiterModel *waiter = self.waiters[indexPath.row];
    HXSCommunityMyCenterViewController *communityOthersCenterViewController = [HXSCommunityMyCenterViewController controllerFromXib];
    
    communityOthersCenterViewController.userIdNum = waiter.userId;
    
    [self.navigationController pushViewController:communityOthersCenterViewController animated:YES];
}

#pragma getters
- (NSMutableArray<MLWaiterModel *> *)waiters {
    if(!_waiters) {
        _waiters = [NSMutableArray array];
    }
    
    return _waiters;
}

@end
