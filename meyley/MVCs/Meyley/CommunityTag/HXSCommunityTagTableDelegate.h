//
//  HXSCommunityTagViewController.h
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  帖子列表代理
 */

@class HXSPost;

@interface HXSCommunityTagTableDelegate : NSObject<UITableViewDataSource,
                                                    UITableViewDelegate,
                                                    UIScrollViewDelegate>

/** 用户id */
@property (nonatomic, strong) NSNumber *userId;

/**
 *  服务器获取帖子列表
 */
-(void)loadDataFromServerWithUserId:(NSNumber *)userId;

/**
 *  初始化，tableview
 */
- (void)initWithTableView:(UITableView *)tableView superViewController:(UIViewController *)superViewController;

/**
 *  加载数据的方法
 */
- (void)initData:(NSArray<HXSPost *>*)posts;
- (void)loadMore;
- (BOOL)hasMore;
- (void)reload;

@end
