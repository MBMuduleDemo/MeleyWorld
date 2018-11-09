//
//  MLFollowListViewController.m
//  meyley
//
//  Created by chsasaw on 2017/4/4.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLFollowListViewController.h"
#import "MLCommentListViewController.h"
#import "HXSCommunityModel.h"
#import "MLFollowListTableViewCell.h"
#import "HXSUserBasicInfo.h"
#import "HXSCommunityMyCenterViewController.h"
#import "HXSCommunityTagModel.h"

@interface MLFollowListViewController ()

@property (nonatomic, strong) UIBarButtonItem *commentListItem;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <HXSUserBasicInfo *> *followList;

@end

@implementation MLFollowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initTheNavigationBar];
    [self initTableView];
    
    [self loadFollowListData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTheNavigationBar
{
    self.navigationItem.title = @"我的关注";
    
    [self.navigationItem setRightBarButtonItem:self.commentListItem];
}

- (void)initTableView {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MLFollowListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MLFollowListTableViewCell class])];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
}

- (NSMutableArray *)followList {
    if(!_followList) {
        _followList = [NSMutableArray array];
    }
    
    return _followList;
}

- (UIBarButtonItem *)commentListItem
{
    if(!_commentListItem) {
        _commentListItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ml-pl"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(commentListAction:)];
    }
    return _commentListItem;
}

- (void)commentListAction:(id)sender {
    MLCommentListViewController *controller = [MLCommentListViewController controllerFromXib];
    controller.userId = self.userId;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)loadFollowListData {
    if(!self.userId)
        return;
    
    [MBProgressHUD showInView:self.view];
    
    __weak typeof (self) weakSelf = self;
    
    [HXSCommunityModel getCommunityUserFollowListWithUserId:self.userId complete:^(HXSErrorCode code, NSString *message, NSArray<HXSUserBasicInfo *> *users) {
                                                 
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        
        if (code == kHXSNoError) {
            [weakSelf.followList removeAllObjects];
            
            [weakSelf.followList addObjectsFromArray:users];
        } else {
            
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.tableView status:message afterDelay:3];
        }
        
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.followList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLFollowListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MLFollowListTableViewCell class])
                                                                  forIndexPath:indexPath];
    HXSUserBasicInfo *userInfo = self.followList[indexPath.row];

    [cell setUserInfo:userInfo];
    
    __weak typeof(self) weakSelf = self;

    [cell setLoadPostUserCenter:^{
        [weakSelf loadPostUserCenterViewController:userInfo];
    }];
    
    [cell setFollowUserBlock:^(BOOL follow){
        if(weakSelf.userId.intValue == [HXSUserAccount currentAccount].userID.intValue) {
            [weakSelf followTheUser:userInfo follow:follow];
        }
    }];
//
//    //回复
//    [cell setReplyActionBlock:^{
//        [weakSelf loadToCommunityDetailViewController:postEntity isReplyRightNow:NO];
//    }];
//    
//    //点赞
//    [cell setPraiseActionBlock:^{
//        [weakSelf praiseTheCommunity:postEntity];
//    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 64;
}

/**
 *  跳转发帖人中心
 */
- (void)loadPostUserCenterViewController:(HXSUserBasicInfo *)userInfo{
    HXSCommunityMyCenterViewController *communityOthersCenterViewController = [HXSCommunityMyCenterViewController controllerFromXib];
    communityOthersCenterViewController.userIdNum = userInfo.userId;
    
    [self.navigationController pushViewController:communityOthersCenterViewController animated:YES];
}

/**
 *  关注
 */
- (void)followTheUser:(HXSUserBasicInfo *)userInfo follow:(BOOL)follow{
    if ([HXSUserAccount currentAccount].isLogin){
        
        __weak typeof(self) weakSelf = self;
        
        if(!follow) {
            [HXSCommunityTagModel communityUnFollowUserWithUserId:userInfo.userId.stringValue complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic)
             {
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:2.0];
             }];
        }else {
            [HXSCommunityTagModel communityFollowUserWithUserId:userInfo.userId.stringValue complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic)
             {
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:2.0];
             }];
        }
    }
}


@end
