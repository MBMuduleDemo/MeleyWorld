//
//  MLLocationSelectView.h
//  meyley
//
//  Created by chsasaw on 2017/5/30.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLLocationSelectView;

@protocol MLLocationSelectViewDelegate<NSObject>

@optional
- (void)selectView:(MLLocationSelectView *)view onClickIndex:(NSInteger)index;
- (void)selectView:(MLLocationSelectView *)view onSelectProvince:(NSNumber *)provinceId city:(NSNumber *)cityId district:(NSNumber *)districtId;

@end

@interface MLLocationSelectView : UIView

@property (nonatomic, weak) IBOutlet UIButton *button1;
@property (nonatomic, weak) IBOutlet UIButton *button2;
@property (nonatomic, weak) IBOutlet UIButton *button3;

@property (nonatomic, weak) id<MLLocationSelectViewDelegate> delegate;

+ (instancetype)selectView;

- (void)setTableView:(UITableView *)tableView;

@end
