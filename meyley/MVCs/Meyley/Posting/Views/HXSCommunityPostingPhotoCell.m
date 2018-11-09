//
//  ImageTableViewCell.m
//  masony
//
//  Created by  黎明 on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HXSCommunityPostingPhotoCell.h"
#import "HXSCommunitUploadImageEntity.h"

#import <SDImageCache.h>

@interface HXSCommunityPostingPhotoCell()
@end

@implementation HXSCommunityPostingPhotoCell

#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define margin 10

static NSInteger const maxUploadPhotoNums = 9;          // 最大上传图片数量
static NSInteger const maxPhotoNumsInOneLine = 4;       // 一行最大显示数量

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //[self initSubViews];
}


- (void)initSubViews
{
    //设置默认图片 用于添加图片入口
    NSMutableArray *initArray = [NSMutableArray array];
    [self setImages:initArray];
}

/**
 *  更具图片个数 进行计算和展示
 *
 */
- (void)setupSubViewsWithImages:(NSArray *)images
{
    NSMutableArray *upLoadImages = [NSMutableArray array];
    
    [upLoadImages addObjectsFromArray:images];
    
    HXSCommunitUploadImageEntity *communitUploadImageEntity = [[HXSCommunitUploadImageEntity alloc] init];
    UIImage *image = [UIImage imageNamed:@"takePhoto"];
    [communitUploadImageEntity setDefaultImage:image];
    
    [upLoadImages insertObject:communitUploadImageEntity atIndex:upLoadImages.count];
    
    if ([upLoadImages count] > maxUploadPhotoNums) {
        [upLoadImages removeObject:communitUploadImageEntity];
    }
    
    for (UIView *view in self.subviews) {
        if(view.tag == 99) {
            [view removeFromSuperview];
        }
    }
    
    NSInteger imageCount = [upLoadImages count];

    CGFloat bgwidth = (screenWidth - 2 * margin) ;//图片背景宽度
    CGFloat imagepadding = margin;
    CGFloat imagew = (bgwidth - margin) / maxPhotoNumsInOneLine - margin;
    
    int numOfLines = (int)imageCount / maxPhotoNumsInOneLine;
    if (numOfLines == 0) {
        numOfLines = 1;
    } else if(imageCount % maxPhotoNumsInOneLine == 0){
        numOfLines = numOfLines;
    } else {
        numOfLines = numOfLines + 1;
    }
    CGFloat bgheight = numOfLines * (imagew + imagepadding) + margin;
    UIView *imageBgView = [[UIView alloc] initWithFrame:
                           CGRectMake(margin, margin, bgwidth, bgheight)];
    imageBgView.tag = 99;
    [self addSubview:imageBgView];
    
    for (int i = 0; i < imageCount; i++) {
        HXSCommunitUploadImageEntity *uploadImageEntity = upLoadImages[i];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setUserInteractionEnabled:YES];
        imageView.tag = i;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(imageViewTapAction:)];
        [imageView addGestureRecognizer:tapGestureRecognizer];
        CGFloat x,y =0 ;
        if (i < maxPhotoNumsInOneLine) {
            x = (i % maxPhotoNumsInOneLine) * (imagew + imagepadding) + margin;
            y = 0;
        } else {
            x = (i % maxPhotoNumsInOneLine) * (imagew + imagepadding) + margin;
            y = (imagew + imagepadding) * (i/maxPhotoNumsInOneLine);
        }
        
        imageView.frame = CGRectMake(x, y, imagew, imagew);
        if (uploadImageEntity.urlStr.length == 0) {
            [imageView setImage:uploadImageEntity.defaultImage];
        } else {
            [imageView sd_setImageWithURL:[NSURL URLWithString:uploadImageEntity.urlStr]];
        }
        
        [imageBgView addSubview:imageView];
        
        if((i < images.count)) {
            UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteButton setImage:[UIImage imageNamed:@"mlw-close"] forState:UIControlStateNormal];
            deleteButton.frame = CGRectMake(0, 0, 50, 50);
            [imageView addSubview:deleteButton];
            deleteButton.center = CGPointMake(imageView.frame.size.width, 0);
            [deleteButton addTarget:self action:@selector(imageViewDelete:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.cellHeight =  bgheight;

}

/**
 *  选择图片还是发布文章
 *
 */
- (void)setupSelectPhotoOrArticle:(NSArray *)images
{
    for (UIView *view in self.subviews) {
        if(view.tag == 100) {
            [view removeFromSuperview];
        }
        
        if(images.count <= 0 && view.tag == 99) {
            view.hidden = YES;
        }else {
            view.hidden = NO;
        }
    }
    
    if(images.count > 0)
        return;
    
    NSInteger imageCount = [images count];
    
    CGFloat bgwidth = (screenWidth - 2 * margin) ;//图片背景宽度
    CGFloat imagepadding = margin;
    CGFloat imagew = (bgwidth - margin) / maxPhotoNumsInOneLine - margin;
    
    int numOfLines = (int)imageCount / maxPhotoNumsInOneLine;
    if (numOfLines == 0) {
        numOfLines = 1;
    } else if(imageCount % maxPhotoNumsInOneLine == 0){
        numOfLines = numOfLines;
    } else {
        numOfLines = numOfLines + 1;
    }
    CGFloat bgheight = numOfLines * (imagew + imagepadding) + margin;
    UIView *imageBgView = [[UIView alloc] initWithFrame:
                           CGRectMake(margin, margin, bgwidth, bgheight)];
    imageBgView.tag = 100;
    [self addSubview:imageBgView];
    
    imagew = 56;
    
    UIButton * photoButton = [self buttonWithTitle:@"图片" imageName:@"mlw-dt"];
    photoButton.frame = CGRectMake(imageBgView.frame.size.width - 2 * (imagew + margin * 2), margin, imagew, imagew);
    [imageBgView addSubview:photoButton];
    [photoButton addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    //设置文字偏移：向下偏移图片高度＋向左偏移图片宽度 （偏移量是根据［图片］大小来的，这点是关键）
    photoButton.titleEdgeInsets = UIEdgeInsetsMake(photoButton.imageView.frame.size.height + 10, -photoButton.imageView.frame.size.width, 0, 0);
    //设置图片偏移：向上偏移文字高度＋向右偏移文字宽度 （偏移量是根据［文字］大小来的，这点是关键）
    photoButton.imageEdgeInsets = UIEdgeInsetsMake(-photoButton.titleLabel.bounds.size.height, 0, 0, -photoButton.titleLabel.bounds.size.width);
    
    UIButton * articleButton = [self buttonWithTitle:@"文章" imageName:@"mlw-fb"];
    articleButton.frame = CGRectMake(imageBgView.frame.size.width - (imagew + margin * 2), margin, imagew, imagew);
    [imageBgView addSubview:articleButton];
    [articleButton addTarget:self action:@selector(postingArticle) forControlEvents:UIControlEventTouchUpInside];
    //设置文字偏移：向下偏移图片高度＋向左偏移图片宽度 （偏移量是根据［图片］大小来的，这点是关键）
    articleButton.titleEdgeInsets = UIEdgeInsetsMake(articleButton.imageView.frame.size.height + 10, -articleButton.imageView.frame.size.width, 0, 0);
    //设置图片偏移：向上偏移文字高度＋向右偏移文字宽度 （偏移量是根据［文字］大小来的，这点是关键）
    articleButton.imageEdgeInsets = UIEdgeInsetsMake(-articleButton.titleLabel.bounds.size.height, 0, 0, -articleButton.titleLabel.bounds.size.width);
}

/**
 *  图片点击事件
 */
- (void)imageViewTapAction:(UITapGestureRecognizer *)sender
{
    UIImageView *imageView = (UIImageView *)sender.view;
    if (self.imageViewTapBlock) {
        self.imageViewTapBlock(imageView);
    }
}

/**
 *  图片删除事件
 */
- (void)imageViewDelete:(UIButton *)deleteButton {
    UIImageView *imageView = (UIImageView *)deleteButton.superview;
    if (self.imageViewDeleteBlock) {
        self.imageViewDeleteBlock(imageView);
    }
}

/**
 *  图片删除事件
 */
- (void)selectPhoto:(UIButton *)button {
    UIImageView *imageView = (UIImageView *)[[self viewWithTag:99]viewWithTag:_images.count - 1];
    if (self.imageViewTapBlock) {
        self.imageViewTapBlock(imageView);
    }
}

/**
 * 发表文章
 */
- (void)postingArticle {
    if(self.postArticleBlock) {
        self.postArticleBlock();
    }
}

- (void)setImages:(NSMutableArray *)images
{
    if (_images) {
        [_images removeAllObjects];
    }
    
    NSMutableArray *upLoadImages = [NSMutableArray array];
    
    [upLoadImages addObjectsFromArray:images];
    
    _images = upLoadImages;
    
    [self setupSubViewsWithImages:images];
    
    [self setupSelectPhotoOrArticle:images];
}

- (UIButton *)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName {
    UIButton * photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [photoButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [photoButton setTitle:title forState:UIControlStateNormal];
    [photoButton setTitleColor:UIColorFromRGB(0x6e6e6e) forState:UIControlStateNormal];
    [photoButton setBackgroundColor:UIColorFromRGB(0xf4f4f4)];
    [photoButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    return photoButton;
}

@end
