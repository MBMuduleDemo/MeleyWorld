//
//  LGWaitPayViewController.m
//  meyley
//
//  Created by Bovin on 2018/10/8.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGWaitPayViewController.h"

@interface LGWaitPayViewController ()

@end

@implementation LGWaitPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orderStatus = LGOrderInfoStatusWaitPay;
    self.isLoadData = NO;
}

@end
