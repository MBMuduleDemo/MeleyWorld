//
//  LGApplicationJoinView.h
//  meyley
//
//  Created by Bovin on 2018/10/24.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGApplicationJoinView : UIView

@property (nonatomic, strong) NSMutableArray *waiterListArray;

@property (nonatomic, assign, readonly) BOOL isAgreeProtocol;

@property (nonatomic, copy) void(^sureApplicationJoinBlock)();

@property (nonatomic, copy) void(^cancelApplicationBlock)();

@property (nonatomic, copy) void(^showUserProtocolBlock)();

@property (nonatomic, copy) void(^chooseUserAddressBlock)(UITextField *textField);

@end



@interface LGApplicationJoinCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, copy) NSString *typeName;

@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, copy) NSString *valueString;

@property (nonatomic, copy) void(^editUserInfoBlock)(NSString *userInfo);
@end


@interface LGApplicationJoinHeaderView : UIView

@property (nonatomic, copy) NSString *waiterType;

@property (nonatomic, copy) NSString *waiterDesc;

@property (nonatomic, copy) void(^ChooseWaiterTypeBlock)(UITextField *textField);

@property (nonatomic, copy) void(^AgreeUserProtocolBlock)(BOOL isSelected);

@property (nonatomic, copy) void(^TapUserProtocol)();

@end

@interface LGApplicationJoinBottomBar : UIView

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIButton *cancelBtn;

@end
