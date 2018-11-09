//
//  MLRecommendWaiterView.m
//  meyley
//
//  Created by chsasaw on 2017/6/2.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLRecommendWaiterView.h"
#import "MLServiceRequestModel.h"
#import "MLWaiterCollectionViewDelegate.h"

@interface MLRecommendWaiterView()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;
@property (nonatomic, strong) MLWaiterCollectionViewDelegate *waiterCollectionViewDelegate;

@end

@implementation MLRecommendWaiterView

+ (instancetype)waiterView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] objectAtIndex:0];
}

- (void)showInViewController:(UIViewController *)controller {
    _waiterCollectionViewDelegate = [[MLWaiterCollectionViewDelegate alloc] initWithCollectionView:self.collectionView superController:controller];
    _waiterCollectionViewDelegate.showRecommendView = NO;
    [MLServiceRequestModel getRecommendWaiterListWithComplete:^(HXSErrorCode code, NSString *message, NSArray<MLWaiterModel *> *waiters) {
        [_waiterCollectionViewDelegate setWaiters:[waiters mutableCopy]];
    }];
}

- (void)setDescText:(NSString *)desc {
    self.descLabel.text = desc;
}

@end
