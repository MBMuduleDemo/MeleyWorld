//
//  LGMessageTableViewCell.m
//  meyley
//
//  Created by Bovin on 2018/10/16.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGMessageTableViewCell.h"

@interface LGMessageTableViewCell ()
@property (nonatomic, strong) UIView *topBarContainer;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation LGMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.topBarContainer];
        [self.topBarContainer addSubview:self.typeLabel];
        [self.topBarContainer addSubview:self.timeLabel];
        [self.contentView addSubview:self.sepLine];
        [self.contentView addSubview:self.contentLabel];
        [self.topBarContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.height.mas_equalTo(viewPix(40));
        }];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topBarContainer.mas_centerY);
            make.left.equalTo(self.topBarContainer.mas_left).offset(viewPix(12));
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topBarContainer.mas_centerY);
            make.left.equalTo(self.typeLabel.mas_right).offset(viewPix(10));
        }];
        [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.topBarContainer.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(viewPix(12));
            make.right.equalTo(self.contentView.mas_right).offset(-viewPix(12));
            make.top.equalTo(self.sepLine.mas_bottom).offset(viewPix(5));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-viewPix(5));
        }];
    }
    return self;
}
#pragma mark--lazy----
- (UIView *)topBarContainer {
    
    if (!_topBarContainer) {
        
        _topBarContainer = [[UIView alloc]init];
    }
    return _topBarContainer;
}
- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.textColor = RGB(66, 62, 62);
        _typeLabel.text = @"魅力网";
        _typeLabel.font = [UIFont systemFontOfSize:16];
        [_typeLabel sizeToFit];
    }
    return _typeLabel;
}
- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = RGB(149, 149, 149);
        _timeLabel.text = @"2018-10-15";
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}
- (UIView *)sepLine {
    
    if (!_sepLine) {
        
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"#DBDBDB"];
    }
    return _sepLine;
}
- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = RGB(66, 62, 62);
        _contentLabel.text = @"欢迎来到魅力网，我们有各种轻奢用品供你选择欢迎来到魅力网，我们有各种轻奢用品供你选择欢迎来到魅力网，我们有各种轻奢用品供你选择欢迎来到魅力网，我们有各种轻奢用品供你选择欢迎来到魅力网，我们有各种轻奢用品供你选择";
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 3;
    }
    return _contentLabel;
}
@end
