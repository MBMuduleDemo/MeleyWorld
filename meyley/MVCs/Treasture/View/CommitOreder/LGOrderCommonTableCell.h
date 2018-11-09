//
//  LGOrderCommonTableCell.h
//  meyley
//
//  Created by Bovin on 2018/9/11.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGOrderCommonTableCell : UITableViewCell

@property (nonatomic, copy) NSString *typeName;

@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, copy) NSString *valueString;

//详情页时，禁用交互
@property (nonatomic, assign) BOOL disableInteraction;

@property (nonatomic, copy) void(^orderTipsMessageBlock)(NSString *msg);
@end
