//
//  LGCategoryCollectionCell.m
//  meyley
//
//  Created by Bovin on 2018/8/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGCategoryCollectionCell.h"

@interface LGCategoryCollectionCell ()

@property (nonatomic, strong) UILabel *childCategoryLabel;

@end

@implementation LGCategoryCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.childCategoryLabel];
        [self.childCategoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self);
        }];
    }
    return self;
}

-(void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    self.childCategoryLabel.text = titleText;
}

#pragma mark--lazy----
- (UILabel *)childCategoryLabel {
    
    if (!_childCategoryLabel) {
        
        _childCategoryLabel = [[UILabel alloc]init];
        _childCategoryLabel.textAlignment = NSTextAlignmentCenter;
        _childCategoryLabel.textColor = [UIColor colorWithHexString:@"#4d4d4d"];
        _childCategoryLabel.font = LGFont(12);
    }
    return _childCategoryLabel;
}
@end
