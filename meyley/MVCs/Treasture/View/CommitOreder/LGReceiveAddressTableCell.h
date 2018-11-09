//
//  LGReceiveAddressTableCell.h
//  meyley
//
//  Created by Bovin on 2018/9/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGReceiveAddressModel;
@class LGOrderDetailModel;
@interface LGReceiveAddressTableCell : UITableViewCell

@property (nonatomic, strong) LGReceiveAddressModel *model;
//是否有默认收货地址（区分没有收货地址时使用）
@property (nonatomic, assign) BOOL isHasDefaultAddress;
//使用的收货地址是否是默认的
@property (nonatomic, assign) BOOL isDefault;

//详情也时赋值
@property (nonatomic, strong) LGOrderDetailModel *detailModel;
@end
