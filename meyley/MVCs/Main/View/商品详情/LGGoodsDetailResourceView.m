//
//  LGGoodsDetailResourceView.m
//  meyley
//
//  Created by mac on 2018/11/7.
//  Copyright © 2018年 Meyley. All rights reserved.
//  货源

#import "LGGoodsDetailResourceView.h"

@interface LGGoodsDetailResourceView()
/**   */
@property (nonatomic , strong)UILabel *titleLabel;
/**   */
@property (nonatomic , strong)NSMutableArray *btnArry;

@end


@implementation LGGoodsDetailResourceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}

-(void)setSourceArry:(NSArray *)sourceArry{
    _sourceArry = sourceArry;
    for (UIButton *btn in self.btnArry) {
        [btn removeFromSuperview];
    }
    
    CGFloat width = viewPix(80);
    NSInteger index = 1;
    for (NSInteger i=sourceArry.count-1; i>=0; i--) {
        UIButton *button = [self creatButtonWithDic:sourceArry[i] index:i];
        if (i == 0) {
            button.frame = CGRectMake(Screen_W-viewPix(10)-(width + viewPix(5))*index-viewPix(20), viewPix(8), width+viewPix(20), viewPix(29));
        }else{
            button.frame = CGRectMake(Screen_W-viewPix(10)-(width + viewPix(5))*index, viewPix(8), width, viewPix(29));
        }
        [self addSubview:button];
        [self.btnArry addObject:button];
        index++;
    }
}

-(void)selectBtnAction:(UIButton *)sender{
    NSInteger index = sender.tag-1000;
    if ([self.delegate respondsToSelector:@selector(selectResourceWithDic:)]) {
        [self.delegate selectResourceWithDic:self.sourceArry[index]];
    }
}

-(UIButton *)creatButtonWithDic:(NSDictionary *)dic index:(NSInteger)index{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor colorWithString:@"333333"] forState:UIControlStateNormal];
    [button setTitle:dic[@"title"] forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor colorWithString:@"333333"].CGColor;
    button.layer.borderWidth = 1.0;
    button.titleLabel.font = LGFont(14);
    button.backgroundColor = [UIColor whiteColor];
    if (index == 0) {
        [button setImage:[UIImage imageNamed:@"paySuccess"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, button.titleLabel.width + 2.5, 0, -button.titleLabel.width - 2.5);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.size.width, 0, button.imageView.size.width);
        // 重点位置结束
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
       
//        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -viewPix(60))];
//        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -viewPix(20), 0, 0)];
    }
    [button addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 1000+index;
    return button;
}



-(NSMutableArray *)btnArry{
    if(!_btnArry){
        _btnArry = [NSMutableArray array];
    }
    return _btnArry;
}

-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [UILabel lableWithFrame:CGRectMake(viewPix(15), 0, viewPix(70),viewPix(45)) text:@"货源：" textColor:[UIColor colorWithString:@"333333"] font:14 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _titleLabel;
}

@end
