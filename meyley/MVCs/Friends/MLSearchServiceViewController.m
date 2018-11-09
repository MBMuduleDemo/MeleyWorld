//
//  MLSearchServiceViewController.m
//  meyley
//
//  Created by chsasaw on 2017/5/7.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLSearchServiceViewController.h"
#import "MLWaiterModel.h"
#import "MLWaiterTableViewCell.h"
#import "MLServiceRequestModel.h"
#import "MLRecommendWaiterView.h"

#import "HXSCommunityMyCenterViewController.h"

@interface MLSearchServiceViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<MLWaiterModel *> *waiters;

@end

@implementation MLSearchServiceViewController

+ (NSString *)storyboardName {
    return @"Friends";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.returnKeyType = UIReturnKeySearch;
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.tintColor = ML_ACCENT_COLOR;
    self.searchBar.placeholder = @"请输入客服名称或者手机号";
    self.searchBar.delegate = self;
    
    self.tableView.rowHeight = 64;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorColor = ML_SEPERATOR_COLOR;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MLWaiterTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MLWaiterTableViewCell class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [MBProgressHUD showInView:self.view];
    [MLServiceRequestModel getWaiterListWithKeyword:searchBar.text complete:^(HXSErrorCode code, NSString *message, NSArray<MLWaiterModel *> *waiters) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if(code == kHXSNoError) {
            [self.waiters removeAllObjects];
            [self.waiters addObjectsFromArray:waiters];
            [self.tableView reloadData];
            if(self.waiters.count == 0) {
                MLRecommendWaiterView *waiterView = [MLRecommendWaiterView waiterView];
                self.tableView.tableFooterView = waiterView;
                [waiterView setDescText:@"该客服不存在"];
                [waiterView showInViewController:self];
            }else {
                self.tableView.tableFooterView = [[UIView alloc] init];
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
