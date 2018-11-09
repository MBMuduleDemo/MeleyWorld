//
//  LGSelectPriceView.h
//  meyley
//
//  Created by Bovin on 2018/8/19.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LGSelectPriceViewDelegate <NSObject>

-(void)selectLowPrice:(NSString *)lowPrice;

-(void)selectHighPrice:(NSString *)highPrice;

@end;

@interface LGSelectPriceView : UICollectionReusableView

@property (nonatomic , weak) id <LGSelectPriceViewDelegate> delegate;

-(void)restAction;

@end
