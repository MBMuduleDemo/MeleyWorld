//
//  SingleClass.m
//  singleDemo-5.3
//
//  Created by Mac on 16/5/3.
//  Copyright © 2016年 cyy. All rights reserved.
//

#import "SingleClass.h"

static SingleClass *single=nil;//定义一个静态指针
@implementation SingleClass

+(id)shareSingleClass
{
   //GCD方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single=[[SingleClass alloc]init];
        
    });
//    @synchronized(self) {
//        if (single==nil) {
//            single=[[SingleClass alloc]init];
//        }
//    }//把判断写在同步块里，防止多次同时调用的时候多次alloc
    return single;
}

//初始化
-(NSMutableSet *)mutSet
{
    if (!_mutSet) {
        _mutSet = [NSMutableSet set];
    }
    return _mutSet;
}

//插入
-(void)insertObjectWithDic:(NSDictionary *)dic
{
    if (dic == nil) {
        return;
    }
    for (NSObject *obj in _mutSet) {
        if ([obj isEqual:dic]) {
            return;
        }
    }
    [self.mutSet addObject:dic];

}

-(void)delegateObjectWithDic:(NSDictionary *)dic
{
    if (dic == nil) {
        return;
    }
    for (NSObject *obj in _mutSet) {
        if ([obj isEqual:dic]) {
            [self.mutSet removeObject:dic];
            return;
        }
    }
    
}


-(BOOL)searchObjectWithDic:(NSDictionary *)dic
{
    for (NSObject *obj in _mutSet) {
        if ([obj isEqual:dic]) {
            return YES;
        }
    }
    return NO;
}



//为了防止创建的时候不用咱自己定义的这个+号方法，用alloc这个方法来创建，所以要重写一下这个方法
+(id)alloc
{
    @synchronized(self) {
        if (single==nil) {
            single=[super alloc];//不能调自身的alloc，会引起死循环
        }
    }
    return single;
}







@end
