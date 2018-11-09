//
//  LGBaseInputView.h
//  meyley
//
//  Created by Bovin on 2018/10/17.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGBaseInputView : UIView

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, copy) NSString *typeName;

@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, copy) void(^userInputInfoHandler)(NSString *text);

@end
