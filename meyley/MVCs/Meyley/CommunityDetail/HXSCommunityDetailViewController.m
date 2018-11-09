//
//  HXSCommunityDetailViewController.m
//  store
//
//  Created by  黎明 on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

// Controllers
#import "HXSCommunityDetailViewController.h"
#import "HXSCommunityPhotosBrowserViewController.h"
#import "HXSCommunityMyCenterViewController.h"
#import "HXSLoginViewController.h"
#import "HXSLoginViewController.h"
#import "WKWebViewController.h"

// Views
#import "HXSCommunittyItemReplyItemTitleTableViewCell.h"
#import "HXSShareView.h"
#import "HXSCommunityHeadCell.h"
#import "HXSCommunityContentTextCell.h"
#import "HXSCommunityImageCell.h"
#import "MLCommunityH5DetailCell.h"
#import "HXSCommunityContentFooterTableViewCell.h"
#import "HXSKeyBoardBarView.h"
#import "HXSNoCommentView.h"
#import "HXSActionSheet.h"
#import <MBProgressHUD.h>

// Model
#import "HXSCommunityTagModel.h"
#import "HXSCommunityModel.h"
#import "HXSCommunityMyReplyModel.H"

typedef NS_ENUM(NSInteger, CommunittyItem)
{
    CommunittyItem_head = 0,                // 帖子标题【发帖人头像，名称，学校】
    CommunittyItem_contentImg,              // 帖子内容 图片
    CommunittyItem_contentText,             // 帖子内容 文字
    CommunittyItem_replyItemTitle,          // 回复人的标题【名称，时间，头像，回复按钮[或删除按钮]】
    CommunittyItem_replyitemContent         // 回复内容
};

typedef NS_ENUM(NSInteger, CommunityDetailSection)
{
    CommunityDetailSection_Content = 0,// 帖子内容部分
    CommunityDetailSection_Reply,             // 帖子评论部分
};


static NSString * const kCommunittyItemLikeTableviewCell          = @"HXSCommunittyItemLikeTableViewCell";
static NSString * const kCommunityHeadCell                        = @"HXSCommunityHeadCell";
static NSString * const kCommunityContenttextCell                 = @"HXSCommunityContentTextCell";
static NSString * const kCommunityH5DetailCell                    = @"MLCommunityH5DetailCell";
static NSString * const kCommunityContentfootertableviewCell      = @"HXSCommunityContentFooterTableViewCell";
static NSString * const kCommunityImageCell                       = @"HXSCommunityImageCell";
static NSString * const kCommunityItemReplyItemTitleTableviewCell = @"HXSCommunittyItemReplyItemTitleTableViewCell";
static NSString * const kSharedefultImageurl                      = @"http://community-59store.img-cn-hangzhou.aliyuncs.com/e5ff26c9250d4274be5c79a3bc370252.png";

static CGFloat const TextSingLineHeight                = 18; // 回复内容单行高度
static CGFloat const ReplyItemTitleTableViewCellHeight = 104;// 默认回复cell高度
static CGFloat const NormalSectionFooterHeight         = 40; // sectionfooter 高度
static CGFloat const NoReplySectionFooterHeight        = 400;// 没有评论的时候 sectionfooter 高度

@interface HXSCommunityDetailViewController ()<HXSCommunityPhotosBrowserViewControllerDelegate,
                                                HXSCommunittyItemReplyItemTitleTableViewCellDelegate,
                                                HXSCommunityContentTextCellDelegate>

@property (nonatomic, weak  ) IBOutlet UITableView          *mTableView;
/** 分享界面 */
@property (nonatomic, strong) HXSShareView                  *shareView;
@property (nonatomic, strong) HXSKeyBoardBarView            *keyBoardBarView;

@property (nonatomic, strong) NSString                      *postIdStr;
/** 评论数组 */
@property (nonatomic, strong) NSMutableArray                *commentArray;

@property (nonatomic, strong)  NSLayoutConstraint           *attributeBottom;
@property (nonatomic, strong) NSString                      *mainContentStr;

@property (nonatomic, strong) NSNumber                      *pageNum;
@property (nonatomic, strong) NSNumber                      *commnetedUidNum;
@property (nonatomic, strong) NSString                      *commentedContentStr;
/** 评论数量 */
@property (nonatomic, strong) NSNumber                      *commneteCountNum;
/** 右上角提交按钮 */
@property (nonatomic ,strong) UIBarButtonItem               *postBarButton;
@property (nonatomic, strong) HXSActionSheet                *actionSheet;


/**  是否为点击回复进入  如果是  则自动弹起键盘 */
@property (nonatomic, assign) BOOL isReplyLoad;
/** 帖子id */
@property (nonatomic, strong) HXSPost *postEntity;
/** 设置返回页面 */
@property (nonatomic, copy) void (^popToLastViewController)();

@end

@implementation HXSCommunityDetailViewController


+ (instancetype)createCommunityDetialVCWithPostID:(NSString *)postIDStr
                                        replyLoad:(BOOL)isReplyLoad
                                              pop:(void (^)(void))popToLastViewController
{
    HXSCommunityDetailViewController *communityDetailViewController = [HXSCommunityDetailViewController controllerFromXib];
    
    communityDetailViewController.postIdStr = postIDStr;
    communityDetailViewController.isReplyLoad = isReplyLoad;
    communityDetailViewController.popToLastViewController = popToLastViewController;
    
    
    if (0 != [communityDetailViewController.commentArray count]) {
        [communityDetailViewController.commentArray removeAllObjects];
    }
    
    return communityDetailViewController;
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTheNavigationBar];
    
    [self setupkeyBoardView];
    
    [self tableViewRegisterNib];

    [self addKeyBoardNotificationObserver];
    
    [self loadConmunityDetail];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadConmunityDetail) name:kMLPOSTSTATUSCHANGED object:nil];
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setCommentTheCommunityWithPlaceHodlerString:@"说点什么吧"];

    if (self.isReplyLoad) {
        [self.keyBoardBarView.inputTextView becomeFirstResponder];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.keyBoardBarView = nil;
}


#pragma mark - Intial Methods

- (void)initTheNavigationBar
{
    self.navigationItem.title = @"帖子详情";
    
    [self.navigationItem setRightBarButtonItem:self.postBarButton];
    
    [self.navigationItem.leftBarButtonItem setAction:@selector(popToLastViewControll)];
}

/**
 *  添加键盘通知
 */
- (void)addKeyBoardNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

//返回按钮点击事件
- (void)popToLastViewControll
{
    if (self.popToLastViewController) {
        self.popToLastViewController();
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
*  键盘消失事件
*/
- (void)keyBoardDidHidden:(NSNotification *)notification
{
    [self.view endEditing:YES];
    self.attributeBottom.constant = 0;
}

/**
 *  回复框回去焦点
 */
- (void)keyBoardDidShow:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    
    CGRect keyBoardFrame = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    self.attributeBottom.constant = -keyBoardFrame.size.height;
    
    if (![HXSUserAccount currentAccount].isLogin) {
        self.isReplyLoad = NO;
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            
        }];
    }
}

/**
 *  提交帖子回复内容到服务器
 *
 */
- (void)commitCommentPostToserver:(NSString *)commentContent
{
    [self.view endEditing:YES];
    
    if (commentContent.length > 120) {
        commentContent = [commentContent substringToIndex:120];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [HXSCommunityTagModel communityAddCommentWithPostId:self.postEntity.dynamicsId content:commentContent complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
        if (code == kHXSNoError) {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:2];
            
            [weakSelf.keyBoardBarView resetInuptTextView];

//            HXSComment *commentEntity = [HXSComment objectFromJSONObject:dic[@"comment"]];
//            [weakSelf.commentArray insertObject:commentEntity atIndex:0];
//            [weakSelf.mTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationBottom];
            
            weakSelf.commneteCountNum=@(weakSelf.commneteCountNum.intValue + 1);
            [weakSelf loadConmunityDetail];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kMLCOMMENTADDED object:nil];
        } else {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提醒"
                                                                              message:message
                                                                      leftButtonTitle:nil
                                                                    rightButtonTitles:@"确定"];
            
            
            [alertView show];
        }
    }];
}

/**
 *  关注
 */
- (void)followTheUser:(HXSPost *)post
{
    if ([HXSUserAccount currentAccount].isLogin){
        
        __weak typeof(self) weakSelf = self;
        
        if(post.isFollow.boolValue) {
            [HXSCommunityTagModel communityUnFollowUserWithUserId:post.ownerUserId.stringValue complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic)
             {
             if (code == kHXSNoError) {
                 
                 post.isFollow = @(0);
                 
                 [weakSelf.mTableView reloadData];
             }else {
                 [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:2.0];
             }
             
             }];
        }else {
            [HXSCommunityTagModel communityFollowUserWithUserId:post.ownerUserId.stringValue complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic)
             {
             if (code == kHXSNoError) {
                 
                 post.isFollow = @(1);
                 
                 [weakSelf.mTableView reloadData];
             }else {
                 [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:2.0];
             }
             
             }];
        }
    } else {
        
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            
        }];
    }
}

/**
 *  回复人的回复
 *
 */
- (void)commitCommentUserToServer:(NSString *)commentContent
                  CommentedUserId:(NSNumber *)userId
                 CommentedContent:(NSString *)content
{
    [self.view endEditing:YES];
    
    __weak typeof(self) weakSelf = self;
    [HXSCommunityTagModel communityAddCommentWithPostId:self.postEntity.dynamicsId
                                                content:commentContent
                                        commentedUserId:userId
                                       commentedContent:content complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                           if (code == kHXSNoError) {
                                               [weakSelf.keyBoardBarView resetInuptTextView];

                                               HXSComment *commentEntity = [HXSComment objectFromJSONObject:dic[@"comment"]];
                                               
                                               [weakSelf.commentArray insertObject:commentEntity atIndex:0];

                                               [weakSelf.mTableView reloadData];
                                           
                                           }
    }];
}

/**
 *  设置一个隐藏的输入框
 */
- (void)setupkeyBoardView
{
    self.keyBoardBarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:self.keyBoardBarView aboveSubview:self.mTableView];
    
    NSLayoutConstraint *attributeLeading = [NSLayoutConstraint constraintWithItem:self.keyBoardBarView
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1
                                                                        constant:0];
    NSLayoutConstraint *attributeTrailing = [NSLayoutConstraint constraintWithItem:self.keyBoardBarView
                                                                        attribute:NSLayoutAttributeTrailing
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeTrailing
                                                                       multiplier:1
                                                                         constant:0];
    
    NSLayoutConstraint *attributeBottom = [NSLayoutConstraint constraintWithItem:self.keyBoardBarView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1
                                                                          constant:0];

    NSLayoutConstraint *attributeheight = [NSLayoutConstraint constraintWithItem:self.keyBoardBarView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:0
                                                                         constant:44];
    [self.view addConstraint:attributeLeading];
    [self.view addConstraint:attributeTrailing];
    [self.view addConstraint:attributeBottom];
    [self.view addConstraint:attributeheight];
    _attributeBottom = attributeBottom;
    
    __weak typeof(self) weakSelf = self;
    [self.keyBoardBarView setLikeActionBlock:^{
        [weakSelf likeTheCommunity];
    }];
    
    [self.keyBoardBarView setPraiseActionBlock:^{
        [weakSelf praiseTheCommunity];
    }];
    
    [self.keyBoardBarView setSendReplayTextBlock:^(NSString *replyContentText) {
        
        [weakSelf commitCommentPostToserver:replyContentText];
    }];
}

/**
 *  注册cell
 */
- (void)tableViewRegisterNib
{
    __weak typeof(self) weakSelf = self;
    
    [self.mTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreComment];
    }];
    
    [self.mTableView registerNib:[UINib nibWithNibName:kCommunityHeadCell bundle:nil]
          forCellReuseIdentifier:kCommunityHeadCell];
    
    [self.mTableView registerNib:[UINib nibWithNibName:kCommunityContenttextCell bundle:nil]
          forCellReuseIdentifier:kCommunityContenttextCell];
    
    [self.mTableView registerNib:[UINib nibWithNibName:kCommunityH5DetailCell bundle:nil]
          forCellReuseIdentifier:kCommunityH5DetailCell];
    
    [self.mTableView registerNib:[UINib nibWithNibName:kCommunityImageCell bundle:nil]
          forCellReuseIdentifier:kCommunityImageCell];
    
    [self.mTableView registerNib:[UINib nibWithNibName:kCommunityContentfootertableviewCell bundle:nil]
          forCellReuseIdentifier:kCommunityContentfootertableviewCell];
    
    [self.mTableView registerNib:[UINib nibWithNibName:kCommunittyItemLikeTableviewCell bundle:nil]
          forCellReuseIdentifier:kCommunittyItemLikeTableviewCell];
    
    [self.mTableView registerNib:[UINib nibWithNibName:kCommunityItemReplyItemTitleTableviewCell bundle:nil]
          forCellReuseIdentifier:kCommunityItemReplyItemTitleTableviewCell];
    
    self.pageNum = @(2);  // 评论 从第二页开始
}


#pragma mark - Taget Action

/**
 *  弹出举报选项
 */
- (void)postBarButtonAction:(UIBarButtonItem *)postBarButton
{
    [self.actionSheet show];
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
    
    [self.tabBarController addChildViewController:communityPhotosBrowserViewController];
    [self.tabBarController.view addSubview:communityPhotosBrowserViewController.view];
    [communityPhotosBrowserViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tabBarController.view);
    }];
    [communityPhotosBrowserViewController didMoveToParentViewController:self.tabBarController];
}

/**
 *  加载帖子详情
 */
- (void)loadConmunityDetail
{
    if ([self.commentArray count] > 0) {
        [self.commentArray removeAllObjects];
    }
    
    [MBProgressHUD showInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    [HXSCommunityModel getCommunityPostDetialWithPostId:self.postIdStr complete:^(HXSErrorCode code,
                                                                                  NSString *message,
                                                                                  HXSPost *post) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        
        weakSelf.postEntity = post;
        
        weakSelf.commneteCountNum = weakSelf.postEntity.commentCount;
        [weakSelf.commentArray addObjectsFromArray:post.commentList];
        
        weakSelf.keyBoardBarView.likeButton.selected = post.isCollect.boolValue;
        weakSelf.keyBoardBarView.praiseButton.selected = post.isPraise.boolValue;
        [weakSelf.keyBoardBarView.praiseButton setTitle:[NSString stringWithFormat:@"%d", post.praiseCount.intValue] forState:UIControlStateNormal];
        [weakSelf.keyBoardBarView.praiseButton setTitle:[NSString stringWithFormat:@"%d", post.praiseCount.intValue] forState:UIControlStateSelected];
        
        [weakSelf.mTableView reloadData];
    }];
}

/**
 *  分享帖子
 */
- (void)shareTheCommutity
{
    if (self.shareView) {
        
        [self.shareView close];
        self.shareView = nil;
    }
    
    HXSShareParameter *parameter = [[HXSShareParameter alloc] init];
    
    NSString *imageModel =self.postEntity.dynamicsImgList[0];
    
    parameter.shareTypeArr = @[@(kHXSShareTypeWechatMoments),
                               @(kHXSShareTypeWechatFriends),
                               @(kHXSShareTypeQQFriends),
                               @(kHXSShareTypeQQMoments),
                               @(kHXSShareTypeCopyLink)];
    
    self.shareView = [[HXSShareView alloc] initShareViewWithParameter:parameter callBack:nil];
    self.shareView.shareParameter.titleStr = @"59社区";
    self.shareView.shareParameter.textStr = self.postEntity.content;
    self.shareView.shareParameter.imageURLStr = imageModel;
    
    [self.shareView show];
    
    [self commitShareResultToServer];
}

//将分享结果告诉服务器
- (void)commitShareResultToServer
{
//    __block int shareCount = 0;
    __weak typeof(self) weakSelf = self;
    [HXSCommunityTagModel communityAddShareWithPostId:self.postEntity.dynamicsId complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
//        shareCount = [dic[@"share_count"] intValue];
//        if (shareCount != 0) {
//            [weakSelf.keyBoardBarView setShareCount:@(shareCount)];
//        }
        if(code == kHXSNoError) {
            [weakSelf.keyBoardBarView.likeButton setSelected:YES];
        }
    }];
}

/**
 *  删除帖子
 */
- (void)deleteCommunity:(BOOL)isDelegateCommutnity WithRow:(NSInteger)row
{
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:isDelegateCommutnity ? @"确定删除这条状态吗?" : @"确定删除这条回复吗?"
                                                                      message:nil
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"确定"];
    WS(weakSelf);
    if (isDelegateCommutnity) {
        //删除帖子
        alertView.rightBtnBlock = ^{
            [weakSelf deleteThisCommunity];
        };
    } else {
        //删除回复
        alertView.rightBtnBlock = ^{
            [weakSelf deleteCommunityCommentAction:row];
        };
    }
    [alertView show];
}

//确认删除
- (void)deleteThisCommunity
{
    [MBProgressHUD showInView:self.view];
    __weak __typeof(self) weakSelf = self;
    [HXSCommunityModel communityDeletePostWithPostId:self.postEntity.dynamicsId complete:^(HXSErrorCode code, NSString *message, NSNumber *result_status) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        [MBProgressHUD showInViewWithoutIndicator:weakSelf.view.window status:message afterDelay:2];
        if (code == kHXSNoError) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

/**
 *  回复
 */
- (void)setCommentTheCommunityWithPlaceHodlerString:(NSString *)placeHodler
{
    self.keyBoardBarView.commentedTitle = placeHodler;
}

/**
 *  删除回复
 */
- (void)deleteCommunityCommentAction:(NSInteger)row
{
    [MBProgressHUD showInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    HXSCommunityMyReplyModel *replyModel = [[HXSCommunityMyReplyModel alloc] init];
    
    HXSComment *commentEntity = self.commentArray[row];
    
    [replyModel deleteTheCommentWithCommentId:commentEntity.commentId.stringValue andPostId:commentEntity.dynamicsId.stringValue
                                     Complete:^(HXSErrorCode code, NSString *message, NSString *statusStr) {
                                         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                         if (code == kHXSNoError) {
                                             [weakSelf updateTableViewSectionRow:row];
                                             
                                             weakSelf.commneteCountNum = @(weakSelf.commneteCountNum.intValue - 1);
                                         }
                                     }];
}

/**
 *  删除评论之后刷新列表
 *
 *  @param row 行
 */
- (void)updateTableViewSectionRow:(NSInteger)row
{
    [self.mTableView beginUpdates];
    
    [self.commentArray removeObjectAtIndex:row];
    
    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:row inSection:1];
    
    [self.mTableView deleteRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.mTableView endUpdates];
    
    [self.mTableView reloadData];
}

/**
 *  点赞
 */
- (void)praiseTheCommunity
{
    __block int praiseCount = self.postEntity.praiseCount.intValue;
    if ([HXSUserAccount currentAccount].isLogin){
        
        __weak typeof(self) weakSelf = self;
        
        if(self.postEntity.isPraise.boolValue) {
            [HXSCommunityTagModel communityCancelPraiseWithPostId:self.postEntity.dynamicsId complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic)
             {
             if (code == kHXSNoError) {
                 
                 praiseCount --;
                 
                 self.postEntity.isPraise = @(0);
                 
                 self.postEntity.praiseCount = @(praiseCount);
                 
                 [weakSelf.mTableView reloadData];
                 
                 weakSelf.keyBoardBarView.praiseButton.selected = weakSelf.postEntity.isPraise.boolValue;
                 [weakSelf.keyBoardBarView.praiseButton setTitle:[NSString stringWithFormat:@"%d", weakSelf.postEntity.praiseCount.intValue] forState:UIControlStateNormal];
                 [weakSelf.keyBoardBarView.praiseButton setTitle:[NSString stringWithFormat:@"%d", weakSelf.postEntity.praiseCount.intValue] forState:UIControlStateSelected];
             }
             }];
        }else {
            [HXSCommunityTagModel communityPraiseWithPostId:self.postEntity.dynamicsId complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic)
             {
             if (code == kHXSNoError) {
                 
                 praiseCount ++;
                 
                 self.postEntity.isPraise = @(1);
                 
                 self.postEntity.praiseCount = @(praiseCount);
                 
                 [weakSelf.mTableView reloadData];
                 
                 weakSelf.keyBoardBarView.praiseButton.selected = weakSelf.postEntity.isPraise.boolValue;
                 [weakSelf.keyBoardBarView.praiseButton setTitle:[NSString stringWithFormat:@"%d", weakSelf.postEntity.praiseCount.intValue] forState:UIControlStateNormal];
                 [weakSelf.keyBoardBarView.praiseButton setTitle:[NSString stringWithFormat:@"%d", weakSelf.postEntity.praiseCount.intValue] forState:UIControlStateSelected];
             }
             }];
        }
        
    } else {
        
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            
        }];
    }
}

/**
 *  点赞
 */
- (void)likeTheCommunity
{
    if ([HXSUserAccount currentAccount].isLogin){
        
        __weak typeof(self) weakSelf = self;
        
        if(self.postEntity.isCollect.boolValue) {
            [HXSCommunityTagModel communityCancelLikeWithPostId:self.postEntity.dynamicsId
                                                    complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                                        if (code == kHXSNoError) {
                                                            [weakSelf loadConmunityDetail];
                                                        }
                                                    }];
        }else {
            [HXSCommunityTagModel communityAddLikeWithPostId:self.postEntity.dynamicsId
                                                    complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                                        if (code == kHXSNoError) {
                                                            [weakSelf loadConmunityDetail];
                                                        }
                                                    }];
        }
    } else {
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            
        }];
    }
}

//跳转发帖人中心
- (void)loadPostUserCenterViewController:(HXSPost *)postEntity
{
    HXSCommunityMyCenterViewController *communityOthersCenterViewController = [HXSCommunityMyCenterViewController controllerFromXib];
    
    communityOthersCenterViewController.userIdNum = postEntity.ownerUserId;
    
    [self.navigationController pushViewController:communityOthersCenterViewController animated:YES];
    
}

/**
 *  跳转发帖人中心
 */
- (void)loadCommentUserCenterViewController:(NSNumber *)commentUserId
{
    HXSCommunityMyCenterViewController *communityOthersCenterViewController = [HXSCommunityMyCenterViewController controllerFromXib];
    communityOthersCenterViewController.userIdNum = commentUserId;
    
    [self.navigationController pushViewController:communityOthersCenterViewController animated:YES];
    
}

#pragma mark  - tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        
        return 4;
    } else {
        
        return [self.commentArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    
    __weak typeof(self) weakSelf = self;
    
    switch (section) {
        case CommunityDetailSection_Content:
        {
            if (row == CommunittyItem_head) {
                
                HXSCommunityHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommunityHeadCell forIndexPath:indexPath];
                
                [cell setLoadPostUserCenter:^{
                    [weakSelf loadPostUserCenterViewController:weakSelf.postEntity];
                }];
                [cell setFollowUserBlock:^{
                    [weakSelf followTheUser:weakSelf.postEntity];
                }];
                [cell setDropdownBlock:^{
                    [weakSelf deleteCommunity:YES WithRow:0];
                }];
                [cell setPostEntity:self.postEntity];
                
                return cell;
            } else if(row == CommunittyItem_contentText) {
                
                if (self.postEntity.type.intValue == 2) {
                    MLCommunityH5DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommunityH5DetailCell];
                    [cell setCellContentWithImageUrlStr:_postEntity.articleCover titleText:_postEntity.articleTitle contentText:_postEntity.articleContent];
                    
                    [cell setLoadCommunityH5detail:^{
                        if(self.postEntity.articleUrl.length > 0) {
                            NSURL *url = [NSURL URLWithString:self.postEntity.articleUrl];
                            WKWebViewController *viewController = [[WKWebViewController alloc] init];
                            [viewController loadUrl:url];
                            if([viewController isKindOfClass:[UIViewController class]]) {
                                [self.navigationController pushViewController:viewController animated:YES];
                            }
                        }
                    }];
                    return cell;
                }else {
                    HXSCommunityContentTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommunityContenttextCell forIndexPath:indexPath];
                    cell.contentLabel.numberOfLines = 0;
                    cell.contentLabel.lineBreakMode=NSLineBreakByCharWrapping;
                    cell.delegate = self;
                    [cell setPostEntity:self.postEntity];
                    
                    return cell;
                }
            } else if(row == CommunittyItem_contentImg) {
                
                HXSCommunityImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommunityImageCell forIndexPath:indexPath];

                [cell setPostEntity:self.postEntity];
                [cell setShowImages:^(NSMutableArray<HXSCommunitUploadImageEntity *> *uploadImageEntitys, NSInteger index, UIImageView *imageView) {
                    [weakSelf showCommunityImagesWith:uploadImageEntitys
                                             andIndex:index
                                      andTapImageView:imageView
                                        andPostEntity:_postEntity];
                }];
                
                return cell;
            }else {
                HXSCommunityContentFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommunityContentfootertableviewCell forIndexPath:indexPath];
                
                [cell setPostEntity:self.postEntity];
                
                [cell setLikeActionBlock:^{
                    //收藏
                    [weakSelf likeTheCommunity];
                }];
                
                //回复
                [cell setReplyActionBlock:^{
                }];
                
                //点赞
                [cell setPraiseActionBlock:^{
                    [weakSelf praiseTheCommunity];
                }];
                
                return cell;
            }
            
        }
            break;
            
        case CommunityDetailSection_Reply:
        {
            // 评论
            HXSCommunittyItemReplyItemTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommunityItemReplyItemTitleTableviewCell forIndexPath:indexPath];

            [cell setCommentEntity:self.commentArray[row]];
            
            cell.delegate = self;
            
            [cell setReplyActionBlock:^{
                //回复操作
                HXSComment *commentEntity = weakSelf.commentArray[row];
                HXSCommunityCommentUser *user = [commentEntity commentUser];
                
                weakSelf.commnetedUidNum = commentEntity.commentUserId;
                weakSelf.commentedContentStr = commentEntity.content;
                
                [self setCommentTheCommunityWithPlaceHodlerString:[NSString stringWithFormat:@"回复%@",user.userNameStr]];
                [self.keyBoardBarView setSendReplayTextBlock:^(NSString *commentContent) {
                    
                    HXSComment *commentEntity = weakSelf.commentArray[row];
                    
                    [weakSelf commitCommentUserToServer:commentContent
                                        CommentedUserId:commentEntity.commentUserId
                                       CommentedContent:commentEntity.content];
                }];
            }];
            
            [cell setDeleteCommentActionBlock:^{
                [weakSelf deleteCommunity:NO WithRow:row];
            }];
            
            [cell setLoadCommentUserCenterActionBlock:^{
                
                HXSComment *commentEntity = weakSelf.commentArray[row];
                [weakSelf loadCommentUserCenterViewController:commentEntity.commentUserId];
            }];
            
            return cell;

        }
            break;
        default:
            break;
    }
    return nil;
}

//加载更多评论
- (void)loadMoreComment
{
    __weak typeof(self) weakSelf = self;
    [HXSCommunityTagModel getCommunityCommentListWithPostId:self.postIdStr page:self.pageNum  complete:^(HXSErrorCode code, NSString *message, NSArray *comments) {
        
        if (code == kHXSNoError) {
            
            NSInteger page = weakSelf.pageNum.integerValue;
            
            page++;
            
            weakSelf.pageNum = @(page);
            
            [weakSelf.commentArray addObjectsFromArray:comments];
            
            [[weakSelf.mTableView infiniteScrollingView] stopAnimating];
            
            [weakSelf.mTableView reloadData];
        }
        
    }];
}

- (CGFloat)tableView:tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    
    switch (section) {
        case CommunityDetailSection_Content:
        {
            if (row == CommunittyItem_head) {
                
                return 70;
            } else if(row == CommunittyItem_contentText) {
                
                if(self.postEntity.type.intValue == 2) {
                    NSString *contentStr = self.postEntity.articleContent;
                    
                    CGFloat height = [MLCommunityH5DetailCell getCellHeightWithText:contentStr];
                    
                    return height;
                }else {
                    NSString *contentStr = self.postEntity.content;
                    
                    CGFloat height = [HXSCommunityContentTextCell getCellHeightWithText:contentStr lines:0];
                    
                    return height;
                }
            } else if(row == CommunittyItem_contentImg) {
                
                NSInteger count = self.postEntity.dynamicsImgList.count;
                
                CGFloat height = [HXSCommunityImageCell getCellHeightWithImagesCount:count];
                
                return height;
               
            } else {
                
                return 40;
            }
        }
            break;
            
        case CommunityDetailSection_Reply:
        {
            HXSComment *commentEntity = self.commentArray[row];
            
            NSString *commentContentStr =@"";
            CGFloat height = 0;
            if (commentEntity.commentUserName.length != 0) {
                commentContentStr = [commentEntity.commentUserName stringByAppendingString:commentEntity.content];
                height = [HXSCommunittyItemReplyItemTitleTableViewCell getCellHeightWithCommentText:commentContentStr];
            } else {
                commentContentStr = commentEntity.content;
                height = [HXSCommunittyItemReplyItemTitleTableViewCell getCellHeightWithCommentText:commentContentStr];
            }
            
            if(height > TextSingLineHeight) {
                return height + ReplyItemTitleTableViewCellHeight - TextSingLineHeight;
            } else {
                return ReplyItemTitleTableViewCellHeight;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (1 == section) {
        return 10;
    }
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (CommunityDetailSection_Reply == section)
    {
        if (self.commentArray.count != 0) {
            return NormalSectionFooterHeight;
        } else {
            return NoReplySectionFooterHeight;
        }
    }
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (1 == section) {
        
        if (self.commentArray.count == 0) {
            HXSNoCommentView *noCommentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSNoCommentView class])
                                                                            owner:nil
                                                                          options:nil].firstObject;
            return noCommentView;
        } else {
            return nil;
        }
        
    }
    return nil;
}

- (void)tableView:tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [self.keyBoardBarView.inputTextView resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.keyBoardBarView.inputTextView resignFirstResponder];
}

#pragma mark - HXSCommunityContentTextCellDelegate

- (void)copyTheContentWithEntity:(HXSPost *)postEntity
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = postEntity.content;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_done"]];
    [MBProgressHUD showInView:self.view
                   customView:imageView
                       status:@"复制成功"
                   afterDelay:0.5];
}


#pragma mark - HXSCommunittyItemReplyItemTitleTableViewCellDelegate

- (void)copyTheContentWithComment:(HXSComment *)commentEntity
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = commentEntity.content;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_done"]];
    [MBProgressHUD showInView:self.view
                   customView:imageView
                       status:@"复制成功"
                   afterDelay:0.5];
}

#pragma mark - Get Set Methods

- (UIBarButtonItem *)postBarButton
{
    if(!_postBarButton) {
        _postBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav-more"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(postBarButtonAction:)];
    }
    return _postBarButton;
}

- (HXSActionSheet *)actionSheet
{
    if(!_actionSheet) {
        WS(weakSelf);
        
        HXSActionSheetEntity *reportEntity = [[HXSActionSheetEntity alloc] init];
        NSString *userId = [[[HXSUserAccount currentAccount] userID] stringValue];
        HXSActionHandler actionHandler = nil;
        
        
        if ([userId isEqualToString:self.postEntity.ownerUserId.stringValue]) {
            
            reportEntity.nameStr = @"删除";
            actionHandler =^(HXSAction *action){
                [weakSelf deleteCommunity:YES WithRow:0];
            };

        } else {
            
            reportEntity.nameStr = @"举报";
            actionHandler =^(HXSAction *action){
                [MBProgressHUD showInView:weakSelf.view];
                //假举报
                [HXSCommunityModel getCommunityPostDetialWithPostId:self.postEntity.dynamicsId complete:^(HXSErrorCode code,
                                                                                              NSString *message,
                                                                                              HXSPost *post) {
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
                    if(code == kHXSNoError) {
                        [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:@"举报成功！" afterDelay:2];
                    }else {
                        [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:@"举报失败" afterDelay:2];
                    }
                }];
            };
        }

        HXSAction *savePhotoAction = [HXSAction actionWithMethods:reportEntity
                                                          handler:actionHandler];
        _actionSheet = [HXSActionSheet actionSheetWithMessage:@""
                                            cancelButtonTitle:@"取消"];
        [_actionSheet addAction:savePhotoAction];
    }
    return _actionSheet;
}

- (NSMutableArray *)commentArray
{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (HXSKeyBoardBarView *)keyBoardBarView
{
    if (!_keyBoardBarView) {
        
        _keyBoardBarView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSKeyBoardBarView class])
                                                         owner:nil
                                                       options:nil].firstObject;
    }
    
    return _keyBoardBarView;
}


@end
