//
//  HXSCommunityImageCell.h
//  store
//
//  Created by  黎明 on 16/4/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//
//*******************************************************************/
//根据图片的张数计算高度   count/3==0?count/3:count/3+1
//*******************************************************************/


#import <UIKit/UIKit.h>
#import "HXSPost.h"
#import "HXSCommunitUploadImageEntity.h"

@interface HXSCommunityImageCell : UITableViewCell

@property (nonatomic, strong) HXSPost *postEntity;

/**
 *  点击图片显示的回调
 */
@property (nonatomic, copy) void (^showImages)(NSMutableArray<HXSCommunitUploadImageEntity *> *images,NSInteger index,UIImageView *imageView);

/**
 *  根据图片的张数返回Cell的高度
 *
 *  @param imagesCount 图片张数
 *
 *  @return 高度
 */
+ (CGFloat)getCellHeightWithImagesCount:(NSInteger)imagesCount;

@end
