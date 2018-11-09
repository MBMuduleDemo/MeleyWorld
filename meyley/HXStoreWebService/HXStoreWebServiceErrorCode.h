//
//  HXStoreWebServiceErrorCode.h
//  Pods
//
//  Created by ArthurWang on 16/6/12.
//
//

#ifndef HXStoreWebServiceErrorCode_h
#define HXStoreWebServiceErrorCode_h

typedef enum
{
    //未知错误
    kHXSUnknownError = -1,
    
    //服务器返回的错误
    kHXSNoError = 1,
    
    kHXSNormalError = 0,
    
    kHXSInvalidTokenError = 3,
    
    kHXSParamError = 4,
    
    //自定义错误
    kHXSNetWorkError = 200,
    
    kHXSRegisterAccountExist = 201,
    
    kHXSLoginNoAccountError = 202,
    
    kHXSLoginPasswordError = 203,
    
    kHXSNetworkingCancelError = -999,
    
}HXSErrorCode;


#endif /* HXStoreWebServiceErrorCode_h */
