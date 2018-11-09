//
//  LGPickView.h
//  haoshuimian365
//
//  Created by apple on 2017/7/17.
//  Copyright © 2017年 CYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGPickViewDelegate <NSObject>

-(void)sendPickViewResult:(NSString *)result selectStr:(NSString *)selectStr;

@optional
-(void)sendSelectResult:(NSString *)result;

@end

@interface LGPickView : UIView
/**   */
@property (nonatomic , assign)id <LGPickViewDelegate> delegate;
/**   */
@property (nonatomic , strong)NSArray *pickArry;
/**  默认选中 */
@property (nonatomic , copy)NSString *selectStr;
/**   */
@property (nonatomic , strong)NSArray *units;
/**   */
@property (nonatomic , strong)UILabel *titleLabel;
/**   */
@property (nonatomic , strong)UIColor *topColor;


@end
