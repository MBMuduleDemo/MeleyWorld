//
//  LGBrandCategoryView.m
//  meyley
//
//  Created by Bovin on 2018/9/27.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGBrandCategoryView.h"
#import "LGBrandDetailModel.h"

@interface LGBrandCategoryView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LGBrandCategoryHeaderView *headerView;

@end

static NSString *const myTableViewCell = @"myTableViewCell";

@implementation LGBrandCategoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapGester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAnimation)];
        tapGester.delegate = self;
        [self addGestureRecognizer:tapGester];
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        [self addSubview:self.tableView];
        [self showAnimation];
    }
    return self;
}

#pragma mark---setter---
- (void)setModel:(LGBrandDetailModel *)model {
    _model = model;
    [self.tableView reloadData];
}

#pragma mark--action----
- (void)showAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(Screen_W/5, 0, Screen_W*4/5, Screen_H);
    }];
}
- (void)hideAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(Screen_W, 0, Screen_W*4/5, Screen_H);
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
- (void)showAllChildCategories:(UITapGestureRecognizer *)tap {

    NSInteger index = tap.view.tag -2000;
    LGBrandDetailCategoryModel *model = self.model.category[index];
    model.isOpen =! model.isOpen;
    [self.tableView reloadData];
}

#pragma mark--UITableViewDataSource---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.category.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LGBrandDetailCategoryModel *model = self.model.category[section];
    if (model.isOpen) {
        return model.children.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = ML_BG_MAIN_COLOR;
    LGBrandDetailCategoryModel *model = self.model.category[indexPath.section];
    LGBrandDetailCategoryModel *childModel = model.children[indexPath.row];
    cell.textLabel.text = childModel.catName;
    [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView.mas_left).offset(40);
    }];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.tag = 2000 + section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAllChildCategories:)];
    [view addGestureRecognizer:tap];
    UILabel *label = [[UILabel alloc]init];
    LGBrandDetailCategoryModel *model = self.model.category[section];
    label.text = model.catName;
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        make.left.equalTo(view.mas_left).offset(20);
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"NoramlDown"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"NoramlUp"] forState:UIControlStateSelected];
    button.selected = model.isOpen;
    button.userInteractionEnabled = NO;
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(view);
        make.width.mas_equalTo(viewPix(44));
    }];
    UIView *sepLine = [[UIView alloc]init];
    sepLine.backgroundColor = ML_BG_MAIN_COLOR;
    [view addSubview:sepLine];
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom);
        make.left.equalTo(view.mas_left).offset(15);
        make.right.equalTo(view.mas_right).offset(-12);
        make.height.mas_equalTo(1);
    }];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return viewPix(40);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideAnimation];
    LGBrandDetailCategoryModel *model = self.model.category[indexPath.section];
    LGBrandDetailCategoryModel *childModel = model.children[indexPath.row];
    if (self.FilterGoodsBlock) {
        self.FilterGoodsBlock(childModel.catId);
    }
}

#pragma mark--lazy---
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(Screen_W, 0, Screen_W*4/5, Screen_H) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.rowHeight = viewPix(44);
        _tableView.bounces = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 20);
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:myTableViewCell];
    }
    return _tableView;
}

- (LGBrandCategoryHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[LGBrandCategoryHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(150))];
        __weak typeof(self)weakSelf = self;
        _headerView.seeAllBrandGoodsBlock = ^{
            [weakSelf hideAnimation];
            if (weakSelf.FilterGoodsBlock) {
                weakSelf.FilterGoodsBlock(@"");
            }
        };
        _headerView.SearchBrandGoodsBlock = ^(NSString *keyWords) {
            [weakSelf hideAnimation];
            if (weakSelf.SearchGoodsBlock) {
                weakSelf.SearchGoodsBlock(keyWords);
            }
        };
    }
    return _headerView;
}
@end


@interface LGBrandCategoryHeaderView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textfield;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UILabel *allGoodsLabel;

@property (nonatomic, strong) UILabel *seeGoodsLabel;

@end

@implementation LGBrandCategoryHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textfield];
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.allGoodsLabel];
        [self.containerView addSubview:self.seeGoodsLabel];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(viewPix(44));
        }];
        [self.allGoodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.containerView);
            make.left.equalTo(self.containerView.mas_left).offset(20);
        }];
        [self.seeGoodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.containerView);
            make.right.equalTo(self.containerView.mas_right).offset(-16);
        }];
        [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.bottom.equalTo(self.containerView.mas_top).offset(-10);
            make.height.mas_equalTo(viewPix(35));
        }];
    }
    return self;
}
#pragma mark--UITextFieldDelegate--
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length>0) {
        if (self.SearchBrandGoodsBlock) {
            self.SearchBrandGoodsBlock(textField.text);
        }
    }
}
#pragma mark--action---
//查看所有商品
- (void)seeAllBrandGoods {
    if (self.seeAllBrandGoodsBlock) {
        self.seeAllBrandGoodsBlock();
    }
}
#pragma mark--lazy-------
- (UITextField *)textfield {
    
    if (!_textfield) {
        
        _textfield = [[UITextField alloc]init];
        _textfield.borderStyle = UITextBorderStyleRoundedRect;
        _textfield.placeholder = @"搜索关键字";
        _textfield.font = LGFont(14);
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewPix(30), 44-viewPix(10))];
        UIImageView *searchIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sousuo"]];
        searchIcon.center = CGPointMake(leftView.center.x+viewPix(5), leftView.center.y);
        [leftView addSubview:searchIcon];
        _textfield.leftView = leftView;
        _textfield.leftViewMode = UITextFieldViewModeAlways;
        _textfield.tintColor = RGB(255, 0, 82);
        _textfield.returnKeyType = UIReturnKeySearch;
        _textfield.delegate = self;
    }
    return _textfield;
}
- (UIView *)containerView {
    
    if (!_containerView) {
        
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = ML_BG_MAIN_COLOR;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeAllBrandGoods)];
        [_containerView addGestureRecognizer:tap];
    }
    return _containerView;
}
- (UILabel *)allGoodsLabel {
    
    if (!_allGoodsLabel) {
        
        _allGoodsLabel = [[UILabel alloc]init];
        _allGoodsLabel.textAlignment = NSTextAlignmentLeft;
        _allGoodsLabel.font = [UIFont systemFontOfSize:16];
        _allGoodsLabel.textColor = RGB(66, 62, 62);
        _allGoodsLabel.text = @"全部商品";
    }
    return _allGoodsLabel;
}
- (UILabel *)seeGoodsLabel {
    
    if (!_seeGoodsLabel) {

        _seeGoodsLabel = [[UILabel alloc]init];
        _seeGoodsLabel.textAlignment = NSTextAlignmentRight;
        _seeGoodsLabel.text = @"查看";
        _seeGoodsLabel.font = [UIFont systemFontOfSize:16];
        _seeGoodsLabel.textColor = RGB(66, 62, 62);
    }
    return _seeGoodsLabel;
}
@end
