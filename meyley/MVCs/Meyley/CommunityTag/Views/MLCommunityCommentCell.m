//
//  MLCommunityCommentCell.m
//  meyley
//
//  Created by chsasaw on 2017/4/9.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLCommunityCommentCell.h"
#import "HXSPost.h"

@interface MLCommunityCommentCell()

@property (nonatomic, weak) IBOutlet UIView *commentContentView;

@end

@implementation MLCommunityCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComments:(NSArray<HXSComment *> *)comments {
    [self.commentContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    NSArray *comm = [comments subarrayWithRange:NSMakeRange(0, MIN(4, comments.count))];
    
    UILabel *lastLabel = nil;
    for(HXSComment *comment in comm) {
        NSString *commentString = [NSString stringWithFormat:@"%@：%@", comment.commentUserName, comment.content];
        UILabel * label = [[UILabel alloc] init];
        label.text = commentString;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = UIColorFromRGB(0x6e6e6e);
        label.minimumScaleFactor = 1.0;
        label.numberOfLines = 0;
        
        [self.commentContentView addSubview:label];
        
        if(lastLabel) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastLabel.mas_left);
                make.top.equalTo(lastLabel.mas_bottom);
                make.right.equalTo(lastLabel.mas_right);
            }];
        }else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.commentContentView.mas_left);
                make.top.equalTo(self.commentContentView.mas_top).offset(3);
                make.right.equalTo(self.commentContentView.mas_right);
            }];
        }
        
//        if(comment == comments.lastObject) {
//            [label mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.equalTo(self.commentContentView.mas_bottom);
//            }];
//        }
        
        lastLabel = label;
    }
}

+ (CGFloat)getCellHeight:(NSArray<HXSComment *> *)comments {
    CGFloat height = 0;
    NSArray *comm = [comments subarrayWithRange:NSMakeRange(0, MIN(4, comments.count))];
    for(HXSComment *comment in comm) {
        NSString *commentString = [NSString stringWithFormat:@"%@：%@", comment.commentUserName, comment.content];
        CGSize size = [commentString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 32, MAXFLOAT)
                                                options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}
                                                context:nil].size;
        
        height += size.height;
    }
    return height + 10;
}

@end
