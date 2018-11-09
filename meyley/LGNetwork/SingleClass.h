//
//  SingleClass.h
//  singleDemo-5.3
//
//  Created by Mac on 16/5/3.
//  Copyright © 2016年 cyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SingleClass : NSObject

+(id)shareSingleClass;

@property (nonatomic , strong) NSMutableSet *mutSet;

-(void)insertObjectWithDic:(NSDictionary *)dic;
-(void)delegateObjectWithDic:(NSDictionary *)dic;
-(BOOL)searchObjectWithDic:(NSDictionary *)dic;

@end
