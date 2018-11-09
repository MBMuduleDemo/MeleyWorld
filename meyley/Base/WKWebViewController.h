//
//  WKWebViewController.h
//  meyley
//
//  Created by chsasaw on 2017/2/19.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKBaseViewController.h"

@interface WKWebViewController : HKBaseViewController

- (void)loadUrl:(NSURL *)URL;

- (void)loadHTMLString:(NSString *)htmlString withTitle:(NSString *)title;

@end
