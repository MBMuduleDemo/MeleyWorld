//
//  HXSRegisterRequest.m
//  store
//
//  Created by chsasaw on 14/10/27.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSRegisterRequest.h"

#import "NSMutableDictionary+Safety.h"
#import "NSString+Addition.h"
#import "HXStoreWebService.h"
#import "HXSUserAccount.h"
#import "HXSUserBasicInfo.h"

@implementation HXSRegisterRequest

- (void)registerWithMobile:(NSString *)userPhone password:(NSString *)password invitationcode:(NSString *)invitation_code completeBlock:(void (^)(HXSErrorCode, NSString *, NSNumber *, HXSUserBasicInfo *))block {
    
    if (userPhone == nil || password == nil || userPhone.length == 0 || password.length == 0)
    {
        block(kHXSParamError, @"手机号不能为空", nil, nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObjectExceptNil:userPhone forKey:@"mobile"];
    [dic setObjectExceptNil:[NSString md5:password] forKey:@"password"];
//    [dic setObjectExceptNil:[HXSUserAccount currentAccount].strToken forKey:@"token"];
    if(invitation_code && invitation_code.length > 0) {
        [dic setObjectExceptNil:invitation_code forKey:@"inviteCode"];
    }
    
    [HXStoreWebService postRequest:HXS_USER_REGISTER
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if(status == kHXSNoError) {
                            NSNumber * userId = [NSNumber numberWithInteger:[[data objectForKey:@"userId"] integerValue]];
                            HXSUserBasicInfo * info = [[HXSUserBasicInfo alloc] initWithDictionary:data error:nil];
                            block(kHXSNoError, msg, userId, info);
                        }else {
                            block(status, msg, nil, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil, nil);
                    }];

}

@end
