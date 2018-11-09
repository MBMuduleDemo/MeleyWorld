//
//  MLWaiterTableViewCell.h
//  meyley
//
//  Created by chsasaw on 2017/6/6.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLWaiterTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;

@end
