//
//  LGAddNewAddressTableCell.h
//  meyley
//
//  Created by Bovin on 2018/9/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LGAddressCellType) {
    LGAddressCellTypeDefault,
    LGAddressCellTypeChoose,
};

@interface LGAddNewAddressTableCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, assign) LGAddressCellType type;
@property (nonatomic, copy) NSString *typeString;
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) void(^editUserInfoBlock)(UITextField *textField,LGAddressCellType type);

@end
