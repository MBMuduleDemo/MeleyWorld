//
//  LGEmptyView.h
//  haoshuimian365
//
//  Created by apple on 2017/6/21.
//  Copyright © 2017年 CYY. All rights reserved.

#import <UIKit/UIKit.h>

@protocol LGEmptyViewDelegate <NSObject>

-(void)retryBtnAction;
-(void)retryBtnAction:(UIView *)view;

@end

@interface LGEmptyView : UIView

/**  距中心点的偏移量 */
@property (nonatomic , assign)CGFloat offset;
/**  图片、文字间隔 */
@property (nonatomic , assign)CGFloat margin;
/**  缓冲图片 */
@property (nonatomic , strong)UIImage *bufferImage;
/**   */
@property (nonatomic , strong)UIFont *labelFont;
/**   */
@property (nonatomic , strong)UIColor *textColor;
/**   */
@property (nonatomic , strong)UILabel *desLabel;
/**   */
@property (nonatomic , strong)UIFont  *btnFont;
/**   */
@property (nonatomic , strong)UIColor *btnTextColor;
/**   */
@property (nonatomic , strong)UIColor *btnBorderColor;
/**   */
@property (nonatomic , assign)id <LGEmptyViewDelegate> delegate;

-(void)showViewWithImageName:(NSString *)image andDes:(NSString *)des;
-(void)showFaildViewWithDes:(NSString *)des;
-(void)showViewWithDes:(NSString *)des;
-(void)startBuffer;

//添加偏移量
-(void)showViewWithImageName:(NSString *)image andDes:(NSString *)des offset:(CGFloat)offset;
-(void)showFaildViewWithDes:(NSString *)des offset:(CGFloat)offset;
-(void)showViewWithDes:(NSString *)des offset:(CGFloat)offset;
-(void)startBufferWithOffset:(CGFloat)offset;

-(void)stopBuffer;
@end
