//
//  ObjectTool.m
//  haoshuimian365
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 CYY. All rights reserved.
//

#import "ObjectTool.h"
@implementation ObjectTool

+ (NSDictionary*)dictionaryWithObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //定义存储属性数量的变量
    unsigned int propersCount;
    //指向属性数组的指针，可以访问数组中的所有属性，传入存储属性数量的变量的地址，该方法就会为其赋值
    objc_property_t *propers = class_copyPropertyList([obj class], &propersCount);
    //遍历属性
    for(int i = 0;i < propersCount; i++) {
        
        objc_property_t proper = propers[i];
        //获得字符串类型的属性名
        NSString *properName = [NSString stringWithUTF8String:property_getName(proper)];
        //通过KVC取得属性值
        id value = [obj valueForKey:properName];
        
        if(value == nil) {
            value = [NSNull null];
            
        } else { //如果属性值不为空，则判断属性值类型
            value = [self objectByPropertyValue:value];
        }
        [dict setObject:value forKey:properName];
    }
    return dict;
}

+ (id)objectByPropertyValue:(id)obj {
    //对NSString、NSNumber、NSNull类型的属性值不做处理，直接返回
    if([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSNull class]]) {
        return obj;
        //如果是数组类型，则遍历数组查看数组内部是否存在对象类型
    } else if([obj isKindOfClass:[NSArray class]]) {
        
        NSArray *objArray = obj;
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:objArray.count];
        for(int i = 0;i < objArray.count; i++) {
            //嵌套
            [array setObject:[self objectByPropertyValue:[objArray objectAtIndex:i]] atIndexedSubscript:i];
        }
        //返回转化后的数组
        return array;
        //字典类型
    } else if([obj isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *objDict = obj;
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[objDict count]];
        for(NSString *key in objDict.allKeys) {
            
            [dict setObject:[self objectByPropertyValue:[objDict objectForKey:key]] forKey:key];
        }
        //返回转化后的字典
        return dict;
    }
    //对象类型等
    return [self dictionaryWithObject:obj];
}



/**  将obj转换成json */
+ (NSString *)objectToJson:(id)obj{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonStr;

}

/**  将json转换成obj */
+(id)jsonToObject:(NSString *)json{
    if (json == nil || json.length == 0) {
        return nil;
    }
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return jsonObject;
}


@end
