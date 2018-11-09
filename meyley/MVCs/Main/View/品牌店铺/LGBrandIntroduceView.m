//
//  LGBrandIntroduceView.m
//  meyley
//
//  Created by Bovin on 2018/9/26.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGBrandIntroduceView.h"
#import "LGBrandDetailModel.h"
//用户信息model
#import "HXSUserInfo.h"
#import "HXSUserBasicInfo.h"

@interface LGBrandIntroduceView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LGBrandIntroduceHeaderView *headerView;

@property (nonatomic, strong) LGBrandIntroduceBottomBar *bottomBar;

@end

static NSString *const myTableViewCell = @"myTableViewCell";

@implementation LGBrandIntroduceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapGester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAnimation)];
        tapGester.delegate = self;
        [self addGestureRecognizer:tapGester];
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        [self addSubview:self.tableView];
        [self addSubview:self.bottomBar];
        [self showAnimation];
    }
    return self;
}
- (void)setModel:(LGBrandDetailModel *)model {
    _model = model;
    self.headerView.model = model;
}
- (void)showAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, 0, Screen_W*4/5, Screen_H-80);
        self.bottomBar.frame = CGRectMake(0, Screen_H-80, Screen_W*4/5, 80);
    }];
}
- (void)hideAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(-Screen_W, 0, Screen_W*4/5, Screen_H-80);
        self.bottomBar.frame = CGRectMake(-Screen_W, Screen_H-80, Screen_W*4/5, 80);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.tableView.frame, point)) {
        return NO;
    }
    return YES;
}
#pragma mark--UITableViewDataSource---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell.contentView.mas_bottom);
        make.left.equalTo(cell.contentView.mas_left).offset(10);
    }];
    [cell.textLabel sizeToFit];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"品牌首页";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"关于品牌";
    }else {
        cell.textLabel.text = @"购物车";
    }

    cell.textLabel.contentMode = UIViewContentModeBottom;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = ML_BG_MAIN_COLOR;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return viewPix(12);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideAnimation];
    if (self.BrandIntroduceActionBlock) {
        self.BrandIntroduceActionBlock(indexPath.row);
    }
}

#pragma mark--lazy---
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(-Screen_W, 0, Screen_W*4/5, Screen_H-80) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.bounces = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 20);
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:myTableViewCell];
    }
    return _tableView;
}

- (LGBrandIntroduceHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[LGBrandIntroduceHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(150))];
    }
    return _headerView;
}

- (LGBrandIntroduceBottomBar *)bottomBar {
    
    if (!_bottomBar) {
        
        _bottomBar = [[LGBrandIntroduceBottomBar alloc]initWithFrame:CGRectMake(-Screen_W, Screen_H-80, Screen_W*4/5, 80)];
        __weak typeof(self)weakSelf = self;
        _bottomBar.userInfoActionBlock = ^(NSInteger index) {
            if (weakSelf.BrandIntroduceActionBlock) {
                weakSelf.BrandIntroduceActionBlock(index);
            }
        };
    }
    return _bottomBar;
}
@end


@interface LGBrandIntroduceHeaderView ()

//品牌logo
@property (nonatomic, strong) UIImageView *logoImageView;
//品牌名称
@property (nonatomic, strong) UILabel *nameLabel;
//品牌国家地区
@property (nonatomic, strong) UILabel *areaLabel;

@end

@implementation LGBrandIntroduceHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.logoImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.areaLabel];
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(viewPix(10));
            make.bottom.equalTo(self.mas_bottom).offset(-viewPix(10));
            make.width.height.mas_equalTo(viewPix(80));
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImageView.mas_right).offset(viewPix(10));
            make.top.bottom.equalTo(self.logoImageView);
            make.right.equalTo(self.mas_right).offset(-20);
        }];
        [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.mas_top).offset(topBarHeight+10);
        }];
    }
    return self;
}
- (void)setModel:(LGBrandDetailModel *)model {
    _model = model;
    NSString *logoUrl = model.brandLogo.length?model.brandLogo:@"";
    logoUrl = [logoUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@\n%@",model.brandName,model.englishName];
}
#pragma mark--lazy-----
- (UIImageView *)logoImageView {
    
    if (!_logoImageView) {
        
        _logoImageView = [[UIImageView alloc]init];
        _logoImageView.layer.borderColor = ML_BG_MAIN_COLOR.CGColor;
        _logoImageView.layer.borderWidth = 1;
    }
    return _logoImageView;
}
- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = RGB(66, 62, 62);
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}
- (UILabel *)areaLabel {
    
    if (!_areaLabel) {
        _areaLabel = [[UILabel alloc]init];
        _areaLabel.backgroundColor = ML_BG_MAIN_COLOR;
        _areaLabel.textColor = RGB(66, 62, 62);
        _areaLabel.textAlignment = NSTextAlignmentCenter;
        _areaLabel.font = [UIFont systemFontOfSize:12];
        [_areaLabel sizeToFit];
    }
    return _areaLabel;
}
@end


@interface LGBrandIntroduceBottomBar ()

//用户
@property (nonatomic , strong) MBButton *userBtn;
//分类
@property (nonatomic, strong) UIButton *sortBtn;
//品牌商城
@property (nonatomic, strong) UILabel *shopLabel;

@end

@implementation LGBrandIntroduceBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ML_BG_MAIN_COLOR;
        [self addSubview:self.userBtn];
        [self addSubview:self.sortBtn];
        [self addSubview:self.shopLabel];
        [self.userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
            make.width.mas_equalTo(viewPix(150));
            make.height.mas_equalTo(viewPix(40));
        }];
        [self.sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(5);
            make.right.equalTo(self.mas_right).offset(-15);
            make.width.height.mas_equalTo(viewPix(40));
        }];
        [self.shopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userBtn.mas_bottom);
            make.left.equalTo(self.mas_left).offset(10);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}
#pragma mark---action---
- (void)userBtnTapAction:(MBButton *)userBtn {
    if (self.userInfoActionBlock) {
        self.userInfoActionBlock(3);
    }
}
- (void)sortBtnTapAction:(UIButton *)sender {
    if (self.userInfoActionBlock) {
        self.userInfoActionBlock(4);
    }
}
- (void)enterShopHome {
    if (self.userInfoActionBlock) {
        self.userInfoActionBlock(5);
    }
}
#pragma mark--lazy------

-(MBButton *)userBtn{
    if (!_userBtn) {
        _userBtn = [MBButton buttonWithType:UIButtonTypeCustom];
        NSString *name =@"";
        NSString *headPic = @"";
        if ([HXSUserAccount currentAccount].isLogin) {
            name = [HXSUserAccount currentAccount].userInfo.basicInfo.userName;
            headPic = [HXSUserAccount currentAccount].userInfo.basicInfo.headPic;
        }
        [_userBtn setTitle:name forState:UIControlStateNormal];
        [_userBtn sd_setImageWithURL:[NSURL URLWithString:headPic] forState:UIControlStateNormal];
        [_userBtn setTitleColor:RGB(97, 97, 97) forState:UIControlStateNormal];
        _userBtn.titleLabel.font = LGFont(14);
        _userBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 80);
        _userBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        _userBtn.type = MBButtonTypeLeftImageRightTitle;
        _userBtn.textAlignment = MBButtonAlignmentCustom;
        _userBtn.leftMargin = 10;
        [_userBtn addTarget:self action:@selector(userBtnTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userBtn;
}
-(UIButton *)sortBtn{
    if (!_sortBtn) {
        _sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sortBtn setImage:[UIImage imageNamed:@"fenleiicon"] forState:UIControlStateNormal];
        _sortBtn.titleLabel.font = LGFont(13);
        [_sortBtn addTarget:self action:@selector(sortBtnTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortBtn;
}
- (UILabel *)shopLabel {
    
    if (!_shopLabel) {
        
        _shopLabel = [[UILabel alloc]init];
        _shopLabel.textColor = RGB(66, 62, 62);
        _shopLabel.backgroundColor = [UIColor clearColor];
        _shopLabel.text = @"品牌商城";
        _shopLabel.font = [UIFont boldSystemFontOfSize:14];
        _shopLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterShopHome)];
        [_shopLabel addGestureRecognizer:tap];
    }
    return _shopLabel;
}
@end
