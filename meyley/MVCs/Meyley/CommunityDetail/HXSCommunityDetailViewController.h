//
//  HXSCommunityDetailViewController.h
//  store
//
//  Created by  黎明 on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HKBaseViewController.h"

@interface HXSCommunityDetailViewController : HKBaseViewController <UITableViewDataSource,
                                                                     UITableViewDelegate,
                                                                     UIAlertViewDelegate>


+ (instancetype)createCommunityDetialVCWithPostID:(NSString *)postIDStr
                                        replyLoad:(BOOL)isReplyLoad
                                              pop:(void (^)(void))popToLastViewController;

@end
