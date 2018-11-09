//
//  HXSRegisterRequest.h
//  store
//
//  Created by chsasaw on 14/10/27.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXStoreWebServiceErrorCode.h"

@class HXSUserBasicInfo;

@interface HXSRegisterRequest : NSObject

- (void)registerWithMobile:(NSString *)userPhone
                 password:(NSString *)password
           invitationcode:(NSString *)invitation_code
            completeBlock:(void (^)(HXSErrorCode errorcode, NSString * msg, NSNumber * userID, HXSUserBasicInfo * info))block;

@end
