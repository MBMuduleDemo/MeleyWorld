//
//  LGApplicationStatusView.m
//  meyley
//
//  Created by Bovin on 2018/10/25.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGApplicationStatusView.h"

@interface LGApplicationStatusView ()

@property (nonatomic, strong) UILabel *statusLabel;
//身份描述
@property (nonatomic, strong) UILabel *descLabel;
//注意事项提示
@property (nonatomic, strong) UILabel *tipsLabel;
//小提示
@property (nonatomic, strong) UILabel *careLabel;

@property (nonatomic, strong) UIButton *actionBtn;

@end

@implementation LGApplicationStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.statusLabel];
        [self addSubview:self.descLabel];
        [self addSubview:self.tipsLabel];
        [self addSubview:self.careLabel];
        [self addSubview:self.actionBtn];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).offset(viewPix(100));
        }];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusLabel.mas_bottom).offset(viewPix(80));
            make.centerX.equalTo(self.mas_centerX);
            make.left.equalTo(self.mas_left).offset(viewPix(20));
            make.right.equalTo(self.mas_right).offset(-viewPix(20));
        }];
        [self.descLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.descLabel.mas_bottom).offset(viewPix(50));
            make.centerX.equalTo(self.mas_centerX);
            make.left.equalTo(self.mas_left).offset(viewPix(20));
            make.right.equalTo(self.mas_right).offset(-viewPix(20));
        }];
        [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).offset(-viewPix(30));
            make.height.mas_equalTo(viewPix(45));
            make.width.mas_equalTo(viewPix(100));
        }];
        [self.careLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.actionBtn.mas_top).offset(-viewPix(20));
        }];
    }
    return self;
}

#pragma mark--setter---
- (void)setStatus:(LGApplicationStatus)status {
    _status = status;
    self.descLabel.hidden = NO;
    self.careLabel.hidden = NO;
    switch (status) {
        case LGApplicationStatusWaitReview:
            self.descLabel.hidden = YES;
            self.statusLabel.text = @"资料审核中...";
            self.tipsLabel.text = @"请保持联系通畅，以便我们与您取得联系\n审核将在5个工作日内完成，请耐心等待";
            [self.actionBtn setTitle:@"放弃申请" forState:UIControlStateNormal];
            break;
        case LGApplicationStatusApproved:
            self.descLabel.hidden = YES;
            self.statusLabel.text = @"申请资料通过审核！";
            self.tipsLabel.text = @"支付“平台服务费”后完成加盟，客服升级的，在升级成功后，原等级的服务费将按12个月折价后退回到你的账户\n\n(注意！平台服务费支付成功后不支持退款)";
            self.careLabel.text = @"支付加盟“网络客服”平台服务费299/年";
            [self.actionBtn setTitle:@"确认付款" forState:UIControlStateNormal];
            break;
        case LGApplicationStatusSuccessed:
            self.careLabel.hidden = YES;
            self.statusLabel.text = @"欢迎加入魅力网服务团队";
            self.descLabel.text = @"服务等级:网络客服\n有效期:2019.10.31";
            self.tipsLabel.text = @"请尊重用户的三个基本权利：1.知情权 2.选择权 3.表述权\n遵守法律法规及魅力网规章制度用自己的付出去赚取应有的回报和尊重\n祝你好运！";
            [self.actionBtn setTitle:@"升级/续费" forState:UIControlStateNormal];
            break;

        default:
            break;
    }
}
#pragma mark--action-----
- (void)actionBtnClick {
    if (self.userActionComplementBlock) {
        self.userActionComplementBlock(self.status);
    }
}
#pragma mark--lazy------
- (UILabel *)statusLabel {
    
    if (!_statusLabel) {
        
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.textColor = RGB(255, 0, 82);
        _statusLabel.font = [UIFont systemFontOfSize:16];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}
- (UILabel *)descLabel {
    
    if (!_descLabel) {
        
        _descLabel = [[UILabel alloc]init];
        _descLabel.textColor = RGB(66, 62, 62);
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}
- (UILabel *)tipsLabel {
    
    if (!_tipsLabel) {
        
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.textColor = RGB(66, 62, 62);
        _tipsLabel.font = [UIFont systemFontOfSize:14];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.numberOfLines = 0;
    }
    return _tipsLabel;
}
- (UILabel *)careLabel {
    
    if (!_careLabel) {
        
        _careLabel = [[UILabel alloc]init];
        _careLabel.textColor = RGB(66, 62, 62);
        _careLabel.font = [UIFont systemFontOfSize:12];
        _careLabel.textAlignment = NSTextAlignmentCenter;
        _careLabel.numberOfLines = 0;
    }
    return _careLabel;
}
- (UIButton *)actionBtn {
    
    if (!_actionBtn) {
        
        _actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionBtn setTitle:@"确认申请" forState:UIControlStateNormal];
        [_actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_actionBtn setBackgroundColor:RGB(255, 0, 82) forState:UIControlStateNormal];
        [_actionBtn addTarget:self action:@selector(actionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _actionBtn.layer.cornerRadius = 5;
        _actionBtn.layer.masksToBounds = YES;
    }
    return _actionBtn;
}
@end
