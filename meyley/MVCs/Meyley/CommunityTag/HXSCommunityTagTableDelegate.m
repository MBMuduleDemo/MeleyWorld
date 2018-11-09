//
//  HXSCommunityTagViewController.m
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

// Controllers
#import "HXSCommunityTagTableDelegate.h"
#import "HXSCommunityDetailViewController.h"
#import "HXSCommunityMyCenterViewController.h"
#import "HXSCommunityPhotosBrowserViewController.h"
#import "HXSLoginViewController.h"

// Views
#import "HXSCommunityHeadCell.h"
#import "HXSCommunityContentTextCell.h"
#import "HXSCommunityFootrCell.h"
#import "HXSCommunityImageCell.h"
#import "HXSShareView.h"
#import "HXSCommunityH5Cell.h"
#import "HXSNoDataView.h"
#import "MLCommunityCommentCell.h"

// Model
#import "HXSCommunityModel.h"
#import "HXSPost.h"
#import "HXSCommunityTagModel.h"

#import "WKWebViewController.h"

#define CommunityHeadCell               @"HXSCommunityHeadCell"
#define CommunityContentTextCell        @"HXSCommunityContentTextCell"
#define CommunityFootrCell              @"HXSCommunityFootrCell"
#define CommunityImageCell              @"HXSCommunityImageCell"
#define CommunityCommentCell            @"MLCommunityCommentCell"
#define CommunityH5Cell                 @"HXSCommunityH5Cell"


#define ShareDefultImageURL             @"http://community-59store.img-cn-hangzhou.aliyuncs.com/e5ff26c9250d4274be5c79a3bc370252.png"

typedef NS_ENUM(NSInteger, CommunityBody)
{
    CommunityBody_Head          = 0,
    CommunityBody_Content_Img   = 1,
    CommunityBody_Content_Text  = 2,
    CommunityBody_Content_Comment = 3,
    CommunityBody_Foot          = 4,
    CommunityBody_Count
};

static const NSInteger SINGLE_ROW_NUMS = CommunityBody_Count;// rows nums

@interface HXSCommunityTagTableDelegate ()<UITableViewDataSource,
                                           UITableViewDelegate,
                                           HXSCommunityContentTextCellDelegate,
                                           UIScrollViewDelegate,
                                           HXSCommunityPhotosBrowserViewControllerDelegate>

@property (nonatomic, weak) UIViewController * superViewContrller;
@property (nonatomic, weak) UITableView  *tableView;

@property (nonatomic, assign) CGFloat        lastOffSet;
@property (nonatomic, strong) HXSShareView   *shareView;
/** 第几页  从1开始 */
@property (nonatomic, assign) NSInteger      indexPage;
/** 帖子数量 */
@property (nonatomic, strong) NSMutableArray *postsArray;
@property (nonatomic, assign) BOOL           hasMore;
@property (nonatomic, assign) BOOL           isLoading;

@end

@implementation HXSCommunityTagTableDelegate


#pragma mark -

- (void)loadDataFromServerWithUserId:(NSNumber *)userId
{
    _userId = userId;
    _hasMore = YES;
    _isLoading = NO;
}

- (void)initData:(NSArray<HXSPost *>*)posts
{
    if(!posts) {
        if(self.indexPage == 0) {
            [MBProgressHUD showInView:self.superViewContrller.view];
            
            self.indexPage = 1;
            [self getPostListFromServer];
        }
    }else {
        [self.tableView.infiniteScrollingView stopAnimating];
        
        [self.tableView.pullToRefreshView stopAnimating];
        
        self.hasMore = NO;
        
        [self.postsArray removeAllObjects];
        
        [self.postsArray addObjectsFromArray:posts];
        
        self.indexPage = 1;
    }
}

- (void)loadMore
{
    if(self.hasMore) {
        [self getPostListFromServer];
    } else {
        [self.tableView.infiniteScrollingView stopAnimating];
        [MBProgressHUD hideHUDForView:self.superViewContrller.view animated:YES];
    }
}

- (BOOL) hasMore
{
    return _hasMore;
}

- (void)reload
{
    self.indexPage = 1;
    
    [self getPostListFromServer];
}


/**
 *  从服务器获取列表
 */
- (void)getPostListFromServer
{
    if(_isLoading) {
       return;
    }
    
    _isLoading = YES;
    
    __weak typeof(self) weakSelf = self;
    [HXSCommunityModel getCommunityPostListWithUserId:self.userId
                                               page:@(self.indexPage)
                                           complete:^(HXSErrorCode code, NSString *message, NSArray *posts, NSString *shareLinkStr) {
                                               
                                               [MBProgressHUD hideHUDForView:weakSelf.superViewContrller.view animated:YES];
                                               
                                               [weakSelf.tableView.infiniteScrollingView stopAnimating];
                                               
                                               [weakSelf.tableView.pullToRefreshView stopAnimating];

                                               if (code == kHXSNoError) {
                                                   
                                                   if (posts.count > 0) {
                                                       
                                                       if(weakSelf.indexPage == 1) {
                                                           [weakSelf.postsArray removeAllObjects];
                                                       }
                                                       
                                                       [weakSelf.postsArray addObjectsFromArray:posts];
                                                       weakSelf.indexPage ++;
                                                   }
                                                   
                                                   weakSelf.hasMore = posts.count >= 5;
                                               } else {
                                                   weakSelf.hasMore = NO;
                                                   
                                                   [MBProgressHUD showInViewWithoutIndicator:weakSelf.tableView status:message afterDelay:3];
                                               }
                                               
                                               weakSelf.isLoading = NO;
                                               [weakSelf.tableView reloadData];
                                           }];

}


#pragma mark  - init Methods

- (void)initWithTableView:(UITableView *)tableView superViewController:(UIViewController *)superViewController
{
    self.superViewContrller = superViewController;
    self.tableView = tableView;
    
    [self.tableView registerNib:[UINib nibWithNibName:CommunityHeadCell bundle:nil]
          forCellReuseIdentifier:CommunityHeadCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:CommunityContentTextCell bundle:nil]
          forCellReuseIdentifier:CommunityContentTextCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:CommunityH5Cell bundle:nil]
         forCellReuseIdentifier:CommunityH5Cell];
    
    [self.tableView registerNib:[UINib nibWithNibName:CommunityFootrCell bundle:nil]
          forCellReuseIdentifier:CommunityFootrCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:CommunityImageCell bundle:nil]
          forCellReuseIdentifier:CommunityImageCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:CommunityCommentCell bundle:nil] forCellReuseIdentifier:CommunityCommentCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSNoDataView class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSNoDataView class])];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    [self.tableView setTableFooterView:[UIView new]];
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.postsArray.count > 0 ? [self.postsArray count] * SINGLE_ROW_NUMS : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.postsArray.count == 0) {
        HXSNoDataView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSNoDataView class])
                                                                     forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    __weak typeof(self) weakSelf = self;
    
    NSInteger row = indexPath.row;
    
    HXSPost *postEntity = self.postsArray[row / SINGLE_ROW_NUMS];
    
    if (row % SINGLE_ROW_NUMS == CommunityBody_Head) {
        
        HXSCommunityHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:CommunityHeadCell
                                                                     forIndexPath:indexPath];
        cell.postEntity = postEntity;
        
        [cell setLoadPostUserCenter:^{
            
            [weakSelf loadPostUserCenterViewController:postEntity];
        }];
        
        [cell setFollowUserBlock:^{
            
            [weakSelf followTheUser:postEntity];
        }];
        
        [cell setDropdownBlock:^{
            
            [weakSelf deleteTheContentWithEntity:postEntity];
        }];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
        
    } else if (row % SINGLE_ROW_NUMS == CommunityBody_Content_Text) {
        
        if (postEntity.type.intValue == 2) {
            //图文混排
            HXSCommunityH5Cell *cell = [tableView dequeueReusableCellWithIdentifier:CommunityH5Cell forIndexPath:indexPath];
            [cell setCellContentWithImageUrlStr:postEntity.articleCover titleText:postEntity.articleTitle contentText:postEntity.articleContent];
            
            [cell setLoadCommunityH5detail:^{
//                [weakSelf loadToCommunityDetailViewController:postEntity isReplyRightNow:NO];
            }];
            
            return cell;
        }
        
        HXSCommunityContentTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CommunityContentTextCell
                                                                        forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.postEntity = postEntity;
      
        cell.delegate = self;
        
        return cell;
        
    } else if (row % SINGLE_ROW_NUMS == CommunityBody_Content_Img) {
        
        HXSCommunityImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CommunityImageCell
                                                                      forIndexPath:indexPath];
       
        cell.postEntity = postEntity;
        
        [cell setShowImages:^(NSMutableArray<HXSCommunitUploadImageEntity *> *uploadImageEntitys, NSInteger index,UIImageView *imageView) {
            if (index == -1) {
                return ;
            }
            [weakSelf showCommunityImagesWith:uploadImageEntitys
                                     andIndex:index
                              andTapImageView:imageView
                                andPostEntity:postEntity];
        }];
        return cell;

    } else if (row % SINGLE_ROW_NUMS == CommunityBody_Content_Comment) {
        MLCommunityCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CommunityCommentCell];
        [cell setComments:postEntity.commentList];
        
        return cell;
    }else {
        HXSCommunityFootrCell *cell = [tableView dequeueReusableCellWithIdentifier:CommunityFootrCell
                                                                      forIndexPath:indexPath];

        cell.postEntity = postEntity;
        
        [cell setLikeActionBlock:^{
          //收藏
            [weakSelf likeTheCommunity:postEntity];
        }];
        
        //回复
        [cell setReplyActionBlock:^{
            [weakSelf loadToCommunityDetailViewController:postEntity isReplyRightNow:NO];
        }];

        //点赞
        [cell setPraiseActionBlock:^{
            [weakSelf praiseTheCommunity:postEntity];
        }];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(self.postsArray.count <=  indexPath.row / SINGLE_ROW_NUMS) {
        return;
    }
    HXSPost *postEntity = self.postsArray[indexPath.row / SINGLE_ROW_NUMS];
    [self loadToCommunityDetailViewController:postEntity isReplyRightNow:NO];
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(self.postsArray.count <= 0) {
        return self.tableView.frame.size.height;
    }
    
    NSInteger row = indexPath.row;
    
    HXSPost *postEntity = self.postsArray[row / SINGLE_ROW_NUMS];
    
    if (row % SINGLE_ROW_NUMS == CommunityBody_Head) {
        return 70;
    } else if(row % SINGLE_ROW_NUMS == CommunityBody_Content_Text) {

        if (postEntity.type.intValue == 2) {
            return (SCREEN_WIDTH - 32)/343*180 + 40;
        }
        NSString *contentText = postEntity.content;
        
        CGFloat height = [HXSCommunityContentTextCell getCellHeightWithText:contentText lines:2];
        
        if(height > 14 * 6) {
        
            return 14 * 6;
        }
        return height;
    
    } else if(row % SINGLE_ROW_NUMS == CommunityBody_Content_Img) {
        
        CGFloat height = 0;
        
        if ([postEntity.dynamicsImgList count] > 3) {
            
            height = [HXSCommunityImageCell getCellHeightWithImagesCount:3];
        } else {
            
            height = [HXSCommunityImageCell getCellHeightWithImagesCount:[postEntity.dynamicsImgList count]];
        }
        
        return height;

    } else if(row % SINGLE_ROW_NUMS == CommunityBody_Content_Comment) {
        if (postEntity.commentList.count > 0) {
            return [MLCommunityCommentCell getCellHeight:postEntity.commentList];
        }else {
            return 0;
        }
    } else {
    
        return 45;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row / SINGLE_ROW_NUMS == self.postsArray.count - 1) {
        [self loadMore];
    }
}


#pragma mark - Target Action

/**
 *  进入帖子详情页面
 *
 */
-(void)loadToCommunityDetailViewController:(id)model isReplyRightNow:(BOOL)isReply
{
    if (!isReply) {
        HXSPost *postModel = (HXSPost *)model;
        if (postModel.articleUrl.length > 0) {
            //H5
            NSURL *url = [NSURL URLWithString:postModel.articleUrl];
            WKWebViewController *viewController = [[WKWebViewController alloc] init];
            [viewController loadUrl:url];
            if([viewController isKindOfClass:[UIViewController class]]) {
                [self.superViewContrller.navigationController pushViewController:viewController animated:YES];
            }
        } else {
            HXSCommunityDetailViewController *communityDetailViewController = [HXSCommunityDetailViewController createCommunityDetialVCWithPostID:postModel.dynamicsId replyLoad:isReply pop:nil];
            
            [self.superViewContrller.navigationController pushViewController:communityDetailViewController animated:YES];
        }
    } else {
        if ([HXSUserAccount currentAccount].isLogin){
            HXSCommunityDetailViewController *communityDetailViewController = [HXSCommunityDetailViewController createCommunityDetialVCWithPostID:((HXSPost *)model).dynamicsId replyLoad:isReply pop:nil];
            
            [self.superViewContrller.navigationController pushViewController:communityDetailViewController animated:YES];
            
        } else {
            __weak typeof(self) weakSelf = self;
            
            [HXSLoginViewController showLoginController:self.superViewContrller loginCompletion:^{
                HXSCommunityDetailViewController *communityDetailViewController = [HXSCommunityDetailViewController createCommunityDetialVCWithPostID:((HXSPost *)model).dynamicsId replyLoad:isReply pop:nil];
                
                [weakSelf.superViewContrller.navigationController pushViewController:communityDetailViewController animated:YES];
                
            }];
        }

    }
}

/**
 *  跳转发帖人中心
 */
- (void)loadPostUserCenterViewController:(HXSPost *)postEntity
{
    HXSCommunityMyCenterViewController *communityOthersCenterViewController = [HXSCommunityMyCenterViewController controllerFromXib];
    communityOthersCenterViewController.userIdNum = postEntity.ownerUserId;
    
    [self.superViewContrller.navigationController pushViewController:communityOthersCenterViewController animated:YES];
    
}

/**
 *  关注
 */
- (void)followTheUser:(HXSPost *)post
{
    __block NSInteger index = [self.postsArray indexOfObject:post];
    if ([HXSUserAccount currentAccount].isLogin){
        
        __weak typeof(self) weakSelf = self;
        
        if(!post.isFollow.boolValue) {
            [HXSCommunityTagModel communityFollowUserWithUserId:post.ownerUserId.stringValue complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic)
             {
             if (code == kHXSNoError) {
                 
                 post.isFollow = @(1);
                 
                 [weakSelf.postsArray replaceObjectAtIndex:index withObject:post];
                 
                 [weakSelf.tableView reloadData];
             }
             
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.superViewContrller.view status:message afterDelay:2.0];
             }];
        }else {
            [HXSCommunityTagModel communityUnFollowUserWithUserId:post.ownerUserId.stringValue complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic)
             {
             if (code == kHXSNoError) {
                 
                 post.isFollow = @(0);
                 
                 [weakSelf.postsArray replaceObjectAtIndex:index withObject:post];
                 
                 [weakSelf.tableView reloadData];
             }
             
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.superViewContrller.view status:message afterDelay:2.0];
             }];
        }
        
    } else {
        
        [HXSLoginViewController showLoginController:self.superViewContrller loginCompletion:^{
            
        }];
    }
}

/**
 *  点赞
 */
- (void)praiseTheCommunity:(HXSPost *)post
{
    __block NSInteger index = [self.postsArray indexOfObject:post];
    __block int praiseCount = post.praiseCount.intValue;
    if ([HXSUserAccount currentAccount].isLogin){
        
        __weak typeof(self) weakSelf = self;
        
        if(post.isPraise.boolValue) {
            [HXSCommunityTagModel communityCancelPraiseWithPostId:post.dynamicsId complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic)
             {
             if (code == kHXSNoError) {
                 
                 praiseCount --;
                 
                 post.isPraise = @(0);
                 
                 post.praiseCount = @(praiseCount);
                 
                 [weakSelf.postsArray replaceObjectAtIndex:index withObject:post];
                 
                 [weakSelf.tableView reloadData];
             }
             }];
        }else {
            [HXSCommunityTagModel communityPraiseWithPostId:post.dynamicsId complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic)
             {
             if (code == kHXSNoError) {
                 
                 praiseCount ++;
                 
                 post.isPraise = @(1);
                 
                 post.praiseCount = @(praiseCount);
                 
                 [weakSelf.postsArray replaceObjectAtIndex:index withObject:post];
                 
                 [weakSelf.tableView reloadData];
             }
             }];
        }
        
    } else {
        
        [HXSLoginViewController showLoginController:self.superViewContrller loginCompletion:^{
            
        }];
    }
}

/**
 *  收藏
 */
- (void)likeTheCommunity:(HXSPost *)post
{
    __block NSInteger index = [self.postsArray indexOfObject:post];
    if ([HXSUserAccount currentAccount].isLogin){
        
        __weak typeof(self) weakSelf = self;
        if(post.isCollect.boolValue) {
            [HXSCommunityTagModel communityCancelLikeWithPostId:post.dynamicsId complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic)
             {
             if (code == kHXSNoError) {
                 
                 post.isCollect = @(0);
                 
                 [weakSelf.postsArray replaceObjectAtIndex:index withObject:post];
                 
                 [weakSelf.tableView reloadData];
             }
             }];
        }else {
            [HXSCommunityTagModel communityAddLikeWithPostId:post.dynamicsId complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic)
             {
             if (code == kHXSNoError) {
                 
                 post.isCollect = @(1);
                 
                 [weakSelf.postsArray replaceObjectAtIndex:index withObject:post];
                 
                 [weakSelf.tableView reloadData];
             }
             }];
        }
        
    } else {
        
        [HXSLoginViewController showLoginController:self.superViewContrller loginCompletion:^{

        }];
    }
}

/**
 *  删除帖子
 *
 *  @param entity 帖子
 */
- (void)confirmDelete:(HXSPost *)entity
{
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"确定删除这条状态吗?"
                                                                      message:nil
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"确定"];
    __weak __typeof(self) weakSelf = self;
    alertView.rightBtnBlock = ^{
        [weakSelf deleteTheMyPostNetworkingWithPostEntity:entity];
    };
    
    [alertView show];
}

/**
 *  删除帖子网络操作
 *
 */
- (void)deleteTheMyPostNetworkingWithPostEntity:(HXSPost *)postEntity
{
    WS(weakSelf);
    
    [MBProgressHUD showInView:_superViewContrller.view];
    [HXSCommunityModel communityDeletePostWithPostId:postEntity.dynamicsId
                                            complete:^(HXSErrorCode code, NSString *message, NSNumber *result_status)
     {
         [MBProgressHUD hideHUDForView:weakSelf.superViewContrller.view animated:NO];
         if(code == kHXSNoError && result_status) {
             [weakSelf deleteTheSelectCellWithEntity:postEntity];
         } else {
             if (weakSelf.superViewContrller.view)
                 [MBProgressHUD showInViewWithoutIndicator:weakSelf.superViewContrller.view status:message afterDelay:1.5];
         }
     }];
}

/**
 *  删除指定cell
 *
 */
- (void)deleteTheSelectCellWithEntity:(HXSPost *)entity
{
    [self.postsArray removeObject:entity];
    [self.tableView reloadData];
}

/**
 *  显示图片
 *
 */
- (void)showCommunityImagesWith:(NSMutableArray<HXSCommunitUploadImageEntity *> *)uploadImageEntitys
                       andIndex:(NSInteger)index
                andTapImageView:(UIImageView *)tapImageView
                  andPostEntity:(HXSPost *)postEntity
{
    HXSCommunityPhotosBrowserViewController *communityPhotosBrowserViewController = [HXSCommunityPhotosBrowserViewController controllerFromXibWithModuleName:@"PhotosBrowse"];
    [communityPhotosBrowserViewController setTheOriginImageView:tapImageView];    
    [communityPhotosBrowserViewController initCommunityPhotosBrowserWithImageParamArray:uploadImageEntitys
                                                                               andIndex:index
                                                                                andType:kCommunitPhotoBrowserTypeViewImage];
    [communityPhotosBrowserViewController setThePostEntity:postEntity];
    communityPhotosBrowserViewController.delegate = self;
    
    [self.superViewContrller.tabBarController addChildViewController:communityPhotosBrowserViewController];
    [self.superViewContrller.tabBarController.view addSubview:communityPhotosBrowserViewController.view];
    [communityPhotosBrowserViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superViewContrller.tabBarController.view);
    }];
    [communityPhotosBrowserViewController didMoveToParentViewController:self.superViewContrller.tabBarController];
}


/**
 *  刷新某条cell
 *
 */
- (void)refreshTheSelectCellWithEntity:(HXSPost *)entity
{
    NSInteger section = [_postsArray indexOfObject:entity];
    
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:section];
    
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (void)copyTheContentWithEntity:(HXSPost *)postEntity
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = postEntity.content;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_done"]];
    [MBProgressHUD showInView:_superViewContrller.view
                   customView:imageView
                       status:@"复制成功"
                   afterDelay:0.5];
}

- (void)deleteTheContentWithEntity:(HXSPost *)postEntity
{
    [self confirmDelete:postEntity];
}

#pragma mark - Get Set Methods

- (NSMutableArray *)postsArray
{
    if (!_postsArray) {
        _postsArray = [[NSMutableArray alloc] init];
    }
    
    return _postsArray;
}


@end
