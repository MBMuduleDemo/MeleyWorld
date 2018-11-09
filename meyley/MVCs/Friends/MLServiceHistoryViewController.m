//
//  MLServiceHistoryViewController.m
//  meyley
//
//  Created by chsasaw on 2017/5/7.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLServiceHistoryViewController.h"
#import "MLWaiterCollectionViewDelegate.h"
#import "MLServiceRequestModel.h"

@interface MLServiceHistoryViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) MLWaiterCollectionViewDelegate *collectionViewDelegate;

@end

@implementation MLServiceHistoryViewController

+ (NSString *)storyboardName {
    return @"Friends";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionViewDelegate = [[MLWaiterCollectionViewDelegate alloc] initWithCollectionView:self.collectionView superController:self];
    [self.collectionViewDelegate setDescString:@"抱歉，未查到为您服务过的客服"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(self.collectionViewDelegate.waiters.count == 0) {
        [MBProgressHUD showInView:self.view];
        [MLServiceRequestModel getHistoryWaiterListWithComplete:^(HXSErrorCode code, NSString *message, NSArray<MLWaiterModel *> *waiters) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            if(code == kHXSNoError) {
                [self.collectionViewDelegate setWaiters:[waiters mutableCopy]];
            }else {
                [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:2];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
