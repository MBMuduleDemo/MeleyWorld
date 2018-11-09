//
//  MLMyServiceViewController.m
//  meyley
//
//  Created by chsasaw on 2017/5/7.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLMyServiceViewController.h"
#import "MLEvaluateView.h"
#import "MLWaiterModel.h"
#import "HXSUserAccount.h"
#import "HXSUserInfo.h"
#import "UIImageView+WebCache.h"
#import "HXSCustomAlertView.h"
#import "MBProgressHUD+HXS.h"
#import "MLUserDetailViewController.h"
#import "MLLocationSelectView.h"
#import "MLAddServiceViewController.h"

@interface MLMyServiceViewController ()

@property (nonatomic, weak) IBOutlet UIView *myServiceView;
@property (nonatomic, weak) IBOutlet UIView *addServiceView;
@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet MLEvaluateView *evaluateView;
@property (nonatomic, weak) IBOutlet UIView *selectViewContainer;

@end

@implementation MLMyServiceViewController

+ (NSString *)storyboardName {
    return @"Friends";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshUI];
}

- (void)refreshUI {
    MLWaiterModel *myWaiter = [HXSUserAccount currentAccount].userInfo.myWaiter;
    if(myWaiter) {
        self.myServiceView.hidden = NO;
        self.addServiceView.hidden = YES;
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:myWaiter.headPic] placeholderImage:[UIImage imageNamed:@"service_headimg"]];
        [self.headImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.headImageView.layer setCornerRadius:self.headImageView.frame.size.width*0.5];
        self.headImageView.layer.masksToBounds = YES;
        
        self.userNameLabel.text = myWaiter.waiterName;
        self.locationLabel.text = [NSString stringWithFormat:@"%@.%@", myWaiter.cityName, myWaiter.provinceName];
        [self.evaluateView setEvaluate:myWaiter.rank.integerValue];
    }else {
        self.myServiceView.hidden = YES;
        self.addServiceView.hidden = NO;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAdd:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [self.addServiceView addGestureRecognizer:tap];
    
    [self.selectViewContainer addSubview:[MLLocationSelectView selectView]];
    self.selectViewContainer.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (IBAction)onClickCancel:(id)sender {
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle: @"您确认要取消当前客服么?"
                                                                      message:nil
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"确定"];
    //删除回复
    alertView.rightBtnBlock = ^{
        [MBProgressHUD showInView:self.view];
        [[HXSUserAccount currentAccount].userInfo removeMyWaiter:^(BOOL success, NSString *msg) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [MBProgressHUD showInViewWithoutIndicator:self.view status:msg afterDelay:2.0];
            [self refreshUI];
        }];
    };
    [alertView show];
}

- (IBAction)onClickContact:(id)sender {
    MLUserDetailViewController *controller = [MLUserDetailViewController controllerFromStoryboard];
    controller.userId = [HXSUserAccount currentAccount].userInfo.myWaiter.userId;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickAdd:(id)sender {
    MLAddServiceViewController *controller = [MLAddServiceViewController controllerFromStoryboard];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
