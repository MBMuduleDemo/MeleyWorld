//
//  LGGoodsDetailBottomView.m
//  meyley
//
//  Created by Bovin on 2018/8/27.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGGoodsDetailBottomView.h"
#import "HXSUserInfo.h"
#import "MLWaiterModel.h"
@implementation LGGoodsDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(229, 229, 229);
        [self creatSubView];
    }
    return self;
}


#pragma mark -- 懒加载
-(void)creatSubView{
//    [self addSubview:self.collectBtn];
    [self addSubview:self.kefuBtn];
    [self addSubview:self.commentBtn];
    [self addSubview:self.shopCartBtn];
    [self addSubview:self.addBtn];
    __weak typeof(self) weakSelf = self;
    [self.kefuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf).offset(1.0);
        make.width.equalTo(@(viewPix(55)));
    }];
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf.kefuBtn.mas_right).offset(1.0);
        make.top.width.equalTo(weakSelf.kefuBtn);
    }];
    [self.shopCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf.commentBtn.mas_right).offset(1.0);
        make.width.equalTo(weakSelf.addBtn.mas_width);
    }];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf.shopCartBtn.mas_right);
    }];
    
}

//-(MBButton *)collectBtn{
//    if (!_collectBtn) {
//        _collectBtn = [MBButton buttonWithType:UIButtonTypeCustom];
//        [_collectBtn setImage:[UIImage imageNamed:@"collectNormal"] forState:UIControlStateNormal];
//        [_collectBtn setImage:[UIImage imageNamed:@"collectSelect"] forState:UIControlStateSelected];
//        [_collectBtn setTitleColor:RGB(149, 149, 149) forState:UIControlStateNormal];
//        [_collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
//        _collectBtn.type = MBButtonTypeTopImageBottomTitle;
//        _collectBtn.backgroundColor = [UIColor whiteColor];
//        _collectBtn.titleLabel.font = LGFont(10);
//        
//    }
//    return _collectBtn;
//}

-(MBButton *)kefuBtn{
    if (!_kefuBtn) {
        _kefuBtn = [MBButton buttonWithType:UIButtonTypeCustom];
        MLWaiterModel *model = [HXSUserAccount currentAccount].userInfo.myWaiter;
        if (model) {
            [_kefuBtn sd_setImageWithURL:[NSURL URLWithString:model.headPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"42"]];
            [_kefuBtn setTitle:[NSString stringWithFormat:@"%@",model.waiterName] forState:UIControlStateNormal];
        }else {
            [_kefuBtn setImage:[UIImage imageNamed:@"42"] forState:UIControlStateNormal];
            [_kefuBtn setTitle:@"客服" forState:UIControlStateNormal];
        }
        [_kefuBtn setTitleColor:RGB(66, 62, 62) forState:UIControlStateNormal];
        _kefuBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        _kefuBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 15, 10);
        _kefuBtn.type = MBButtonTypeTopImageBottomTitle;
        _kefuBtn.backgroundColor = [UIColor whiteColor];
        _kefuBtn.titleLabel.font = LGFont(12);
    }
    return _kefuBtn;
}
-(MBButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [MBButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setImage:[UIImage imageNamed:@"mlw-ly"] forState:UIControlStateNormal];
        [_commentBtn setTitleColor:RGB(66, 62, 62) forState:UIControlStateNormal];
        [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        _commentBtn.type = MBButtonTypeTopImageBottomTitle;
        _commentBtn.backgroundColor = [UIColor whiteColor];
        _commentBtn.titleLabel.font = LGFont(12);

    }
    return _commentBtn;
}
-(MBButton *)shopCartBtn{
    if (!_shopCartBtn) {
        _shopCartBtn = [MBButton buttonWithType:UIButtonTypeCustom];
        [_shopCartBtn setBackgroundColor:ML_BG_MAIN_COLOR];
        [_shopCartBtn setTitleColor:RGB(66, 62, 62) forState:UIControlStateNormal];
        [_shopCartBtn setTitle:@"购物车" forState:UIControlStateNormal];
        _shopCartBtn.type = MBButtonTypeTopImageBottomTitle;
        _shopCartBtn.titleLabel.font = LGFont(15);
        _shopCartBtn.spaceMargin = viewPix(3);
    }
    return _shopCartBtn;
}


-(UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"addGoodsBG"] forState:UIControlStateNormal];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"addGoodsBG"] forState:UIControlStateHighlighted];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        _addBtn.backgroundColor = [UIColor whiteColor];
        _addBtn.titleLabel.font = LGFont(15);
    }
    return _addBtn;
}


@end
