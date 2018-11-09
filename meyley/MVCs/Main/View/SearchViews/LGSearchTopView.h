//
//  LGSearchTopView.h
//  meyley
//
//  Created by Bovin on 2018/8/11.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LGSearchTopViewDelegate <NSObject>
@optional

-(void)selectSearchKey:(NSString *)searchKey;

-(void)selectBtnTapAction;

@end

@interface LGSearchTopView : UICollectionReusableView

@property (nonatomic , weak) id <LGSearchTopViewDelegate> delegate;


@end
