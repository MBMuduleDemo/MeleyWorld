//
//  LGActiveDetailTopView.m
//  meyley
//
//  Created by mac on 2018/8/6.
//  Copyright © 2018年 Meyley. All rights reserved.
//  top--倒计时

#import "LGActiveDetailTopView.h"

@interface LGActiveDetailTopView()

@property (nonatomic , strong)UIImageView *bgImageView;
@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UILabel *dayLabel;
@property (nonatomic , strong)UILabel *hourLabel;
@property (nonatomic , strong)UILabel *minuteLabel;
@property (nonatomic , strong)UILabel *secondLabel;
@property (nonatomic , strong)UILabel *dayUnit;
@property (nonatomic , strong)UILabel *hourUnit;
@property (nonatomic , strong)UILabel *minuteUnit;
@property (nonatomic , strong)UILabel *secondUnit;

@property (nonatomic, strong) NSTimer *timer;


@end

@implementation LGActiveDetailTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatSubView];
    }
    return self;
}

-(void)setEndTime:(NSString *)endTime{
    _endTime = endTime;
    if (endTime.length>0) {
        if (!_timer) {
            [self startCountdown];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startCountdown) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
        
    }
}

-(void)startCountdown{
    [self expireDatetimeWithEndTime:[self.endTime integerValue]];
}

-(void)expireDatetimeWithEndTime:(NSInteger)endTime{
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSInteger timeDifference = endTime - nowTime;
    NSInteger day = timeDifference/(3600*24);
    NSInteger hour = (timeDifference/3600)%24;
    NSInteger minute = (timeDifference/60)%60;
    NSInteger second = timeDifference%60;
    self.dayLabel.text = [NSString stringWithFormat:@"%ld",day];
    self.hourLabel.text = [NSString stringWithFormat:@"%ld",hour];
    self.minuteLabel.text = [NSString stringWithFormat:@"%ld",minute];
    self.secondLabel.text = [NSString stringWithFormat:@"%ld",second];
}


#pragma mark -- 创建控件
-(void)creatSubView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.dayLabel];
    [self addSubview:self.hourLabel];
    [self addSubview:self.minuteLabel];
    [self addSubview:self.secondLabel];
    [self addSubview:self.dayUnit];
    [self addSubview:self.hourUnit];
    [self addSubview:self.minuteUnit];
    [self addSubview:self.secondUnit];
    __weak typeof(self) weakSelf = self;
//    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(weakSelf);
//        make.height.equalTo(@(viewPix(115)));
//    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf).offset(viewPix(10));
    }];
    
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(viewPix(5));
        make.left.equalTo(weakSelf).offset(viewPix(120));
        make.width.height.equalTo(@(viewPix(20)));
    }];
    [self.dayUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.dayLabel);
        make.left.equalTo(weakSelf.dayLabel.mas_right);
    }];
    [self.hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(weakSelf.dayLabel);
        make.left.equalTo(weakSelf.dayUnit.mas_right);
    }];
    [self.hourUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.dayLabel);
        make.left.equalTo(weakSelf.hourLabel.mas_right);
    }];
    [self.minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(weakSelf.dayLabel);
        make.left.equalTo(weakSelf.hourUnit.mas_right);
    }];
    [self.minuteUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.dayLabel);
        make.left.equalTo(weakSelf.minuteLabel.mas_right);
    }];
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(weakSelf.dayLabel);
        make.left.equalTo(weakSelf.minuteUnit.mas_right);
    }];
    [self.secondUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.dayLabel);
        make.left.equalTo(weakSelf.secondLabel.mas_right);
    }];
    
}

-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lableWithFrame:CGRectZero text:@"距活动结束时间" textColor:RGB(35, 34, 34) font:13 textAlignment:NSTextAlignmentCenter lines:1];
    }
    return _titleLabel;
}

-(UILabel *)dayLabel{
    if (!_dayLabel) {
        _dayLabel = [UILabel lableWithFrame:CGRectZero text:@"0" textColor:[UIColor whiteColor] font:12 textAlignment:NSTextAlignmentCenter lines:1];
        _dayLabel.backgroundColor = [UIColor redColor];
        _dayLabel.cornerRidus = viewPix(5);
    }
    return _dayLabel;
}
-(UILabel *)hourLabel{
    if (!_hourLabel) {
        _hourLabel = [UILabel lableWithFrame:CGRectZero text:@"00" textColor:[UIColor whiteColor] font:12 textAlignment:NSTextAlignmentCenter lines:1];
        _hourLabel.backgroundColor = [UIColor redColor];
        _hourLabel.cornerRidus = viewPix(5);
    }
    return _hourLabel;
}
-(UILabel *)minuteLabel{
    if (!_minuteLabel) {
        _minuteLabel = [UILabel lableWithFrame:CGRectZero text:@"00" textColor:[UIColor whiteColor] font:12 textAlignment:NSTextAlignmentCenter lines:1];
        _minuteLabel.backgroundColor = [UIColor redColor];
        _minuteLabel.cornerRidus = viewPix(5);
    }
    return _minuteLabel;
}
-(UILabel *)secondLabel{
    if (!_secondLabel) {
        _secondLabel = [UILabel lableWithFrame:CGRectZero text:@"00" textColor:[UIColor whiteColor] font:12 textAlignment:NSTextAlignmentCenter lines:1];
        _secondLabel.backgroundColor = [UIColor redColor];
        _secondLabel.cornerRidus = viewPix(5);
    }
    return _secondLabel;
}
-(UILabel *)dayUnit{
    if (!_dayUnit) {
        _dayUnit = [UILabel lableWithFrame:CGRectZero text:@"天" textColor:RGB(146, 143, 143) font:12 textAlignment:NSTextAlignmentCenter lines:1];
    }
    return _dayUnit;
}

-(UILabel *)hourUnit{
    if (!_hourUnit) {
        _hourUnit = [UILabel lableWithFrame:CGRectZero text:@"小时" textColor:RGB(146, 143, 143) font:12 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _hourUnit;
}
-(UILabel *)minuteUnit{
    if (!_minuteUnit) {
        _minuteUnit = [UILabel lableWithFrame:CGRectZero text:@"分" textColor:RGB(146, 143, 143) font:12 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _minuteUnit;
}
-(UILabel *)secondUnit{
    if (!_secondUnit) {
        _secondUnit = [UILabel lableWithFrame:CGRectZero text:@"秒" textColor:RGB(146, 143, 143) font:12 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _secondUnit;
}

@end
