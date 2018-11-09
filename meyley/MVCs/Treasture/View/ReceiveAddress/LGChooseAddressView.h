//
//  LGChooseAddressView.h
//  meyley
//
//  Created by Bovin on 2018/9/17.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGChooseAddressView : UIViewController

@property (nonatomic, copy) void(^chooseAddressIdsAndNames)(NSDictionary *dic);

@end



@interface LGAddressChooseTopBar : UIView

@property (nonatomic, strong) NSMutableArray *titleArr;

@property (nonatomic, copy) void(^chooseAddressBlock)(NSInteger index);

@end
