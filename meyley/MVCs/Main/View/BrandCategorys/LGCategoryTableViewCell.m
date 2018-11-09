//
//  LGCategoryTableViewCell.m
//  meyley
//
//  Created by Bovin on 2018/8/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGCategoryTableViewCell.h"

@interface LGCategoryTableViewCell ()

@property (nonatomic, strong) UILabel *categoryLabel;

@property (nonatomic, strong) UIView *indicatorLine;

@property (nonatomic, strong) UIView *sepLine;

@end

@implementation LGCategoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.categoryLabel];
        [self.contentView addSubview:self.indicatorLine];
        [self.contentView addSubview:self.sepLine];
        [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.contentView);
        }];
        [self.indicatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(3);
        }];
        [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView.mas_bottom).offset(-1);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

-(void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    self.categoryLabel.text = titleText;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = ML_BG_MAIN_COLOR;
        self.indicatorLine.hidden = NO;
        self.categoryLabel.textColor = RGB(255, 0, 82);
    }else {
        self.backgroundColor = [UIColor whiteColor];
        self.indicatorLine.hidden = YES;
        self.categoryLabel.textColor = RGB(66, 62, 62);
    }
}
#pragma mark---lazy-----
- (UILabel *)categoryLabel {
    
    if (!_categoryLabel) {
        
        _categoryLabel = [[UILabel alloc]init];
        _categoryLabel.textAlignment = NSTextAlignmentCenter;
        _categoryLabel.textColor = RGB(66, 62, 62);
        _categoryLabel.font = LGFont(14);
    }
    return _categoryLabel;
}
- (UIView *)indicatorLine {
    
    if (!_indicatorLine) {
        
        _indicatorLine = [[UIView alloc]init];
        _indicatorLine.backgroundColor = RGB(255, 0, 82);
        _indicatorLine.hidden = YES;
    }
    return _indicatorLine;
}
- (UIView *)sepLine {
    
    if (!_sepLine) {
        
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = ML_BG_MAIN_COLOR;
    }
    return _sepLine;
}
@end
