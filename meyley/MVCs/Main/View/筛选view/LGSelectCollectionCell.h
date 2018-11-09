//
//  LGSelectCollectionCell.h
//  meyley
//
//  Created by Bovin on 2018/8/19.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGSelectItemModel.h"
@interface LGSelectCollectionCell : UICollectionViewCell

@property (nonatomic , strong)LGSelectItemModel *model;

@property (nonatomic , strong)UIButton *baseBtn;

@end
