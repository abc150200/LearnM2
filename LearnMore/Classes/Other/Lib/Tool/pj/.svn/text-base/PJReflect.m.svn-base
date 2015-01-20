//
//  PJReflect.m
//
//
//  Created by pj on 14-8-8.
//  Copyright (c) 2014年 pj. All rights reserved.
//

#import "PJReflect.h"
#import "PJFiled.h"
#import <objc/runtime.h>
#import <Foundation/NSObjCRuntime.h>
@implementation PJReflect

// 将nsarray(dictionary)转换为nsarry(object)
+ (NSArray *)reflexArray:(NSArray *)arry object:(id)object
{
    NSMutableArray *mArray = [[NSMutableArray array] init];
    for (int i = 0; i < arry.count; i++) {
        id obj = [[[object class] alloc] init];
        [self reflex:arry[i] object:obj];
        [mArray addObject:obj];
    }
    return mArray;
}


+ (NSArray*)getFiled:(id)p
{
    NSMutableArray *arryFiled = [NSMutableArray array];
    Class cls = [p class];
    unsigned int ivarsCnt = 0;
    //　获取类成员变量列表，ivarsCnt为类成员数量
    Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);
    //　遍历成员变量列表，其中每个变量都是Ivar类型的结构体
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        PJFiled *pFiled = [[PJFiled alloc] init];
        Ivar const ivar = *p;
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        pFiled.argName = key;
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        pFiled.type = type;
        [arryFiled addObject:pFiled];
    }
    return arryFiled;
}

+ (void)reflexArray:(NSArray *)ar object:(id)object pjFiled:(PJFiled*)field
{
    if (![ar isKindOfClass:[NSArray class]]) {
        // 不是集合
        return;
    }
    NSString *methodName = [NSString stringWithFormat:@"%@1",field.argName];
    SEL selector = NSSelectorFromString(methodName);
    if ([object respondsToSelector:selector]) {
    
    NSString *className = [object performSelector:selector];
    NSMutableArray *arObj = [NSMutableArray array];
    for (int j = 0; j < ar.count; j++) {
        // 如果你还是NSARRAY
        id obj = [NSClassFromString(className) alloc];
        [self reflex:ar[j] object:obj];
        [arObj addObject:obj];
    }
    [object setValue:arObj forKey:field.argName];
    }else
    {
        // 如果木有实现
        [object setValue:ar forKey:field.argName];
    }
}


+ (id)reflex:(NSDictionary *)dict object:(id)object
{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        // 不是集合
        return nil;
    }
    // 1.先循环变量
    NSArray* array = [self getFiled:object];
    // 然后开始遍历
    // 先遍历dict??还是先遍历我们的对象呢??遍历对象把
    for (int i = 0; i < array.count; i++) {
        PJFiled *f = array[i];
        if (f.isBase == NO) {
            // 赋值
            if (nil == dict[f.argName]) {
                continue;
            }
            // 我们在这里判断是否是NSArray类型
            if ([f.type isEqualToString: @"NSArray"] && [dict[f.argName] isKindOfClass :[NSArray class]]) {
                [self reflexArray:dict[f.argName] object:object pjFiled:f];
            }else
            {
                [object setValue:dict[f.argName] forKey:f.argName];
                }
        }else
        {
            id obj = [NSClassFromString(f.type) alloc];
            if (dict[f.argName] == nil) {
                continue;
            }
            [object setValue:obj forKey:f.argName];
            [self reflex:dict[f.argName] object:obj];
        }
    }
    return object;
}


+ (NSString*)unDict:(id)obj
{
    NSMutableString *dictStr = [[NSMutableString alloc] init];
    [dictStr appendFormat:@"@{"];
    
    // 先得到所有的字段
    NSArray *fields = [self getFiled:obj];
    for (int i = 0; i < fields.count; i++) {
        // 得到普通属性字段
        PJFiled *f = fields[i];
        if (f.isBase == NO) {
            
            // 如果是NSArray
            if ([f.type isEqualToString: @"NSArray"]) {
                NSLog(@"\r\n");
                
                
                
                [dictStr appendFormat:@"@\"%@\"",f.argName];
                [dictStr appendFormat:@":"];
                
                [dictStr appendFormat:@"@["];
                // for循环
                NSArray *ary = [obj valueForKey:f.argName];
                for (int j = 0; j < ary.count; j++) {
                    [dictStr appendFormat:[self unJson:ary[i]]];
                    [dictStr appendFormat:j==ary.count-1?@"":@","];
                }
                [dictStr appendFormat:@"]"];
                
                NSLog(@"\r\n");
            }else
            {
                // 打印
                [dictStr appendFormat:@"@\"%@\"",f.argName];
                [dictStr appendFormat:@":"];
                // 我们这里还木有判断是否为NULL
                [dictStr appendFormat:@"@\"%@\"",[obj valueForKey:f.argName]];
            }
            
            
        }else
        {
            // 如果是自定义对象
            id tempObj = [obj valueForKey:f.argName];
            NSLog(@"\r\n");
            [dictStr appendFormat:@"@\"%@\"",f.argName];
            [dictStr appendFormat:@":"];
            [dictStr appendFormat:[self unJson:tempObj]];
            NSLog(@"\r\n");
        }
        
        [dictStr appendFormat:i==fields.count-1?@"":@","];
        
    }
    [dictStr appendFormat:@"}"];
    
    return dictStr;
}



+ (NSString*)unJson:(id)obj
{
    NSMutableString *dictStr = [[NSMutableString alloc] init];
    [dictStr appendFormat:@"{"];
    
    // 先得到所有的字段
    NSArray *fields = [self getFiled:obj];
    for (int i = 0; i < fields.count; i++) {
        // 得到普通属性字段
        PJFiled *f = fields[i];
        if (f.isBase == NO) {
            
            // 如果是NSArray
            if ([f.type isEqualToString: @"NSArray"]) {
                NSLog(@"\r\n");
                
                
                
                [dictStr appendFormat:@"\"%@\"",f.argName];
                [dictStr appendFormat:@":"];
                
                [dictStr appendFormat:@"["];
                // for循环
                NSArray *ary = [obj valueForKey:f.argName];
                for (int j = 0; j < ary.count; j++) {
                    [dictStr appendFormat:[self unJson:ary[i]]];
                    [dictStr appendFormat:j==ary.count-1?@"":@","];
                }
                [dictStr appendFormat:@"]"];
                
                NSLog(@"\r\n");
            }else
            {
                // 打印
                [dictStr appendFormat:@"\"%@\"",f.argName];
                [dictStr appendFormat:@":"];
                [dictStr appendFormat:@"\"%@\"",[obj valueForKey:f.argName]];
            }
            
            
        }else
        {
            // 如果是自定义对象
            id tempObj = [obj valueForKey:f.argName];
            NSLog(@"\r\n");
            [dictStr appendFormat:@"\"%@\"",f.argName];
            [dictStr appendFormat:@":"];
            [dictStr appendFormat:[self unJson:tempObj]];
            NSLog(@"\r\n");
        }
        
        [dictStr appendFormat:i==fields.count-1?@"":@","];
        
    }
    [dictStr appendFormat:@"}"];
    
    return dictStr;
}



@end
