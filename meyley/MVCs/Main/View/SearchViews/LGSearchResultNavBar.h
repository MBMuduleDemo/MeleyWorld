//
//  LGSearchResultNavBar.h
//  meyley
//
//  Created by Bovin on 2018/8/4.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LGSearchResultVCBackBlock)(void);
typedef void(^LGSearchResultResearchBlock)(NSString *keywords);
@interface LGSearchResultNavBar : UIView

@property (nonatomic, copy) NSString *keywords;

@property (nonatomic, copy) LGSearchResultVCBackBlock backBlock;

@property (nonatomic, copy) LGSearchResultResearchBlock searchBlock;
@end
