//
//  LGPayOrExpressTypeTableCell.m
//  meyley
//
//  Created by Bovin on 2018/10/15.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGPayOrExpressTypeTableCell.h"

@interface LGPayOrExpressTypeTableCell ()

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UILabel *tradeNoLabel;

@property (nonatomic, strong) UILabel *beginTimeLabel;

@property (nonatomic, strong) UILabel *endTimeLabel;

@end

@implementation LGPayOrExpressTypeTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.tradeNoLabel];
        [self.contentView addSubview:self.beginTimeLabel];
        [self.contentView addSubview:self.endTimeLabel];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(viewPix(12));
            make.top.equalTo(self.contentView.mas_top).offset(viewPix(6));
        }];
        [self.tradeNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.typeLabel.mas_left);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-viewPix(5));
        }];
        [self.beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-viewPix(12));
            make.centerY.equalTo(self.typeLabel.mas_centerY);
        }];
        [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.beginTimeLabel.mas_right);
            make.centerY.equalTo(self.tradeNoLabel.mas_centerY);
        }];
    }
    return self;
}
#pragma mark--setter---
- (void)setDetailModel:(LGOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    
}
#pragma mark--lazy-----
- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.textColor = RGB(66, 62, 62);
        _typeLabel.font = [UIFont systemFontOfSize:15];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _typeLabel;
}
- (UILabel *)tradeNoLabel {
    
    if (!_tradeNoLabel) {
        
        _tradeNoLabel = [[UILabel alloc]init];
        _tradeNoLabel.textColor = RGB(66, 62, 62);
        _tradeNoLabel.font = [UIFont systemFontOfSize:11];
        _tradeNoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _tradeNoLabel;
}
- (UILabel *)beginTimeLabel {
    
    if (!_beginTimeLabel) {
        
        _beginTimeLabel = [[UILabel alloc]init];
        _beginTimeLabel.textColor = RGB(149, 149, 149);
        _beginTimeLabel.font = [UIFont systemFontOfSize:11];
        _beginTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _beginTimeLabel;
}
- (UILabel *)endTimeLabel {
    
    if (!_endTimeLabel) {
        
        _endTimeLabel = [[UILabel alloc]init];
        _endTimeLabel.textColor = RGB(149, 149, 149);
        _endTimeLabel.font = [UIFont systemFontOfSize:11];
        _endTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _endTimeLabel;
}
@end
