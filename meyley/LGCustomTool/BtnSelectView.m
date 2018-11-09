//
//  BtnSelectView.m
//  haoshuimian
//
//  Created by apple on 16/10/29.
//  Copyright © 2016年 CYY. All rights reserved.
//  症状选择

#import "BtnSelectView.h"

@implementation BtnSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

-(void)setDataArry:(NSArray *)dataArry
{
    _dataArry = dataArry;
    [self creatBtnWithArry:dataArry];
}


//第一种方法
- (void)creatBtnWithArry:(NSArray *)arry
{
    CGFloat width = 0;
    CGFloat height = 10*LGPercent;
    //创建button
    for (int i = 0; i < arry.count; i++) {
        NSString *status = [NSString stringWithFormat:@"%@",arry[i][@"status"]];
        NSString *nameStr = [NSString stringWithFormat:@"%@",arry[i][@"name"]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat length = [self getSizeByString:nameStr AndFontSize:13].width;
        button.frame = CGRectMake(width+15*LGPercent, height, length+10, 28*LGPercent);
        if (15*LGPercent + width + length + 10  > [[UIScreen mainScreen]bounds].size.width) {
            width = 0; //换行时将w置为0
            height = height + button.frame.size.height + 10*LGPercent;//距离父视图也变化
            button.frame = CGRectMake(15*LGPercent + width, height, length + 10, 28*LGPercent);//重设
        }
       width = button.frame.size.width + button.frame.origin.x;
        
        if ([status isEqualToString:@"current"]) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }

        button.tag = 720 + i;
        
        UIImage *normalImage = [UIImage imageNamed:@"symptomNormal"];
        CGFloat normalWidth = normalImage.size.width/2.0;
        CGFloat normalHeight = normalImage.size.height/2.0;
        
        UIImage *newNormalImage = [normalImage resizableImageWithCapInsets:UIEdgeInsetsMake(normalHeight, normalWidth, normalHeight, normalWidth) resizingMode:UIImageResizingModeStretch];
        
        UIImage *selectImage = [UIImage imageNamed:@"symptomSelect"];
        CGFloat selectWidth = normalImage.size.width/2.0;
        CGFloat selectHeight = normalImage.size.height/2.0;
        
        UIImage *newSelectImage = [selectImage resizableImageWithCapInsets:UIEdgeInsetsMake(selectHeight, selectWidth, selectHeight, selectWidth) resizingMode:UIImageResizingModeStretch];
        
        
        [button setBackgroundImage:newNormalImage forState:UIControlStateNormal];
        [button setBackgroundImage:newSelectImage forState:UIControlStateSelected];
        
        [button setTitleColor:RGBColor(204, 204, 204) forState:UIControlStateNormal];
        [button setTitleColor:RGBColor(96, 45, 200) forState:UIControlStateSelected];
        button.titleLabel.font = LGFont(12);
        [button setTitle:nameStr forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
       
        if (i == arry.count-1) {
            CGFloat viewHeight = button.frame.origin.y + button.bounds.size.height+10.0;
        
            [self.delegate sendViewHeight:viewHeight];
        }
        
    }
    
   
    
}

-(void)handleButton:(UIButton *)sender{
    NSMutableDictionary *dic = _dataArry[sender.tag-720];
    if (sender.selected == NO) {
        [dic setValue:@"current" forKey:@"status"];
    }else{
        [dic setValue:@"" forKey:@"status"];
    }
    if ([self.delegate respondsToSelector:@selector(btnSelectResult:andIndex:)]) {
        [self.delegate btnSelectResult:dic andIndex:sender.tag-720];
    }
    
    sender.selected = !sender.selected;
}

//计算文字所占大小
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:LGFont(font)} context:nil].size;
    size.width += 5;
    return size;
}

-(void)dealloc{
    self.delegate = nil;
}

@end
