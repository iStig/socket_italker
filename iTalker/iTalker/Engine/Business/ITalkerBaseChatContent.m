//
//  ITalkerBaseChatContent.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-26.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerBaseChatContent.h"
#import "ITalkerNetworkUtils.h"

@implementation ITalkerBaseChatContent

- (NSData *)serialize
{
    return [ITalkerNetworkUtils encodeNetworkDataByInt:_contentType];
}

- (NSInteger)deserialize:(NSData *)data
{
    NSInteger len;
    _contentType = [ITalkerNetworkUtils decodeIntByNetworkData:data From:0 AndLength:&len];
    return len;
}

@end
