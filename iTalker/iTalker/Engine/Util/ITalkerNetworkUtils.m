//
//  ITalkerUtils.m
//  iTalker
//
//  Created by tuyuanlin on 12-10-9.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerNetworkUtils.h"

@implementation ITalkerNetworkUtils

+ (NSData *)encodeNetworkDataByData:(NSData *)data
{
    if (data == nil) {
        return  nil;
    }
    
    __autoreleasing NSMutableData * retData = [[NSMutableData alloc] init];
    NSInteger len = [data length];
    
    [retData appendBytes:&len length:sizeof(NSInteger)];
    [retData appendData:data];
    
    return retData;
}

+ (NSData *)encodeNetworkDataByString:(NSString *)string
{
    NSData * strData = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [ITalkerNetworkUtils encodeNetworkDataByData:strData];
}

+ (NSData *)encodeNetworkDataByInt:(NSInteger)intValue
{
    NSString * string = [NSString stringWithFormat:@"%d", intValue];
    return [ITalkerNetworkUtils encodeNetworkDataByString:string];
}

+ (NSData *)decodeDataByNetworkData:(NSData *)data From:(NSInteger)pos AndLength:(NSInteger *)length
{
    NSInteger len = [self decodeLengthByNetworkData:data From:pos AndLength:nil];;
    
    if (len < 0 || [data length] < len + sizeof(NSInteger)) {
        return nil;
    }
    
    if (length != nil) {
        *length = len + sizeof(NSInteger);
    }
    
    NSRange range = NSMakeRange(pos + sizeof(NSInteger), len);
    return [data subdataWithRange:range];
}

+ (NSString *)decodeStringByNetworkData:(NSData *)data From:(NSInteger)pos AndLength:(NSInteger *)length
{
    NSData * strData = [ITalkerNetworkUtils decodeDataByNetworkData:data From:pos AndLength:length];
    if (strData == nil) {
        return nil;
    }
    
    __autoreleasing NSString * str = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    return str;
}

+ (NSInteger)decodeIntByNetworkData:(NSData *)data From:(NSInteger)pos AndLength:(NSInteger *)length
{
    NSString * str = [ITalkerNetworkUtils decodeStringByNetworkData:data From:pos AndLength:length];
    if (str == nil) {
        return -1;
    }
    
    return [str integerValue];
}

+ (NSInteger)decodeLengthByNetworkData:(NSData *)data From:(NSInteger)pos AndLength:(NSInteger *)length
{
    if (data.length < pos + sizeof(NSInteger)) {
        return -1;
    }
    
    if (length != nil) {
        *length = sizeof(NSInteger);
    }
    
    NSInteger len;
    NSRange startRange = NSMakeRange(pos, sizeof(NSInteger));
    [data getBytes:&len range:startRange];

    return len;
}

@end
