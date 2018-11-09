//
//  MLUserDetailViewController.m
//  meyley
//
//  Created by chsasaw on 2017/5/14.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLUserDetailViewController.h"
#import "MLUserInviteViewController.h"
#import "HXSUserInfo.h"
#import "HXSUserBasicInfo.h"
#import "HXSUserAccountModel.h"
#import "MBProgressHUD+HXS.h"

@interface MLUserDetailViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *addButton;

@property (nonatomic, strong) HXSUserBasicInfo *userInfo;

@end

@implementation MLUserDetailViewController

+ (NSString *)storyboardName {
    return @"UserDetail";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人信息";
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = ML_SEPERATOR_COLOR;
    
    [self refresh];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refresh {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self.view];
    [HXSUserAccountModel getUserInfo:self.userId complete:^(HXSErrorCode code, NSString *message, HXSUserBasicInfo *info) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (kHXSNoError == code) {
            weakSelf.userInfo      = info;
        }else {
            [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:2];
        }
        
        [self.tableView reloadData];
        [self.addButton setTitle:info.isMyWaiter.boolValue?@"取消客服":@"选择客服" forState:UIControlStateNormal];
        [self.addButton setHidden:!info.isWaiter.boolValue];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.userInfo && self.userInfo.isWaiter.boolValue) {
        return section == 0 ? 5 : (section == 1 ? 2 : 3);
    }else {
        return section == 0 ? 2 : (section == 1 ? 0 : 3);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self tableView:tableView numberOfRowsInSection:section]?10:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }else {
        return 48;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXSUserBasicInfo *basicInfo = self.userInfo;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"HeadCell"];
            UIImageView *imageView = [cell viewWithTag:101];
            [imageView sd_setImageWithURL:[NSURL URLWithString:basicInfo.headPic] placeholderImage:[UIImage imageNamed:@"dsfdl-tx"]];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = imageView.frame.size.width * 0.5;
            
            UILabel *nameLabel = [cell viewWithTag:102];
            nameLabel.text = basicInfo.waiterName;
        }else if(indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendCode"];
            UILabel *codeNumLabel = [cell viewWithTag:101];
            codeNumLabel.text = basicInfo.inviteCode;
        }else if(indexPath.row == 2) {
            cell.textLabel.text = @"姓名";
            cell.detailTextLabel.text = basicInfo.realName;
        }else if(indexPath.row == 3) {
            cell.textLabel.text = @"职务";
            cell.detailTextLabel.text = basicInfo.duty;
        }else {
            cell.textLabel.text = @"等级";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"LV %ld", basicInfo.rank.integerValue];
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"联系方式";
            cell.detailTextLabel.text = basicInfo.mobile;
        }else if(indexPath.row == 1) {
            cell.textLabel.text = @"微信号";
            cell.detailTextLabel.text = basicInfo.weixin;
        }else if(indexPath.row == 2) {
            cell.textLabel.text = @"微信二维码";
            cell.detailTextLabel.text = @"无";
        }
    }else {
        if(indexPath.row == 0) {
            cell.accessoryType = UITableViewRowActionStyleDestructive;
            cell.textLabel.text = @"性别";
            cell.detailTextLabel.text = basicInfo.getSexString;
        }else if(indexPath.row == 1) {
            cell.textLabel.text = @"地区";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", basicInfo.provinceName, basicInfo.cityName];
        }else if(indexPath.row == 2) {
            cell.textLabel.text = @"个性签名";
            cell.detailTextLabel.text = basicInfo.signature;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 0) {
        if(indexPath.row == 1) {
            //
            MLUserInviteViewController *controller = [MLUserInviteViewController controllerFromStoryboard];
            controller.userId = self.userId;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if(indexPath.section == 0){
        if(indexPath.row == 0) {
            
        }
    }
}

- (IBAction)addOrRemoveWaiter:(id)sender {
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:self.userInfo.isMyWaiter.boolValue?@"您确认要取消当前客服么?":@"选择该客服为您的专属客服？"
                                                                      message:nil
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"确定"];
    alertView.rightBtnBlock = ^{
        [MBProgressHUD showInView:self.view];
        if(self.userInfo.isMyWaiter.boolValue) {
            [[HXSUserAccount currentAccount].userInfo removeMyWaiter:^(BOOL success, NSString *msg) {
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                [MBProgressHUD showInViewWithoutIndicator:self.view status:msg afterDelay:2.0 andWithCompleteBlock:^{
                    [self refresh];
                }];
            }];
        }else {
            [[HXSUserAccount currentAccount].userInfo addMyWaiter:self.userInfo.waiterId complete:^(BOOL success, NSString *msg) {
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                [MBProgressHUD showInViewWithoutIndicator:self.view status:msg afterDelay:2.0 andWithCompleteBlock:^{
                    [self refresh];
                }];
            }];
        }
        
    };
    [alertView show];
}

@end
