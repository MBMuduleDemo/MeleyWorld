//
//  LGGoodsDetailCategoryCell.m
//  meyley
//
//  Created by Bovin on 2018/8/29.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGGoodsDetailCategoryCell.h"

@interface LGGoodsDetailCategoryCell()

@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UIView *categoryView;
@property (nonatomic , strong)UIView *lineView;

@property (nonatomic , strong)NSArray *categoryArry;
@property (nonatomic , strong)NSMutableArray *viewArry;

@property (nonatomic , assign)NSInteger index;

@end

@implementation LGGoodsDetailCategoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.index = -1;
        [self creatSubView];
    }
    return self;
}

-(void)setModel:(LGGoodsCategoryModel *)model{
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.attrName];
    if (model.selectIndex) {
        self.index = [model.selectIndex integerValue];
    }else{
        self.index = -1;
    }
    self.categoryArry = model.attrValues;
}


-(void)setCategoryArry:(NSArray *)categoryArry{
    _categoryArry = categoryArry;
    NSInteger lineNum = categoryArry.count%3>0?(categoryArry.count/3+1):categoryArry.count/3;
    CGFloat heght = viewPix(36)*lineNum+viewPix(10)*(lineNum-1);
    [self.categoryView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(heght));
    }];
    
    for (UIButton *button in self.categoryView.subviews) {
        [button removeFromSuperview];
    }
    [self.viewArry removeAllObjects];
    
    for (NSInteger i=0; i<categoryArry.count; i++) {
        NSDictionary *dic = categoryArry[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(viewPix(95)*(i%3), viewPix(46)*(i/3), viewPix(85), viewPix(36));
        [button setBackgroundImage:[UIImage imageNamed:@"selNormalBG"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"selSelectBG"] forState:UIControlStateSelected];
        [button setTitleColor:RGB(77, 77, 77) forState:UIControlStateNormal];
        [button setTitleColor:RGB(255, 0, 82) forState:UIControlStateSelected];
        [button setTitle:dic[@"attrValue"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(categoryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = LGFont(12);
        if (self.index == i) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
        [self.categoryView addSubview:button];
        [self.viewArry addObject:button];
    }
    
}


-(void)categoryButtonAction:(UIButton *)sender{
    for (NSInteger i=0; i<self.viewArry.count; i++) {
        UIButton *button = self.viewArry[i];
        if (button == sender) {
            button.selected = YES;
            self.index = i;
            if ([self.delegate respondsToSelector:@selector(selectCategoryAtRow:index:)]) {
                [self.delegate selectCategoryAtRow:self.row index:i];
            }
        }else{
            button.selected = NO;
        }
        
    }
}


-(void)creatSubView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.categoryView];
    [self addSubview:self.lineView];
    __weak typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(viewPix(20));
        make.top.equalTo(weakSelf).offset(viewPix(15));
    }];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(viewPix(15));
        make.right.equalTo(weakSelf).offset(-viewPix(15));
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(viewPix(15));
        make.height.equalTo(@(0));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.categoryView.mas_bottom).offset(viewPix(15));
        make.left.equalTo(weakSelf).offset(viewPix(15));
        make.right.equalTo(weakSelf).offset(-viewPix(15));
        make.bottom.equalTo(weakSelf);
        make.height.equalTo(@(1.0));
    }];
    
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(106, 106, 106) font:12 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _titleLabel;
}

-(UIView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[UIView alloc]init];
    }
    return _categoryView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGB(234, 234, 234);
    }
    return _lineView;
}

-(NSMutableArray *)viewArry{
    if (!_viewArry) {
        _viewArry = [NSMutableArray array];
    }
    return _viewArry;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
