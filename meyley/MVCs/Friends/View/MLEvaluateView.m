//
//  MLEvaluateView.m
//  meyley
//
//  Created by chsasaw on 2017/5/8.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLEvaluateView.h"

@interface MLEvaluateView()

@property (nonatomic, weak) IBOutlet UIImageView *star1;
@property (nonatomic, weak) IBOutlet UIImageView *star2;
@property (nonatomic, weak) IBOutlet UIImageView *star3;
@property (nonatomic, weak) IBOutlet UIImageView *star4;
@property (nonatomic, weak) IBOutlet UIImageView *star5;

@end

@implementation MLEvaluateView

- (void)setEvaluate:(NSInteger)evaluate {
    _evaluate = evaluate;
    
    self.star1.highlighted = evaluate >= 1;
    self.star2.highlighted = evaluate >= 2;
    self.star3.highlighted = evaluate >= 3;
    self.star4.highlighted = evaluate >= 4;
    self.star5.highlighted = evaluate >= 5;
}

@end
