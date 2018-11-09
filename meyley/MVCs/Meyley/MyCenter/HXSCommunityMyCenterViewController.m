//
//  HXSCommunityMineCenterViewController.m
//  store
//
//  Created by J006 on 16/5/5.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityMyCenterViewController.h"
#import "HXSelectionControl.h"
#import "HXSProfileCenterHeaderView.h"
#import "HXSCommunityMyCenterTableDelegate.h"
#import "HXSCommunityTagTableDelegate.h"
#import "MLUserSpace.h"
#import "MLUserSpace.h"
#import "HXSCommunityModel.h"
#import "MLFollowListViewController.h"
#import "MLUserDetailViewController.h"
#import "HXSCommunityTagModel.h"
#import "HXSLoginViewController.h"

typedef NS_ENUM(NSInteger, HXSMyCenterSelectSectionIndex)
{
    kHXSMyCenterSelectSectionIndexPost       = 0,
    kHXSMyCenterSelectSectionIndexMyReply    = 1,
    kHXSMyCenterSelectSectionIndexReplyForMe = 2,
};

static const CGFloat    HEADERVIEW_HEIGHT           = 240;      // 默认顶部高度
static const CGFloat    DEFAULT_IP6_HEIGHT          = 667;      // ip6屏幕高度

#define headerViewHeightResize HEADERVIEW_HEIGHT * SCREEN_HEIGHT / DEFAULT_IP6_HEIGHT

@interface HXSCommunityMyCenterViewController ()

@property (weak, nonatomic) IBOutlet UITableView                  *mainTableView;

@property (weak, nonatomic) IBOutlet UIStackView           *followView;
@property (weak, nonatomic) IBOutlet UIStackView            *praiseView;
@property (weak, nonatomic) IBOutlet UIStackView            *fansView;
@property (weak, nonatomic) IBOutlet UILabel           *followLabel;
@property (weak, nonatomic) IBOutlet UILabel            *praiseLabel;
@property (weak, nonatomic) IBOutlet UILabel            *fansLabel;

@property (weak, nonatomic) IBOutlet UIView   *headerView;

@property (strong, nonatomic) HXSProfileCenterHeaderView *profileHeaderView;

@property (nonatomic, strong) UIBarButtonItem                     *rightBarButtonItem;
/** 高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint           *headerViewHeightConstraint;

@property (nonatomic, strong) HXSCommunityTagTableDelegate                      *tagTableDelegate;
@property (nonatomic, strong) MLUserSpace *userSpace;

@property (nonatomic, weak) IBOutlet UIView *bottomBarView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottombarHeight;
@property (nonatomic, weak) IBOutlet UIButton *followButton;

@end

@implementation HXSCommunityMyCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self initHeaderView];
    [self initViewGestures];
    [self initTableView];
    [self initialNavigation];
    [self initUserInfoData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init

- (void)initialNavigation
{
    [self.navigationItem setRightBarButtonItem:self.rightBarButtonItem];
    
    [self.navigationItem setTitle:@""];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];

}

- (void)initViewGestures
{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFollowList:)];
    tap1.numberOfTapsRequired = 1;
    tap1.numberOfTouchesRequired = 1;
    [self.followView addGestureRecognizer:tap1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initUserInfoData) name:kMLPOSTADDED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initUserInfoData) name:kMLCOMMENTADDED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initUserInfoData) name:kMLPOSTSTATUSCHANGED object:nil];
}

- (void)initHeaderView
{
    self.profileHeaderView = [HXSProfileCenterHeaderView profileCenterHeaderView];
    [self.headerView addSubview:self.profileHeaderView];
    [self.profileHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left);
        make.right.equalTo(self.headerView.mas_right);
        make.top.equalTo(self.headerView.mas_top);
        make.bottom.equalTo(self.headerView.mas_bottom);
    }];
    _headerViewHeightConstraint.constant = headerViewHeightResize;
}

- (void)initTableView
{
    [self.tagTableDelegate loadDataFromServerWithUserId:self.userIdNum];
    [self.tagTableDelegate initWithTableView:_mainTableView superViewController:self];
    
    __weak typeof (self) weakSelf = self;
    [_mainTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf.tagTableDelegate loadMore];
    }];
    [_mainTableView setShowsPullToRefresh:NO];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initUserInfoData {
    if(self.userIdNum && [[HXSUserAccount currentAccount].userID isEqualToNumber:self.userIdNum]) {
        self.bottombarHeight.constant = 0;
        self.bottomBarView.hidden = YES;
    }else {
        self.bottombarHeight.constant = 44;
        self.bottomBarView.hidden = NO;
    }
    
    [HXSCommunityModel getCommunityUserSpaceInfoWithUserId:self.userIdNum.stringValue complete:^(HXSErrorCode code, NSString *message, MLUserSpace *userSpace) {
        self.userSpace = userSpace;
        
        [self refreshUi];
    }];
}

- (void)refreshUi {
    self.followLabel.text = self.userSpace.followCount.stringValue;
    self.praiseLabel.text = self.userSpace.praiseCount.stringValue;
    self.fansLabel.text = self.userSpace.fansCount.stringValue;
    
    self.followButton.selected = self.userSpace.isFollow.boolValue;
    
    [_profileHeaderView initTheProfileCenterHeaderViewWithUser:self.userSpace];
    
    
    [self.tagTableDelegate initData:self.userSpace.dynamicsList];
    [self.mainTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tagTableDelegate tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tagTableDelegate tableView:tableView cellForRowAtIndexPath:indexPath];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tagTableDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tagTableDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self headerViewHeightConstraintChangeWithScrollView:scrollView];
//}

//- (void)headerViewHeightConstraintChangeWithScrollView:(UIScrollView *)scrollView
//{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    CGFloat delta = offsetY;
//    CGFloat height = headerViewHeightResize - delta;
//
//    if (height < NAVIGATION_STATUSBAR_HEIGHT) {
//        height = NAVIGATION_STATUSBAR_HEIGHT;
//    }
//    CGFloat alpha = delta / (headerViewHeightResize - NAVIGATION_STATUSBAR_HEIGHT);
//    if (alpha > 0) {
//        if (alpha >= 1) {
//            alpha = 1;
//        }
//    }
//    UIColor *color = ML_MAIN_COLOR;
//    [self.navigationController.navigationBar at_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
//    [self.navigationController.navigationBar at_setTitleAlpha:alpha];
//}

#pragma mark - UIBarButtonItem Action

- (void)showFollowList:(id)sender {
    MLFollowListViewController *controller = [MLFollowListViewController controllerFromXib];
    controller.userId = self.userIdNum;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  跳转到个人信息编辑界面
 *
 */
- (void)profileEditAction:(UIBarButtonItem *)barButtonItem
{
    MLUserDetailViewController *controller = [MLUserDetailViewController controllerFromStoryboard];
    controller.userId = self.userIdNum;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  关注
 */
- (IBAction)onClickFollow:(id)sender {
    if(!self.userSpace) {
        return;
    }
    
    if ([HXSUserAccount currentAccount].isLogin){
        
        if(!self.userSpace.isFollow.boolValue) {
            [HXSCommunityTagModel communityFollowUserWithUserId:self.userSpace.userId.stringValue complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                if (code == kHXSNoError) {
                    
                    self.userSpace.isFollow = @(1);
                    
                    [self refreshUi];
                }
                
                [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:2.0];
            }];
        }else {
            [HXSCommunityTagModel communityUnFollowUserWithUserId:self.userSpace.userId.stringValue complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                
                if (code == kHXSNoError) {
                    
                    self.userSpace.isFollow = @(0);
                    
                    [self refreshUi];
                }
                
                [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:2.0];
            }];
        }
        
    } else {
        
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            
        }];
    }
}

- (IBAction)onClickContact:(id)sender {
    MLUserDetailViewController *controller = [MLUserDetailViewController controllerFromStoryboard];
    controller.userId = self.userIdNum;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - private methods

#pragma mark - getter setter

- (UIBarButtonItem *)rightBarButtonItem
{
    if(!_rightBarButtonItem) {
        UIImage *image = [UIImage imageNamed:@"nav-more"];
        _rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(profileEditAction:)];
    }
    return _rightBarButtonItem;
}

- (HXSCommunityTagTableDelegate *)tagTableDelegate
{
    if(!_tagTableDelegate) {
        _tagTableDelegate = [[HXSCommunityTagTableDelegate alloc]init];
    }
    return _tagTableDelegate;
}

@end
