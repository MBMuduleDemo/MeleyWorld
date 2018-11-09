//
//  HXSPersonalInfoDomel.m
//  store
//
//  Created by ArthurWang on 15/8/7.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSPersonalInfoModel.h"

#import "HXSUserBasicInfo.h"
#import "HXSAccountManager.h"
#import "HXSDeviceUpdateRequest.h"
#import "NSMutableDictionary+Safety.h"
#import "HXSUserAccount.h"
#import "NSData+HXSPrintDataMD5.h"

#define ORIGINAL_MAX_WIDTH 200.0f


@implementation HXSPersonalInfoModel

#pragma mark - Public Methods

+ (void)updateUserName:(NSString *)nickNameStr sex:(NSNumber *)sex birthday:(NSString *)birthday signature:(NSString *)signature headPortrait:(UIImage *)headPortrait complete:(void (^)(HXSErrorCode, NSString *, NSDictionary *))block {
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setObjectExceptNil:nickNameStr forKey:@"userName"];
    [paramsDic setObjectExceptNil:[HXSUserAccount currentAccount].userID forKey:@"userId"];
    [paramsDic setObjectExceptNil:sex forKey:@"sex"];
    [paramsDic setObjectExceptNil:birthday forKey:@"birthday"];
    [paramsDic setObjectExceptNil:signature forKey:@"signature"];
    
    [HXStoreWebService uploadRequest:HXS_USER_MODIFY parameters:paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(headPortrait != nil) {
            NSData *imageData = [self convertImageToData:headPortrait];
            [formData appendPartWithFileData:imageData  name:@"headimg" fileName:[NSString stringWithFormat:@"%@.png", [imageData md5]] mimeType:@"multipart/form-data"];
        }
    } progress:nil success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if (kHXSNoError == status) {
            block(kHXSNoError, msg, data);
        } else {
            block(status, msg, nil);
        }
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status, msg, nil);
    }];
}

+ (void)resetPasswordWithMobile:(NSString *)mobile password:(NSString *)password veifyCode:(NSString *)verifyCode complete:(void (^)(HXSErrorCode, NSString *, NSDictionary *))block {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     password, @"newpassword",
                                     verifyCode, @"verifyCode",
                                     mobile, @"mobile", nil];
    
    [HXStoreWebService postRequest:HXS_USER_PASSWORD_RESET
                        parameters:paramDic
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               if (kHXSNoError == status) {
                                   
                                   block(status, msg, data);
                               } else {
                                   block(status, msg, nil);
                               }
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                               block(status, msg, nil);
                           }];
}

+ (void)updateLoginPassword:(NSString *)oldPasswordStr
                     passwd:(NSString *)passwdStr
              comfirePasswd:(NSString *)comfirePasswdStr
                  complete:(void (^)(HXSErrorCode, NSString *, NSDictionary *))block
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     [NSString md5:passwdStr], @"passwd",
                                     [NSString md5:comfirePasswdStr], @"comfire_passwd", nil];
    if ((nil != oldPasswordStr)
        && ![@"" isEqualToString:oldPasswordStr])
    {
        [paramDic setObject:[NSString md5:oldPasswordStr] forKey:@"old_passwd"];
    }
    
    [HXStoreWebService postRequest:HXS_USER_PASSWORD_RESET
                 parameters:paramDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if (kHXSNoError == status) {
                            
                            block(status, msg, data);
                        } else {
                            block(status, msg, nil);
                        }
                        
                        
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
    
    return;
}

+ (void)updateHeadPortrait:(UIImage *)image
                  complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *passwordDic))block
{
    [self updateUserName:nil sex:nil birthday:nil signature:nil headPortrait:image complete:block];
}

#pragma mark - Private Methods

+ (NSData *)convertImageToData:(UIImage *)image
{
    UIImage *compressedImage = [self imageByScalingToMaxSize:image];
    
    NSData *data = UIImagePNGRepresentation(compressedImage);
    
    return data;
}

+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage
{
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) {
        return sourceImage;
    }
    
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage
                                          targetSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (NO == CGSizeEqualToSize(imageSize, targetSize)) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        } else {
            scaleFactor = heightFactor; // scale to fit width
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(nil == newImage) {
        DLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (void)sendAuthCodeWithPhone:(NSString *)phoneStr
                   verifyType:(HXSVerifyCodeType) type
                     complete:(void(^)(HXSErrorCode code, NSString *message, NSDictionary *authInfo))block
{
    NSString *verifySrc = [[self class] typeStringOfType:type];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [phoneStr compressBlank], @"mobile",
                              verifySrc, @"src", nil];
    
    [HXStoreWebService postRequest:HXS_SMS_SEND
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError == status) {
                           block(status, msg, data);
                       } else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

+ (void)verifAuthCodeWithPhone:(NSString *)phoneStr
                          code:(NSString *)codeStr
                    verifyType:(HXSVerifyCodeType)type
                      complete:(void(^)(HXSErrorCode code, NSString *message, NSDictionary *authInfo))block
{
    NSString *typeStr = [[self class] typeStringOfType:type];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              phoneStr, @"mobile",
                              codeStr,  @"code",
                              typeStr, @"src",nil];
    
    [HXStoreWebService postRequest:HXS_SMS_VERIFY
                       parameters:paramDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError == status) {
//                                  HXSUserBasicInfo *basicInfo = [[HXSUserBasicInfo alloc] initWithDictionary:data error:nil];
//                                  [HXSAccountManager sharedManager].accountType = kHXSUnknownAccount;
//                                  
//                                  [HXSUserAccount currentAccount].userID = basicInfo.userId;
//                                  
//                                  [[HXSUserAccount currentAccount] loadUserInfo];
                                  
//                                  if ([typeStr isEqualToString:@"app_login"]) {
//                                      BEGIN_MAIN_THREAD
//                                      [[NSNotificationCenter defaultCenter] postNotificationName:kLoginCompleted object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:status], @"code",@"登录成功",@"msg", nil]];
//                                      
//                                      [[HXSDeviceUpdateRequest currentRequest] startUpdate];
//                                      END_MAIN_THREAD
//                                  }
                                  
                                  block(status, msg, data);
                              } else {
                                  block(status, msg, nil);
                              }
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                              block(status, msg, nil);
                          }];
}

+ (void)verifyTelephoneForForgetPayPasswd:(NSString *)telephone
                               verifyCode:(NSString *)verifyCode
                               completion:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block
{
    NSDictionary *paramsDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                               telephone, @"phone",
                               verifyCode,@"verify_code", nil];
    
    [HXStoreWebService postRequest:HXS_SMS_VERIFY
                 parameters:paramsDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status, msg, nil);
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}

+ (void)resetPayPassWord:(NSString *)passwd
              completion:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block
{
    NSDictionary *paramsDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSString md5:passwd], @"new_password", nil];
    
    [HXStoreWebService postRequest:HXS_SMS_VERIFY
                 parameters:paramsDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status, msg, nil);
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}

+ (void)verifyOldBindTelephone:(NSString *)telephone
                    verifyCode:(NSString *)verifyCode
                    completion:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block
{
    NSDictionary *paramsDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                               telephone, @"phone",
                               verifyCode, @"verify_code",
                               nil];
    
    [HXStoreWebService postRequest:HXS_SMS_VERIFY
                 parameters:paramsDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status, msg, nil);
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}


+ (void)modifyBindTelephone:(NSString *)telephone
                 verifyCode:(NSString *)verifyCode
                 completion:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block
{
    NSDictionary *paramsDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                               telephone, @"new_phone",
                               verifyCode, @"verify_code",
                               nil];
    
    [HXStoreWebService postRequest:HXS_SMS_VERIFY
                 parameters:paramsDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status, msg, nil);
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}

+ (void)inviteTheUser:(NSNumber *)userId complete:(void (^)(HXSErrorCode, NSString *, HXSUserBasicInfo *))block {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:userId forKey:@"ownerUserId"];
    if([HXSUserAccount currentAccount].isLogin) {
        [dic setObjectExceptNil:[HXSUserAccount currentAccount].userID forKey:@"userId"];
    }
    
    [HXStoreWebService getRequest:ML_USER_INVITE
                       parameters:dic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              
                              if(kHXSNoError == status){
                                  
                                  HXSUserBasicInfo *info = [[HXSUserBasicInfo alloc] initWithDictionary:data error:nil];
                                  
                                  block(status,msg,info);
                              } else {
                                  block(status,msg,nil);
                              }
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status,msg,nil);
                          }];
}

#pragma mark - Private Methods

+ (NSString *)typeStringOfType:(HXSVerifyCodeType)type
{
    NSString *verifySrc = @"app_login";
    
    switch (type) {
        case HXSVerifyAppRegister:
            verifySrc = @"app_register";
            break;
        case HXSVerifyAppLogin:
            verifySrc = @"app_login";
            break;
        case HXSVerifyPhoneBind:
            verifySrc = @"phone_bind";
            break;
        case HXSVerifyForgetPayPasswd:
            verifySrc = @"forget_pay_password";
            break;
        default:
            break;
    }
    
    return verifySrc;
}


@end
