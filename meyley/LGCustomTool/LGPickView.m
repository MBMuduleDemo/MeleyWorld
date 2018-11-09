//
//  LGPickView.m
//  haoshuimian365
//
//  Created by apple on 2017/7/17.
//  Copyright © 2017年 CYY. All rights reserved.
//

#import "LGPickView.h"
@interface LGPickView()<UIPickerViewDelegate,UIPickerViewDataSource>
/**   */
@property (nonatomic , strong)UIView *baseView;
/**   */
@property (nonatomic , strong)UIView *topView;
/**   */
@property (nonatomic , strong)UIButton *cancelBtn;
/**   */
@property (nonatomic , strong)UIButton *sureBtn;
/**   */
@property (nonatomic , strong)UIPickerView *pickView;
/**   */
@property (nonatomic , strong)UILabel *leftUnitLabel;
/**   */
@property (nonatomic , strong)UILabel *rightUnitLabel;
/**   */
@property (nonatomic , copy)NSString *result;
@end

@implementation LGPickView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBAColor(0, 0, 0, 0);
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenPickView)]];
        [self creatSubView];
        [self showPickView];
        
    }
    return self;
}
-(void)setTopColor:(UIColor *)topColor{
    _topColor = topColor;
    self.topView.backgroundColor = topColor;
}

-(void)setPickArry:(NSArray *)pickArry{
    _pickArry = pickArry;
    [self.pickView reloadAllComponents];
}

-(void)setSelectStr:(NSString *)selectStr{
    _selectStr = selectStr;
    NSArray *arry = [self.selectStr componentsSeparatedByString:@"|"];
    if (arry.count>0) {
        for (NSInteger i=0; i<arry.count; i++) {
            NSString *str = [NSString stringWithFormat:@"%@",arry[i]];
            NSArray *tempArry = self.pickArry[i];
            for (NSInteger j=0; j<tempArry.count; j++) {
                if ([[NSString stringWithFormat:@"%@",tempArry[j]] isEqualToString:str]) {
                    [self.pickView selectRow:j inComponent:i animated:NO];
                    break;
                }
            }
        }
    }
    
    [self performSelector:@selector(getResult) withObject:nil afterDelay:0.5];
}

-(void)getResult{
    NSArray *arry = [self.selectStr componentsSeparatedByString:@"|"];
    if (self.selectStr.length>0) {
        self.result = [NSString stringWithFormat:@"%@",arry[0]];
        switch (self.units.count) {
            case 0:{
                if (arry.count == 2) {
                    self.result = [NSString stringWithFormat:@"%@%@",self.result,arry[1]];
                }
            }
                break;
            case 1:{
                switch (arry.count) {
                    case 1:
                        self.result = [NSString stringWithFormat:@"%@%@",self.result,self.units[0]];
                        break;
                    case 2:
                        self.result = [NSString stringWithFormat:@"%@%@%@",self.result,self.units[0],arry[1]];
                        break;
                    default:
                        break;
                }
            }
                break;
            case 2:{
                if (arry.count == 2) {
                    self.result = [NSString stringWithFormat:@"%@%@%@%@",self.result,self.units[0],arry[1],self.units[1]];
                }
            }
                break;
            default:
                break;
        }

    }else{
        self.result = [NSString stringWithFormat:@"%@",self.pickArry[0][0]];
        switch (self.units.count) {
            case 0:
                if (self.pickArry.count == 2) {
                    self.result = [NSString stringWithFormat:@"%@%@",self.result,self.pickArry[1][0]];
                }
                break;
            case 1:
                if (self.pickArry.count == 2) {
                    self.result = [NSString stringWithFormat:@"%@%@%@",self.result,self.units[0],self.pickArry[1][0]];
                }else{
                    self.result = [NSString stringWithFormat:@"%@%@",self.result,self.units[0]];
                }
                break;
            case 2:
                if (self.pickArry.count == 2) {
                    self.result = [NSString stringWithFormat:@"%@%@%@%@",self.result,self.units[0],self.pickArry[1][0],self.units[1]];
                }
                break;
            default:
                break;
        }
    
    
    }
}

-(void)setUnits:(NSArray *)units{
    _units = units;
    switch (units.count) {
        case 0:{
            self.leftUnitLabel.hidden = YES;
            self.rightUnitLabel.hidden = YES;
        }
            break;
        case 1:{
            self.leftUnitLabel.hidden = NO;
            self.rightUnitLabel.hidden = YES;
            self.leftUnitLabel.text = [NSString stringWithFormat:@"%@",units[0]];
            NSString *str = [self.pickArry[0] lastObject];
            CGSize size = [str boundingRectWithSize:CGSizeMake(250, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:LGFont(13)} context:nil].size;
//            NSLog(@">>>%f",self.pickView.height);
            self.leftUnitLabel.center = CGPointMake(Screen_W/2.0+size.width/2.0+40*LGPercent, self.pickView.bounds.size.height/2.0+2.0*LGPercent);
//            self.leftUnitLabel.center = CGPointMake(Screen_W/2.0+size.width/2.0+40*LGPercent, 108*LGPercent);
        
        }
            break;
        case 2:{
            self.leftUnitLabel.hidden = NO;
            self.rightUnitLabel.hidden = NO;
            self.leftUnitLabel.text = [NSString stringWithFormat:@"%@",units[0]];
            self.rightUnitLabel.text = [NSString stringWithFormat:@"%@",units[1]];
            self.leftUnitLabel.center = CGPointMake(Screen_W/2.0-20*LGPercent, self.pickView.bounds.size.height/2.0+2.0*LGPercent);
            self.rightUnitLabel.center = CGPointMake(Screen_W-75*LGPercent, self.pickView.bounds.size.height/2.0+2.0*LGPercent);
//            self.leftUnitLabel.center = CGPointMake(Screen_W/2.0-20*LGPercent, 108*LGPercent);
//            self.rightUnitLabel.center = CGPointMake(Screen_W-75*LGPercent, 108*LGPercent);

        }
            break;
        default:
            break;
    }

}


-(void)sureBtnAction{
    if (self.result && self.selectStr) {
        if ([self.delegate respondsToSelector:@selector(sendPickViewResult:selectStr:)]) {
            [self.delegate sendPickViewResult:self.result selectStr:self.selectStr];
        }
    }
    
    [self hiddenPickView];

}

-(void)cancelBtnAction{
    [self hiddenPickView];

}

-(void)showPickView{
    [UIView animateWithDuration:0.3 animations:^{
        self.baseView.frame = CGRectMake(0, Screen_H-262*LGPercent-bottomSafeBarHeight, Screen_W, 262*LGPercent+bottomSafeBarHeight);
        self.backgroundColor = RGBAColor(0, 0, 0, 0.3);
    }];

}

-(void)hiddenPickView{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor =  RGBAColor(0, 0, 0, 0);
        self.baseView.frame = CGRectMake(0, Screen_H, Screen_W, 262*LGPercent+bottomSafeBarHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark---pickViewDelegate
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 43*LGPercent;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.pickArry.count;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.pickArry[component] count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.pickArry[component][row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.result = [NSString stringWithFormat:@"%@",self.pickArry[0][[pickerView selectedRowInComponent:0]]];
    switch (self.pickArry.count) {
        case 1:
            self.selectStr = self.result;
            if (self.units.count>0) {
                self.result = [NSString stringWithFormat:@"%@%@",self.result,self.units[0]];
            }
            break;
        case 2:
            self.selectStr = [NSString stringWithFormat:@"%@|%@",self.result,self.pickArry[1][[pickerView selectedRowInComponent:1]]];
            switch (self.units.count) {
                case 0:
                    self.result = [NSString stringWithFormat:@"%@%@",self.result,self.pickArry[1][[pickerView selectedRowInComponent:1]]];
                    break;
                case 1:
                    self.result = [NSString stringWithFormat:@"%@%@%@",self.result,self.units[0],self.pickArry[1][[pickerView selectedRowInComponent:1]]];
                    break;
                case 2:
                    self.result = [NSString stringWithFormat:@"%@%@%@%@",self.result,self.units[0],self.pickArry[1][[pickerView selectedRowInComponent:1]],self.units[1]];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(sendSelectResult:)]) {
        [self.delegate sendSelectResult:self.result];
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = [UIColor colorWithString:@"dedede"];
        }
    }
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc]init];
        if (self.pickArry.count>1) {
            pickerLabel.bounds = CGRectMake(0, 0, 80*LGPercent, 43*LGPercent);
            
            if (component == 0) {
                [pickerLabel setTextAlignment:NSTextAlignmentRight];
            }else{
                [pickerLabel setTextAlignment:NSTextAlignmentLeft];
            }
        }else{
            pickerLabel.bounds = CGRectMake(0, 0, Screen_W, 43*LGPercent);
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        }
        [pickerLabel setFont:[UIFont systemFontOfSize:20*LGPercent weight:UIFontWeightLight]];
        [pickerLabel setTextColor:[UIColor colorWithString:@"444444"]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark---懒加载+布局
-(void)creatSubView{
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.topView];
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.cancelBtn];
    [self.topView addSubview:self.sureBtn];
    [self.baseView addSubview:self.pickView];
    [self.pickView addSubview:self.leftUnitLabel];
    [self.pickView addSubview:self.rightUnitLabel];
}

-(UIView *)baseView{
    if(!_baseView){
        _baseView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_H, Screen_W, 262*LGPercent+bottomSafeBarHeight)];
        _baseView.backgroundColor = [UIColor whiteColor];
    }
    return _baseView;
}

-(UIView *)topView{
    if(!_topView){
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 43*LGPercent)];
        _topView.backgroundColor = [UIColor colorWithString:@"1d4793"];
    }
    return _topView;
}

-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [UILabel lableWithFrame:CGRectMake(60*LGPercent, 0, Screen_W-120*LGPercent, 43*LGPercent) text:nil textColor:[UIColor whiteColor] font:15 textAlignment:NSTextAlignmentCenter lines:1];
    }
    return _titleLabel;
}


-(UIButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, 0, 60*LGPercent, 43*LGPercent);
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(15) weight:UIFontWeightThin];
        [_cancelBtn setTitleColor:RGBAColor(255, 255, 255, 0.7) forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UIButton *)sureBtn{
    if(!_sureBtn){
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(Screen_W - 60*LGPercent, 0, 60*LGPercent, 43*LGPercent);
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(15) weight:UIFontWeightThin];
        [_sureBtn setTitleColor:RGBAColor(255, 255, 255, 0.7) forState:UIControlStateNormal];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

-(UIPickerView *)pickView{
    if(!_pickView){
        _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 43*LGPercent, Screen_W, 219*LGPercent)];
        _pickView.backgroundColor = [UIColor whiteColor];
        _pickView.dataSource = self;
        _pickView.delegate = self;
    }
    return _pickView;
}

-(UILabel *)leftUnitLabel{
    if(!_leftUnitLabel){
        _leftUnitLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:[UIColor colorWithString:@"444444"] font:13 textAlignment:NSTextAlignmentLeft lines:1];
        _leftUnitLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightThin];
        _leftUnitLabel.bounds = CGRectMake(0, 0, 60*LGPercent, 43*LGPercent);
//        _leftUnitLabel.frame = CGRectMake(0, 43*LGPercent, 60*LGPercent, 43*LGPercent);
    }
    return _leftUnitLabel;
}

-(UILabel *)rightUnitLabel{
    if(!_rightUnitLabel){
        _rightUnitLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:[UIColor colorWithString:@"444444"] font:13 textAlignment:NSTextAlignmentLeft lines:1];
        _rightUnitLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightThin];
        _rightUnitLabel.bounds = CGRectMake(0, 0, 60*LGPercent, 43*LGPercent);
//        _leftUnitLabel.frame = CGRectMake(0, 43*LGPercent, 60*LGPercent, 43*LGPercent);
    }
    return _rightUnitLabel;
}

-(void)dealloc{
    self.delegate = nil;
}


@end
