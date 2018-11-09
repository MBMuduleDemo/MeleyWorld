//
//  LGActiveListCell.m
//  meyley
//
//  Created by mac on 2018/8/6.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGActiveListCell.h"

@interface LGActiveListCell()
@property (nonatomic , strong)UIView *topView;
@property (nonatomic , strong)UIView *maskView;
@property (nonatomic , strong)UIView *bottomView;
@property (nonatomic , strong)UIImageView *bgImageView;
@property (nonatomic , strong)UILabel *startTimeLabel;
@property (nonatomic , strong)UILabel *endTimeLabel;
@property (nonatomic , strong)UILabel *titleLabel;

@end

@implementation LGActiveListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubView];
    }
    return self;
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    /*
     {
     actId = 11;
     actName = "\U4eca\U65e5\U7279\U60e0 |  \U978b/\U5e3d/\U8863\U670d99\U5143\U8d77";
     actStatus = 1;
     endTime = 1534262400000;
     logo = "http://www.meyley.com/upload/activity/2018072212090203887.png";
     sortOrder = "<null>";
     startTime = 1526832000000;
     userRank = 1;
     },
     */
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"actName"]];
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"logo"]]]];
    self.startTimeLabel.text = [self getStartTime:[NSString stringWithFormat:@"%@",dataDic[@"startTime"]]];
    NSString *entTime = [NSString stringWithFormat:@"%@",dataDic[@"endTime"]];
    if ([self activeCancel:entTime] == YES) {
        //活动结束
        self.maskView.hidden = NO;
        self.endTimeLabel.text = nil;
    }else{
        self.maskView.hidden = YES;
        self.endTimeLabel.text = [self expireDatetimeWithEndTime:entTime];
    }
    
}

-(BOOL)activeCancel:(NSString *)endTime{
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSInteger timeDifference = [endTime integerValue]/1000 - nowTime;
    if (timeDifference>0) {
        return NO;
    }else{
        return YES;
    }
}

-(NSString *)expireDatetimeWithEndTime:(NSString *)endTime{
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSInteger timeDifference = [endTime integerValue]/1000 - nowTime;
    NSInteger day = timeDifference/(3600*24);
    NSInteger hour = timeDifference/3600;
    if (day>0) {
        return [NSString stringWithFormat:@"剩%ld天",day];
    }else{
        return [NSString stringWithFormat:@"剩%ld小时",hour];
    }
}

-(NSString *)getStartTime:(NSString *)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue] / 1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

#pragma mark---创建控件
-(void)creatSubView{
    [self addSubview:self.topView];
    [self.topView addSubview:self.startTimeLabel];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.bgImageView];
    [self.bottomView addSubview:self.maskView];
    [self.bottomView addSubview:self.titleLabel];
    [self.bottomView addSubview:self.endTimeLabel];
    __weak typeof(self) weakSelf = self;
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf);
        make.height.equalTo(@(viewPix(50)));
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(weakSelf.bgImageView);
    }];
    
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.topView);
        make.centerY.equalTo(weakSelf.topView).offset(viewPix(5));
        make.width.equalTo(@(viewPix(100)));
        make.height.equalTo(@(viewPix(24)));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.topView.mas_bottom);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomView).offset(viewPix(20));
        make.left.equalTo(weakSelf.bottomView).offset(viewPix(20));
        make.right.equalTo(weakSelf.bottomView).offset(-viewPix(20));
        make.height.equalTo(@(viewPix(160)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.bgImageView);
        make.top.equalTo(weakSelf.bgImageView.mas_bottom).offset(viewPix(15));
    }];
    
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgImageView);
        make.centerY.equalTo(weakSelf.titleLabel);
    }];
}

-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = RGB(234, 234, 234);
    }
    return _topView;
}

-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]init];
        _maskView.backgroundColor = RGBA(0, 0, 0, 0.1);
        _maskView.hidden = YES;
        UILabel *titleLabel = [UILabel lableWithFrame:CGRectZero text:@"活动已结束" textColor:RGB(88, 88, 88) font:15 textAlignment:NSTextAlignmentCenter lines:1];
        titleLabel.backgroundColor = [UIColor whiteColor];
        [_maskView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_maskView);
            make.width.equalTo(@(viewPix(96)));
            make.height.equalTo(@(viewPix(30)));
        }];
    }
    return _maskView;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}


-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.cornerRidus = 10.0;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(51, 51, 51) font:16 textAlignment:NSTextAlignmentLeft lines:1];
        _titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
    }
    return _titleLabel;
}

-(UILabel *)startTimeLabel{
    if (!_startTimeLabel) {
        _startTimeLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:[UIColor whiteColor] font:12 textAlignment:NSTextAlignmentCenter lines:1];
        _startTimeLabel.backgroundColor = RGBA(0, 0, 0, 0.2);
        _startTimeLabel.cornerRidus = viewPix(12);
    }
    return _startTimeLabel;
}

-(UILabel *)endTimeLabel{
    if (!_endTimeLabel) {
        _endTimeLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(153, 153, 153) font:12 textAlignment:NSTextAlignmentCenter lines:1];
    }
    return _endTimeLabel;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
