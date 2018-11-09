//
//  HXSKeyBoardBarView.h
//  store
//
//  Created by  黎明 on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSKeyBoardBarView : UIView<UITextViewDelegate>

/** 输入框 */
@property (nonatomic, weak) IBOutlet UITextView *inputTextView;
/** 发送按钮 */
@property (nonatomic, weak) IBOutlet UIButton   *praiseButton;
@property (nonatomic, weak) IBOutlet UIButton   *likeButton;

/** 提示label */
@property (nonatomic, strong) UILabel  *placeholderLabel;
/** 被回复的标题【用户名或者帖子】*/
@property (nonatomic, strong) NSString *commentedTitle;

@property (nonatomic, strong) UIButton *delButton;

/** 收藏回调 */
@property (nonatomic, copy) void (^likeActionBlock)();
/** 点击发送回调 */
@property (nonatomic, copy) void (^sendReplayTextBlock)(NSString *replayText);
/** 点赞回调 */
@property (nonatomic, copy) void (^praiseActionBlock)();

/**
 *  重置
 */
- (void)resetInuptTextView;

@end
