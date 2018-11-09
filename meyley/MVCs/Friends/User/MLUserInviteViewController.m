//
//  MLUserInviteViewController.m
//  meyley
//
//  Created by chsasaw on 2017/5/16.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLUserInviteViewController.h"
#import "MLUserInviteHeaderView.h"
#import "HXSUserBasicInfo.h"
#import "HXSPersonalInfoModel.h"

@interface MLUserInviteViewController ()

@property (weak, nonatomic) IBOutlet UITableView                  *tableView;

@property (weak, nonatomic) IBOutlet UIView   *headerView;
@property (strong, nonatomic) MLUserInviteHeaderView *profileHeaderView;

@property (nonatomic, strong) HXSUserBasicInfo *basicInfo;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation MLUserInviteViewController

+ (NSString *)storyboardName {
    return @"UserDetail";
}

- (void)dealloc {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    
    [self initHeaderView];
    [self initTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initUserInfoData];
}

#pragma mark - init

- (void)initTableView {
    self.tableView.rowHeight = 200;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initHeaderView
{
    self.profileHeaderView = [MLUserInviteHeaderView headerView];
    [self.headerView addSubview:self.profileHeaderView];
    [self.profileHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left);
        make.right.equalTo(self.headerView.mas_right);
        make.top.equalTo(self.headerView.mas_top);
        make.bottom.equalTo(self.headerView.mas_bottom);
    }];
}

- (void)initUserInfoData {
    
    if(!self.isLoading) {
        self.isLoading = YES;
        [MBProgressHUD showInView:self.view];
        [HXSPersonalInfoModel inviteTheUser:self.userId complete:^(HXSErrorCode code, NSString *message, HXSUserBasicInfo *userInfo) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.isLoading = NO;
            if (code == kHXSNoError) {
                self.basicInfo = userInfo;
                __weak typeof (self) weakSelf = self;
                [_profileHeaderView initTheHeaderViewWithUser:userInfo];
                [_profileHeaderView setWaiterAction:^() {
                    [weakSelf cancelOrAddWaiter];
                }];
                
                [self.tableView reloadData];
            } else {
                
                [MBProgressHUD showInViewWithoutIndicator:self.tableView status:message afterDelay:3];
            }
        }];
    }
}

- (void)cancelOrAddWaiter {
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:self.basicInfo.isMyWaiter.boolValue?@"您确认要取消当前客服么?":@"选择该客服为您的专属客服？"
                                                                      message:nil
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"确定"];
    alertView.rightBtnBlock = ^{
        [MBProgressHUD showInView:self.view];
        if(self.basicInfo.isMyWaiter.boolValue) {
            [[HXSUserAccount currentAccount].userInfo removeMyWaiter:^(BOOL success, NSString *msg) {
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                [MBProgressHUD showInViewWithoutIndicator:self.view status:msg afterDelay:2.0 andWithCompleteBlock:^{
                    [self initUserInfoData];
                }];
            }];
        }else {
            [[HXSUserAccount currentAccount].userInfo addMyWaiter:self.basicInfo.waiterId complete:^(BOOL success, NSString *msg) {
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                [MBProgressHUD showInViewWithoutIndicator:self.view status:msg afterDelay:2.0 andWithCompleteBlock:^{
                    [self initUserInfoData];
                }];
            }];
        }
        
    };
    [alertView show];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
    if(indexPath.row == 0) {
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.basicInfo.adPic]];
    }else {
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.basicInfo.inviteCodeUrl]];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
