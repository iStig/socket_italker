//
//  ITalkerUtils.h
//  iTalker
//
//  Created by tuyuanlin on 12-10-9.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITalkerNetworkUtils : NSObject

+ (NSData *)encodeNetworkDataByData:(NSData *)data;

+ (NSData *)encodeNetworkDataByString:(NSString *)string;

+ (NSData *)encodeNetworkDataByInt:(NSInteger)intValue;

+ (NSData *)decodeDataByNetworkData:(NSData *)data From:(NSInteger)pos AndLength:(NSInteger *)length;

+ (NSString *)decodeStringByNetworkData:(NSData *)data From:(NSInteger)pos AndLength:(NSInteger *)length;

+ (NSInteger)decodeIntByNetworkData:(NSData *)data From:(NSInteger)pos AndLength:(NSInteger *)length;

+ (NSInteger)decodeLengthByNetworkData:(NSData *)data From:(NSInteger)pos AndLength:(NSInteger *)length;

@end
