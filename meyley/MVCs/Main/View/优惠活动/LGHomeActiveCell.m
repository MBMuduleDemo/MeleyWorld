//
//  LGHomeActiveCell.m
//  meyley
//
//  Created by mac on 2018/8/1.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGHomeActiveCell.h"

@interface LGHomeActiveCell()

@property (nonatomic , strong)UIImageView *bgImageView;
@property (nonatomic , strong)UILabel *endTimeLabel;
@property (nonatomic , strong)UILabel *titleLabel;


@end

@implementation LGHomeActiveCell

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
    self.endTimeLabel.text = [self expireDatetimeWithEndTime:[NSString stringWithFormat:@"%@",dataDic[@"endTime"]]];
}

-(NSString *)expireDatetimeWithEndTime:(NSString *)endTime{
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    
    NSInteger timeDifference = [endTime integerValue]/1000 - nowTime;
    NSInteger day = timeDifference/(3600*24);
    NSInteger hour = timeDifference%(3600*24)/3600;
    
    if (day>0) {
        return [NSString stringWithFormat:@"剩%ld天",day];
    }else{
        return [NSString stringWithFormat:@"剩%ld小时",hour];
    }
    
}

#pragma mark---创建控件
-(void)creatSubView{
    [self addSubview:self.bgImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.endTimeLabel];
    [self addSubview:self.lineView];
    __weak typeof(self) weakSelf = self;
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(viewPix(20));
        make.left.equalTo(weakSelf).offset(viewPix(20));
        make.right.equalTo(weakSelf).offset(-viewPix(20));
        make.height.equalTo(@(viewPix(160)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.bgImageView);
        make.top.equalTo(weakSelf.bgImageView.mas_bottom).offset(viewPix(15));
    }];
    
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgImageView).offset(-viewPix(17));
        make.bottom.equalTo(weakSelf.bgImageView).offset(-viewPix(16));
        make.width.equalTo(@(viewPix(65)));
        make.height.equalTo(@(viewPix(26)));
        
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
        make.left.right.equalTo(weakSelf.bgImageView);
        make.height.equalTo(@(1.0));
    }];
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

-(UILabel *)endTimeLabel{
    if (!_endTimeLabel) {
        _endTimeLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:[UIColor whiteColor] font:12 textAlignment:NSTextAlignmentCenter lines:1];
        _endTimeLabel.backgroundColor = RGBA(0, 0, 0, 0.5);
        _endTimeLabel.cornerRidus = viewPix(13);
    }
    return _endTimeLabel;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGB(234, 234, 234);
    }
    return _lineView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
