//
//  NSString+Emoj.h
//  meyley
//
//  Created by chsasaw on 2017/4/9.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emoj)

+ (BOOL)stringContainsEmoji:(NSString *)string;

- (BOOL)containsEmoji;

@end
