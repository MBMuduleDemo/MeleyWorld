//
//  MLFriendsViewController.m
//  meyley
//
//  Created by chsasaw on 2017/2/19.
//  Copyright © 2017年 Meyley. All rights reserved.
//  好友

#import "MLFriendsViewController.h"
#import "HXSAccountManager.h"
#import "HXSUserInfo.h"
#import "MLWaiterModel.h"
#import "MLServiceCenterViewController.h"

//通知消息
#import "LGMessageTableViewCell.h"

@interface MLFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
//通知信息
@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic, weak) IBOutlet UIView *serviceView;

@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@end

static NSString *const messageCell = @"messageCell";

@implementation MLFriendsViewController

+ (NSString *)storyboardName {
    return @"Friends";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = NO;
    
    self.navigationItem.title = @"信息";
    self.navigationItem.leftBarButtonItem = nil;
    
    [self.view addSubview:self.tableView];
    
    self.addButton.hidden = YES;
    self.serviceView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showWaiterView)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [self.serviceView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myWaiterUpdated) name:kMywaiterUpated object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[HXSUserAccount currentAccount].userInfo updateMyWaiter];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)myWaiterUpdated {
    MLWaiterModel *myWaiter = [HXSUserAccount currentAccount].userInfo.myWaiter;
    if(myWaiter && myWaiter.waiterName.length > 0) {
        self.serviceView.hidden = NO;
        self.addButton.hidden = YES;
        
        self.nameLabel.text = myWaiter.waiterName;
        
        [self.headImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.headImageView.layer setCornerRadius:self.headImageView.frame.size.width*0.5];
        self.headImageView.layer.masksToBounds = YES;
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:myWaiter.headPic] placeholderImage:[UIImage imageNamed:@"dsfdl-tx"]];
    }else {
        self.serviceView.hidden = YES;
        self.addButton.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showWaiterView {
    MLServiceCenterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MLServiceCenterViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)addWaiter:(id)sender {
    [self showWaiterView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCell forIndexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {

//        //1.更新数据
//        [self.dataArray removeObjectAtIndex:indexPath.row];
//        //2.更新UI
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }];
    
    UITableViewRowAction *cancelAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:@"取消" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //取消
    }];
    cancelAction.backgroundColor = ML_DISABLE_COLOR;
    
    return @[deleteAction,cancelAction];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
}

#pragma mark--lazy---
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight-64-tabBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        if (kAPIVersion11Later) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [_tableView registerClass:[LGMessageTableViewCell class] forCellReuseIdentifier:messageCell];
        
    }
    return _tableView;
}

@end
