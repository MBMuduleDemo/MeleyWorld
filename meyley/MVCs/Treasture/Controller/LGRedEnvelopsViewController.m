//
//  LGRedEnvelopsViewController.m
//  meyley
//
//  Created by Bovin on 2018/9/14.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGRedEnvelopsViewController.h"
#import "LGRedEnvelopTableViewCell.h"
#import "LGNonuseRedEnvelopCollectionCell.h"
#import "LGAddRedEnvelopBottomBar.h"
//红包model
#import "LGRedEnvelopModel.h"
//添加红包弹框
#import "LGAddRedEnvelopAlertView.h"
//获取用户积分model
#import "LGUserMoneyIntegralModel.h"
//积分栏
#import "LGUseIntegralView.h"

@interface LGRedEnvelopsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
//可用红包
@property (nonatomic, strong) NSMutableArray *dataArray;
//添加红包
@property (nonatomic, strong) LGAddRedEnvelopBottomBar *bottomBar;
//选中的红包
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
//红包弹框
@property (nonatomic, strong) LGAddRedEnvelopAlertView *alertView;
//红包码
@property (nonatomic, copy) NSString *redCode;
//获取用户的积分信息
@property (nonatomic, strong) LGUserMoneyIntegralModel *userModel;

@property (nonatomic, strong) LGUseIntegralView *integralView;

//占位图,没有数据时
@property(nonatomic , strong) UIView * tableViewBackView;

@end
static NSString *const redEnvelopCell = @"redEnvelopCell";
static NSString *const nonuseRedEnvelopCell = @"nonuseRedEnvelopCell";
static NSString *const redEnvelopHeader = @"redEnvelopHeader";
@implementation LGRedEnvelopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的红包";
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.integralView];
    [self.view addSubview:self.bottomBar];
    //获取所有可用的红包
    [self getAllEnableRedEnvelops];
    
    //获取用户积分
    [self getUserAllIntegral];
    
}
- (void)getAllEnableRedEnvelops {

    NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
    NSString *action = [NSString stringWithFormat:@"userId=%@",userId];
    [RequestUtil withGET:@"/api/mw/user/bonus/list.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            NSNumber *total = [responseObject objectForKey:@"total"];
            if ([total integerValue]>0) {
                NSMutableArray *tmpArr = [LGRedEnvelopModel mj_objectArrayWithKeyValuesArray:responseObject[@"bonusList"]];
                [self.dataArray addObjectsFromArray:tmpArr];
            }
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
        if (self.dataArray.count) {
            for (NSInteger i = 0; i<self.dataArray.count; i++) {
                LGRedEnvelopModel *model = self.dataArray[i];
                if (model.isUsed) {
                    [self.dataArray removeObject:model];
                }
                if ([[NSDate date] compare:[MBTools transformDateFromDateString:model.useEndDate]] == NSOrderedDescending) { //过期的红包
                    [self.dataArray removeObject:model];
                }
            }
            self.collectionView.backgroundView.hidden = YES;
            [self.collectionView reloadData];
        }else {
            self.collectionView.backgroundView.hidden = NO;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)getUserAllIntegral {
    NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
    NSString *action = [NSString stringWithFormat:@"userId=%@",userId];
    [RequestUtil withGET:@"/api/ecs/user/moneyinfo.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            
            self.userModel = [LGUserMoneyIntegralModel mj_objectWithKeyValues:responseObject[@"result"]];
            self.integralView.allIntegral = self.userModel.payPoints;
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark--UICollectionViewDataSource--
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.dataArray.count) {
        return 2;
    }
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataArray.count) {
        return self.dataArray.count;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LGRedEnvelopTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:redEnvelopCell forIndexPath:indexPath];
    LGRedEnvelopModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:redEnvelopHeader forIndexPath:indexPath];
    header.backgroundColor = [UIColor clearColor];
    [header.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (indexPath.section == 0) {
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = RGB(149, 149, 149);
        label.text = [NSString stringWithFormat:@"共%ld个红包可用",self.dataArray.count];
        NSString *count = [NSString stringWithFormat:@"%ld",self.dataArray.count];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:label.text];
        [string addAttribute:NSForegroundColorAttributeName value:RGB(255, 0, 82) range:NSMakeRange(1, count.length)];
        label.attributedText = string;
        [header addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header.mas_left).offset(viewPix(15));
            make.bottom.equalTo(header.mas_bottom).offset(-viewPix(12));
        }];
    }
    return header;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(Screen_W, viewPix(44));
}
#pragma mark--UICollectionViewDelegate--
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath != self.selectIndexPath) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:self.selectIndexPath];
        cell.selected = NO;
    }
    cell.selected = YES;
    self.selectIndexPath = indexPath;
}
//添加红包
- (void)addNewRedEnvelops {
    self.alertView = [[LGAddRedEnvelopAlertView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H) title:@"添加红包" commitBtnTitle:@"提交"];
    __weak typeof(self)weakSelf = self;
    self.alertView.redEnvelopCode = ^(NSString *redCode) {
        weakSelf.redCode = redCode;
    };
    self.alertView.sureBtnClickBlock = ^{
        [weakSelf.alertView removeFromSuperview];
        weakSelf.alertView = nil;
        [weakSelf requestToAddRedEnvelop];
    };
    
    [self.view.window addSubview:self.alertView];
}
//添加红包接口
- (void)requestToAddRedEnvelop {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [TooltipView showMessage:@"正在开发中..." offset:0];
    });
}
#pragma mark--lazy----
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 10;
        layout.itemSize = CGSizeMake(Screen_W, viewPix(53));
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight-viewPix(65)-viewPix(105)) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundView = self.tableViewBackView;
        _collectionView.backgroundView.hidden = YES;
        [_collectionView registerClass:[LGNonuseRedEnvelopCollectionCell class] forCellWithReuseIdentifier:nonuseRedEnvelopCell];
        [_collectionView registerClass:[LGRedEnvelopTableViewCell class] forCellWithReuseIdentifier:redEnvelopCell];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:redEnvelopHeader];
    }
    return _collectionView;
}
- (LGAddRedEnvelopBottomBar *)bottomBar {
    
    if (!_bottomBar) {
        
        _bottomBar = [[LGAddRedEnvelopBottomBar alloc]initWithFrame:CGRectMake(0, Screen_H-topBarHeight-viewPix(65), Screen_W, viewPix(65))];
        __weak typeof(self)weakSelf = self;
        _bottomBar.addNewRedEnvelops = ^{
            [weakSelf addNewRedEnvelops];
        };
    }
    return _bottomBar;
}

- (LGUseIntegralView *)integralView {
    
    if (!_integralView) {
        
        _integralView = [[LGUseIntegralView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), Screen_W, viewPix(105))];
        __weak typeof(self)weakSelf = self;
        _integralView.useIntegralBlock = ^(NSString *disCount) {
            LGRedEnvelopModel *model;
            if (weakSelf.selectIndexPath && weakSelf.dataArray.count) {
                model = weakSelf.dataArray[weakSelf.selectIndexPath.row];
            }else {
                model = nil;
            }
            weakSelf.chooseRedEnvelopFinish(model, disCount);
        };
    }
    return _integralView;
}
- (UIView *)tableViewBackView {
    
    if (!_tableViewBackView) {
        
        _tableViewBackView = [[UIView alloc]initWithFrame:self.collectionView.bounds];
        
        UIImageView * tableViewBackImageView= [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W - viewPix(50))/2, _tableViewBackView.frame.size.height/2-viewPix(38), viewPix(50), viewPix(50))];
        tableViewBackImageView.image = [UIImage imageNamed:@""];
        [_tableViewBackView addSubview:tableViewBackImageView];
        
        UILabel * tableViewBackLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tableViewBackImageView.frame)+10, Screen_W, 50)];
        tableViewBackLabel.font = LGFont(15);
        tableViewBackLabel.textAlignment = NSTextAlignmentCenter;
        tableViewBackLabel.textColor = RGB(66, 62, 62);
        tableViewBackLabel.text = @"没有红包可用";
        [_tableViewBackView addSubview:tableViewBackLabel];
    }
    return _tableViewBackView;
}
- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
