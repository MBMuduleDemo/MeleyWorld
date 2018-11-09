//
//  HXSNoDataView.h
//  store
//
//  Created by  黎明 on 16/4/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

/**************************
 *  这个人比较懒，什么都没有留下=_=*~
 *************************/

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HXSCommunityNoDataType)
{
    kHXSCommunityNoDataTypePost         = 0,    // 回复内容包括头像
    kHXSCommunityNoDataTypeMyReply      = 1,    // 主帖内容
    kHXSCommunityNoDataTypeReplyForMe   = 2,    // 话题
};

@interface HXSNoDataView : UITableViewCell

- (void)initTheHXSNoDataViewWithType:(HXSCommunityNoDataType)type;

@end
