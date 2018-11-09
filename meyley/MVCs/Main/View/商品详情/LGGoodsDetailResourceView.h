//
//  LGGoodsDetailResourceView.h
//  meyley
//
//  Created by mac on 2018/11/7.
//  Copyright © 2018年 Meyley. All rights reserved.
//  货源

#import <UIKit/UIKit.h>

@protocol LGGoodsDetailResourceDelegate <NSObject>

-(void)selectResourceWithDic:(NSDictionary *)dic;

@end;

@interface LGGoodsDetailResourceView : UIView
/**   */
@property (nonatomic , assign)id <LGGoodsDetailResourceDelegate> delegate;
/**   */
@property (nonatomic , strong)NSArray *sourceArry;

@end
