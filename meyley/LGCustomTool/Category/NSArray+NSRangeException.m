//
//  NSArray+NSRangeException.m
//  catagoryDemo
//
//  Created by Chen on 2017/1/5.
//  Copyright © 2017年 langgan. All rights reserved.
//

#import "NSArray+NSRangeException.h"
#import <objc/runtime.h>
@implementation NSArray (NSRangeException)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            
            swizzleMethod(objc_getClass("__NSArray0"), @selector(objectAtIndex:), @selector(emptyObjectIndex:));
            swizzleMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:), @selector(arrObjectIndex:));
            swizzleMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:), @selector(mutableObjectIndex:));
            swizzleMethod(objc_getClass("__NSArrayM"), @selector(insertObject:atIndex:), @selector(mutableInsertObject:atIndex:));
        }
    });
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    IMP swizzledImp = method_getImplementation(swizzledMethod);
    char *swizzledTypes = (char *)method_getTypeEncoding(swizzledMethod);
    
    IMP originalImp = method_getImplementation(originalMethod);
    
    char *originalTypes = (char *)method_getTypeEncoding(originalMethod);
    BOOL success = class_addMethod(class, originalSelector, swizzledImp, swizzledTypes);
    if (success) {
        class_replaceMethod(class, swizzledSelector, originalImp, originalTypes);
    }else {
        // 添加失败，表明已经有这个方法，直接交换
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (id)emptyObjectIndex:(NSInteger)index{
    return nil;
}

- (id)arrObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self arrObjectIndex:index];
}

- (id)mutableObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self mutableObjectIndex:index];
}

- (void)mutableInsertObject:(id)object atIndex:(NSUInteger)index{
    if (object) {
        [self mutableInsertObject:object atIndex:index];
    }
}
@end
