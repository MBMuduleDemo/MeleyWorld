//
//  LGCustomVipTableViewCell.m
//  meyley
//
//  Created by Bovin on 2018/10/19.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGCustomVipTableViewCell.h"
#import "LGMyUserModel.h"


@interface LGCustomVipTableViewCell ()

//头像
@property (nonatomic, strong) UIImageView *headImageView;
//昵称
@property (nonatomic, strong) UILabel *nickNameLabel;
//推荐时间
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *rightArrow;


@end

@implementation LGCustomVipTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nickNameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.rightArrow];
        
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(viewPix(10));
            make.width.height.mas_equalTo(viewPix(50));
        }];
        [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImageView.mas_right).offset(viewPix(10));
            make.top.equalTo(self.headImageView.mas_top);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImageView.mas_right).offset(viewPix(10));
            make.bottom.equalTo(self.headImageView.mas_bottom);
        }];
        [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-viewPix(10));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(6);
            make.height.mas_equalTo(12);
        }];
        
    }
    return self;
}
#pragma mark--setter---
- (void)setUserModel:(LGMyUserModel *)userModel {
    _userModel = userModel;
    NSString *imageUrl = userModel.headpic;
    imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    self.nickNameLabel.text = userModel.userName;
    self.timeLabel.text = userModel.createTime;
}

#pragma mark--lazy-----
- (UIImageView *)headImageView {
    
    if (!_headImageView) {
        
        _headImageView = [[UIImageView alloc]init];
    }
    return _headImageView;
}
- (UILabel *)nickNameLabel {
    
    if (!_nickNameLabel) {
        
        _nickNameLabel = [[UILabel alloc]init];
        _nickNameLabel.textColor = RGB(66, 62, 62);
        _nickNameLabel.text = @"麦田里";
        _nickNameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nickNameLabel;
}
- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = RGB(66, 62, 62);
        _timeLabel.text = @"2018-9-20";
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}
- (UIImageView *)rightArrow {
    
    if (!_rightArrow) {
        
        _rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"you"]];
    }
    return _rightArrow;
}
@end
