//
//  MLNearbyServiceViewController.m
//  meyley
//
//  Created by chsasaw on 2017/5/7.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLNearbyServiceViewController.h"
#import "MLWaiterCollectionViewDelegate.h"
#import "MLServiceRequestModel.h"
#import "MLRecommendWaiterView.h"

@interface MLNearbyServiceViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) MLWaiterCollectionViewDelegate *collectionViewDelegate;

@end

@implementation MLNearbyServiceViewController

+ (NSString *)storyboardName {
    return @"Friends";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionViewDelegate = [[MLWaiterCollectionViewDelegate alloc] initWithCollectionView:self.collectionView superController:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(self.collectionViewDelegate.waiters.count == 0) {
        [MBProgressHUD showInView:self.view];
        [MLServiceRequestModel getNearbyWaiterListWithComplete:^(HXSErrorCode code, NSString *message, NSArray<MLWaiterModel *> *waiters) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            if(code == kHXSNoError) {
                [self.collectionViewDelegate setWaiters:[waiters mutableCopy]];
            }else {
                [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:2];
            }
        }];
    }
}

@end
