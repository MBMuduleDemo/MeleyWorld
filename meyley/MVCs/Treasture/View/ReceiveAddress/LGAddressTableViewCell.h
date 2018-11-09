//
//  LGAddressTableViewCell.h
//  meyley
//
//  Created by Bovin on 2018/9/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGReceiveAddressModel;
@protocol LGAddressTableViewCellDelegate <NSObject>

@optional

- (void)setDefaultReceivingAddressWithIndexPath:(NSIndexPath *)indexPath;

- (void)editCurrentReceivingAddressWithIndexPath:(NSIndexPath *)indexPath;

- (void)deleteCurrentReceivingAddressWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface LGAddressTableViewCell : UITableViewCell

@property (nonatomic, weak) id<LGAddressTableViewCellDelegate>delegate;

@property (nonatomic, strong) LGReceiveAddressModel *model;
@end
