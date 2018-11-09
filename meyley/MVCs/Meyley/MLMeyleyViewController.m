//
//  MLMeyleyViewController.m
//  meyley
//
//  Created by chsasaw on 2017/2/19.
//  Copyright © 2017年 Meyley. All rights reserved.
//  魅力圈

#import "MLMeyleyViewController.h"
#import "SVPullToRefresh.h"

// Controllers
#import "HXSCommunityTagTableDelegate.h"
#import "HXSLoginViewController.h"
#import "HXSCommunityPostingViewController.h"

// Views
#import "HXSCommunityHeadCell.h"
#import "HXSCommunityContentTextCell.h"
#import "HXSCommunityFootrCell.h"
#import "HXSCommunityImageCell.h"
#import "HXSShareView.h"

// Model
#import "HXSCommunityModel.h"
#import "HXSPost.h"
#import "HXSNoDataView.h"
#import "HXSCommunityTagModel.h"
#import "HXSUserBasicInfo.h"
#import "HXSUserInfo.h"

#import "WKWebViewController.h"
#import "HKBaseNavigationController.h"

@interface MLMeyleyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, assign) CGFloat                      lastOffSet;
@property (nonatomic, strong) HXSShareView                 *shareView;
@property (nonatomic, strong) HXSCommunityTagTableDelegate *delegate;

@end

@implementation MLMeyleyViewController


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = NO;
    
    self.navigationItem.title = @"魅力圈";
    
    [self initTableview];
        
    [self loadDataFromServerWithUserId:[HXSUserAccount currentAccount].userID];
    
    [self.delegate initData:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kMLPOSTADDED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kMLPOSTSTATUSCHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kMLCOMMENTADDED object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Target Methods

- (void)loadDataFromServerWithUserId:(NSNumber *)userId{
    [self.delegate loadDataFromServerWithUserId:userId];
}

#pragma mark - Intial Methods

- (void)initTableview{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.scrollsToTop = YES;
    [self.delegate initWithTableView:self.tableView superViewController:self];
    
    [self.tableView addPullToRefresh:[SVArrowPullToRefreshView class] withActionHandler:^{
        [self.delegate reload];
    }];
}

- (void)refresh {
    [self.delegate reload];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.delegate numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.delegate tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}


#pragma mark - Get Set Methods

- (HXSCommunityTagTableDelegate *)delegate
{
    if(!_delegate) {
        _delegate = [[HXSCommunityTagTableDelegate alloc] init];
    }
    
    return _delegate;
}

- (IBAction)onClickCamera:(id)sender {
    if ([HXSUserAccount currentAccount].isLogin) {
        HXSCommunityPostingViewController *communityPostingViewController = [[HXSCommunityPostingViewController alloc] initWithNibName:NSStringFromClass([HXSCommunityPostingViewController class]) bundle:nil];
        if([self.navigationController.topViewController isKindOfClass:[HXSCommunityPostingViewController class]]) {
            return;
        }
        [self.navigationController pushViewController:communityPostingViewController animated:YES];
    } else {
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            HXSCommunityPostingViewController *communityPostingViewController = [[HXSCommunityPostingViewController alloc] initWithNibName:NSStringFromClass([HXSCommunityPostingViewController class]) bundle:nil];
            [self.navigationController pushViewController:communityPostingViewController animated:YES];
        }];
    }
}

@end

