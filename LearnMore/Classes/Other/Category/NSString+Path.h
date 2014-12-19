//
//  NSString+Path.h
//  02-沙盒演练
//
//  Created by 刘凡 on 14-7-9.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Path)

/** 文档目录 */
+ (NSString *)documentPath;
/** 缓存目录 */
+ (NSString *)cachePath;
/** 临时目录 */
+ (NSString *)tempPath;
/** 当前时间戳 */
+ (NSString *)timeNow;
+ (NSString *)getTimeNow;
/** 返回年月 */
+ (NSString *)timeFmtWithLong:(long)longTime;
/** 返回解析的年龄 */
+ (NSString *)ageBegin:(int)ageBegin ageEnd:(int)ageEnd;
/** 返回数字年龄(回复中用) */
+ (NSString *)timeWithLong:(long long)longTime;

/** 判断设备 */
+ (NSString*)deviceString;

/**
 *  添加文档路径
 */
- (NSString *)appendDocumentPath;
/**
 *  添加缓存路径
 */
- (NSString *)appendCachePath;
/**
 *  添加临时路径
 */
- (NSString *)appendTempPath;

@end
