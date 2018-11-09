//
//  HXSCommunityImageCell.m
//  store
//
//  Created by  黎明 on 16/4/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <objc/runtime.h>


@interface HXSCommunityImageCell()<UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView1;
@property (nonatomic, weak) IBOutlet UIImageView *imageView2;
@property (nonatomic, weak) IBOutlet UIImageView *imageView3;
@property (nonatomic, weak) IBOutlet UIImageView *imageView4;
@property (nonatomic, weak) IBOutlet UIImageView *imageView5;
@property (nonatomic, weak) IBOutlet UIImageView *imageView6;
@property (nonatomic, weak) IBOutlet UIImageView *imageView7;
@property (nonatomic, weak) IBOutlet UIImageView *imageView8;
@property (nonatomic, weak) IBOutlet UIImageView *imageView9;

@property (nonatomic, weak) IBOutlet UIButton *arrowButton;

@property (nonatomic, strong) NSMutableArray     *totalImageViewFrameArray;

@end

@implementation HXSCommunityImageCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setClipsToBounds:YES];
    
    [self setupSubViews];
    
    [self addTapGestureRecognizer];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setPostEntity:(HXSPost *)postEntity
{
    _postEntity = postEntity;
    _totalImageViewFrameArray = [[NSMutableArray alloc]init];
    if (postEntity.dynamicsImgList.count > 3) {
        self.arrowButton.hidden = NO;
    } else {
        self.arrowButton.hidden = YES;
    }
    
    NSMutableArray *imageUrls = [NSMutableArray new];

    for (NSString *picture in postEntity.dynamicsImgList) {
        
        [imageUrls addObject:picture];
    }
    
    [self setMorePick:imageUrls];
    
    self.scrollView.contentOffset = CGPointZero;
}

- (void)addTapGestureRecognizer
{
    for (int i = 0; i < 10; i++) {
        
        NSString *imageViewStr = [NSString stringWithFormat:@"_imageView%d", i];
        
        Ivar ivar = class_getInstanceVariable([self class], [imageViewStr UTF8String]);
        
        id imageViewObj = object_getIvar(self, ivar);
        
        UIImageView *imageView = (UIImageView *)imageViewObj;
        
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *taggr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheImageView:)];
        [imageView addGestureRecognizer:taggr];
    }
}

- (void)setupSubViews
{
    for (UIImageView *imageView in self.contentView.subviews) {
        if([imageView isKindOfClass:[UIImageView class]]) {
            imageView.clipsToBounds = YES;
        }
    }
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

/**
 *  设置多种图片
 *
 *  @param imageUrls 图片url
 */
- (void)setMorePick:(NSArray *)imageUrls
{
    for (int i = 0; i < 9; i++) {
        
        NSString *imageViewStr = [NSString stringWithFormat:@"_imageView%d", (i + 1)];
        
        Ivar ivar = class_getInstanceVariable([self class], [imageViewStr UTF8String]);
        
        id imageViewObj = object_getIvar(self, ivar);
        
        UIImageView *imageView = (UIImageView *)imageViewObj;
        
        if(i<imageUrls.count) {
            [self.totalImageViewFrameArray addObject:imageView];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrls[i]]
                         placeholderImage:[UIImage imageNamed:@"img_loading_picturebig"]];
            imageView.hidden = NO;
        } else {
            imageView.hidden = YES;
        }
    }
}


#pragma mark -

+ (CGFloat)getCellHeightWithImagesCount:(NSInteger)imagesCount
{
    if (imagesCount == 0) {
        
        return 0;
        
    }
    
    float imageHight = (SCREEN_WIDTH - 32) / 3 + 4;

    return imageHight;
}

/**
 *  图片点击
 *
 */
- (void)tapTheImageView:(UITapGestureRecognizer *)sender
{
    NSInteger tag = [[sender view] tag];
    
    NSMutableArray *uploadImageEntitys = [[NSMutableArray alloc]init];
    
    for (int i = 0; i< [self.postEntity.dynamicsImgList count]; i++) {
        NSString *image = self.postEntity.dynamicsImgList[i];
        HXSCommunitUploadImageEntity *uploadImageEntity = [[HXSCommunitUploadImageEntity alloc]init];
        uploadImageEntity.urlStr = image;
        if(i < _totalImageViewFrameArray.count)
        {
            uploadImageEntity.imageView =self.totalImageViewFrameArray[i];
        }
        [uploadImageEntitys addObject:uploadImageEntity];
    }
    
    if (self.showImages) {
        UIImageView *imageView = (UIImageView *)sender.view;
        self.showImages(uploadImageEntitys,tag == 0 ? 0 : tag - 1,imageView);
    }
}


@end
