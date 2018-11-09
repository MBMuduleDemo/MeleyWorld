//
//  MLServiceCenterViewController.m
//  meyley
//
//  Created by chsasaw on 2017/5/7.
//  Copyright © 2017年 Meyley. All rights reserved.
//  客服中心

#import "MLServiceCenterViewController.h"
#import "HXSelectionControl.h"
#import "Masonry.h"
#import "MLMyServiceViewController.h"
#import "MLServiceHistoryViewController.h"
#import "MLNearbyServiceViewController.h"

@interface MLServiceCenterViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>


@property (nonatomic, weak) IBOutlet UIView *selectionContainerView;

@property (nonatomic, strong) HXSelectionControl  *selectionControl;
@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, strong) MLMyServiceViewController *myServiceVC;
@property (nonatomic, strong) MLServiceHistoryViewController *historyVC;
@property (nonatomic, strong) MLNearbyServiceViewController *nearbyVC;

@property (nonatomic, assign) NSInteger currentSelectIndex;

@end

@implementation MLServiceCenterViewController

+ (NSString *)storyboardName {
    return @"Friends";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客服中心";
    
    // Do any additional setup after loading the view.
    [self.selectionContainerView addSubview:self.selectionControl];
    [self.selectionContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectionControl.mas_left);
        make.right.equalTo(self.selectionControl.mas_right);
        make.top.equalTo(self.selectionControl.mas_top);
        make.bottom.equalTo(self.selectionControl.mas_bottom);
    }];
    self.selectionControl.selectedIdx = 1;
    self.currentSelectIndex = 1;
    
    [self.pageViewController setViewControllers:@[self.myServiceVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - geters
- (HXSelectionControl *)selectionControl{
    if (!_selectionControl) {
        _selectionControl = [[HXSelectionControl alloc] init];
        [_selectionControl setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40)];
        [_selectionControl setTitles:@[@"历史客服",@"我的客服",@"附近客服"]];
        [_selectionControl addTarget:self action:@selector(selectItemAction:) forControlEvents:UIControlEventValueChanged];
        [_selectionControl setSelectedIdx:0];
        
        HXSelectionControlStyle *style = [[HXSelectionControlStyle alloc] init];
        style.titleFont = [UIFont systemFontOfSize:16];
        style.titleColor = [UIColor colorWithRGBHex:0x333333];
        style.selectedColor = ML_ACCENT_COLOR;
        [_selectionControl setStyle:style];
    }
    return _selectionControl;
}

- (MLNearbyServiceViewController *)nearbyVC {
    if(!_nearbyVC) {
        _nearbyVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MLNearbyServiceViewController class])];
    }
    
    return _nearbyVC;
}

- (MLMyServiceViewController *)myServiceVC {
    if(!_myServiceVC) {
        _myServiceVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MLMyServiceViewController class])];;
    }
    
    return _myServiceVC;
}

- (MLServiceHistoryViewController *)historyVC {
    if(!_historyVC) {
        _historyVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MLServiceHistoryViewController class])];;
    }
    
    return _historyVC;
}

#pragma mark - SelectionControl Action

-(void)selectItemAction:(HXSelectionControl *)sender
{
    NSInteger index = sender.selectedIdx;
    
    
    UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionForward;
    
    if(_currentSelectIndex > index) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
       
    _currentSelectIndex = index;
       
    switch (index)
    {
        case 0:
        {
        [self.pageViewController setViewControllers:@[self.historyVC]
                                          direction:direction
                                           animated:YES
                                         completion:nil];
        }
        break;
        
        case 1:
        {
        [self.pageViewController setViewControllers:@[self.myServiceVC]
                                          direction:direction
                                           animated:YES
                                         completion:nil];
        }
        break;
        
        default:
        {
        [self.pageViewController setViewControllers:@[self.nearbyVC]
                                          direction:direction
                                           animated:YES
                                         completion:nil];
        }
        break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"Page"]) {
        self.pageViewController = segue.destinationViewController;
        self.pageViewController.delegate = self;
        self.pageViewController.dataSource = self;
    }
}

#pragma mark - UIPageViewControllerDelegate, UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    if(viewController == self.myServiceVC) {
        return self.historyVC;
    }else if(viewController == self.nearbyVC) {
        return self.myServiceVC;
    }else {
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    if(viewController == self.myServiceVC) {
        return self.nearbyVC;
    }else if(viewController == self.historyVC) {
        return self.myServiceVC;
    }else {
        return nil;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    UIViewController *viewController = pageViewController.viewControllers[0];
    if(viewController == self.myServiceVC) {
        return [self.selectionControl setSelectedIdx:1];
    }else if(viewController == self.historyVC) {
        return [self.selectionControl setSelectedIdx:0];
    }else {
        return [self.selectionControl setSelectedIdx:2];
    }
}

@end
