//
//  LGSelectSectionView.m
//  meyley
//
//  Created by Bovin on 2018/8/19.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGSelectSectionView.h"
#import "MBButton.h"
@interface LGSelectSectionView()

@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)MBButton *allBtn;
@property (nonatomic , strong)UIView *lineView;

@end

@implementation LGSelectSectionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self creatSubView];
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}
- (void)setShouldSelected:(BOOL)shouldSelected {
    _shouldSelected = shouldSelected;
    self.allBtn.selected = shouldSelected;
}
-(void)setShowLine:(BOOL)showLine{
    _showLine = showLine;
    __weak typeof(self) weakSelf = self;
    if (showLine == YES) {
        self.lineView.hidden = NO;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf).offset(viewPix(7.5));
        }];
        [self.allBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(viewPix(15));
        }];
    }else{
        self.lineView.hidden = YES;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf);
        }];
        [self.allBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf);
        }];
    }
}

-(void)allBtnTouchAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(selectSection:open:)]) {
        if (sender.selected == YES) {
            [self.delegate selectSection:self.section open:@"Y"];
        }else{
            [self.delegate selectSection:self.section open:@"N"];
        }
        
    }
}


-(void)creatSubView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.allBtn];
    [self addSubview:self.lineView];
    __weak typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(viewPix(15));
    }];
    
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(weakSelf);
        make.width.equalTo(@(viewPix(80)));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf).offset(viewPix(15));
        make.height.equalTo(@(1.0));
    }];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(106, 106, 106) font:13 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _titleLabel;
}


-(MBButton *)allBtn{
    if (!_allBtn) {
        _allBtn = [MBButton buttonWithType:UIButtonTypeCustom];
        _allBtn.type = MBButtonTypeRightImageLeftTitle;
        [_allBtn setTitle:@"全部" forState:UIControlStateNormal];
        [_allBtn setTitleColor:RGB(106, 106, 106) forState:UIControlStateNormal];
        [_allBtn setTitleColor:RGB(106, 106, 106) forState:UIControlStateHighlighted];
        [_allBtn setImage:[UIImage imageNamed:@"NoramlDown"] forState:UIControlStateNormal];
        [_allBtn setImage:[UIImage imageNamed:@"NoramlUp"] forState:UIControlStateSelected];
        _allBtn.titleLabel.font = LGFont(12);
        _allBtn.spaceMargin = 8;
        _allBtn.selected = NO;
        [_allBtn addTarget:self action:@selector(allBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allBtn;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGB(234, 234, 234);
    }
    return _lineView;
}

@end
