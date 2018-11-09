//
//  LGSettingViewController.m
//  meyley
//
//  Created by Bovin on 2018/9/30.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGSettingViewController.h"
#import "LGSettingTableViewCell.h"

@interface LGSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end
static NSString *const settingCell = @"settingCell";
@implementation LGSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"设置";
    self.dataArray = @[@"关于我们",@"用户协议",@"检测新版本",@"给魅力网打分",@"清除缓存",@"联系我们"];
    [self.view addSubview:self.tableView];
}

#pragma mark--UITableViewDataSource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCell forIndexPath:indexPath];
    cell.typeName = self.dataArray[indexPath.section];
    if ([cell.typeName isEqualToString:@"检测新版本"]) {
        NSString *currentVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
        cell.detailValue = [NSString stringWithFormat:@"当前版本%@",currentVersion];
    }else if ([cell.typeName isEqualToString:@"清除缓存"]) {
        NSUInteger size = [[SDImageCache sharedImageCache]getSize];
        cell.detailValue = [NSString stringWithFormat:@"%.2f M",size/1024/1024.0];
    }else {
        cell.detailValue = @"";
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return viewPix(49);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return viewPix(15);
    }
    return viewPix(12);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

#pragma mark---UITableViewDelegate------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LGSettingTableViewCell *cell = (LGSettingTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 2) { //检测版本
        [self checkAppIsNeedUpdate];
    }else if (indexPath.section == 3) {
        NSURL *url = [NSURL URLWithString:LGAppDownloadUrl];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }else if (indexPath.section == 4) { //清除缓存
        NSUInteger size = [[SDImageCache sharedImageCache]getSize];
        if (size == 0) {
            return;
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.detailsLabel.text = @"正在清除缓存...";
        hud.bezelView.color = [UIColor blackColor];
        hud.contentColor = [UIColor whiteColor];
        hud.removeFromSuperViewOnHide = YES;
        [hud showAnimated:YES];
        [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
            hud.detailsLabel.text = @"清除完成";
            cell.detailValue = @"0.00 M";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        }];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableView == scrollView) {
        if (scrollView.contentOffset.y == scrollView.contentSize.height-Screen_H-topBarHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, bottomSafeBarHeight);
        }else {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

#pragma mark--action---
- (void)checkAppIsNeedUpdate {
    //1.取到当前应用的版本号
    NSString *currentAppVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"%@",currentAppVersion);
    //2.获取AppStore应用信息
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:LGAppLookupVersionUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError *error;
        if (data && data.length>0) {
            id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                id result = [dic objectForKey:LGAppStoreResponseResult];
                if (result && [result isKindOfClass:[NSArray class]]) {
                    NSDictionary *tmpDic = [(NSArray *)result firstObject];
                    NSString *appStoreVersion = [tmpDic objectForKey:LGAppStoreVersion];
                    if (currentAppVersion && appStoreVersion && [currentAppVersion compare:appStoreVersion] != NSOrderedSame) {
                        //需要升级
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self updateAppVersionAlert];
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            hud.mode = MBProgressHUDModeText;
                            hud.bezelView.color = [UIColor blackColor];
                            hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
                            hud.label.text = @"当前为最新版本";
                            hud.label.textColor = [UIColor whiteColor];
                            hud.removeFromSuperViewOnHide = YES;
                            [hud showAnimated:YES];
                            [hud hideAnimated:YES afterDelay:1.5];
                        });
                        
                    }
                }
            }
        }
        
    });
}
- (void)updateAppVersionAlert {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"有新版本更新" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continuAciont = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *chartAction = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:LGAppDownloadUrl];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }];
    [alertController addAction:continuAciont];
    [alertController addAction:chartAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark--lazy----
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        if (kAPIVersion11Later) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerClass:[LGSettingTableViewCell class] forCellReuseIdentifier:settingCell];
    }
    return _tableView;
}

@end
