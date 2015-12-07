//
//  ITalkerTextChatContent.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-27.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerTextChatContent.h"
#import "ITalkerNetworkUtils.h"

@implementation ITalkerTextChatContent

- (id)init
{
    self = [super init];
    if (self) {
        self.contentType = ITalkerChatContentTypeText;
    }
    
    return self;
}

- (id)initWithData:(NSData *)data
{
    self = [self init];
    if (self) {
        [self deserialize:data];
    }
    return self;
}

- (id)initWithString:(NSString *)str
{
    self = [self init];
    if (self) {
        _text = str;
    }
    return self;
}

- (NSInteger)deserialize:(NSData *)data
{
    NSInteger superLen = [super deserialize:data];
    NSInteger length = 0;
    
    _text = [ITalkerNetworkUtils decodeStringByNetworkData:data From:superLen AndLength:&length];

    return superLen + length;
}

- (NSData *)serialize
{
    __autoreleasing NSMutableData * serializeData = [[NSMutableData alloc] init];
    [serializeData appendData:[super serialize]];
    [serializeData appendData:[ITalkerNetworkUtils encodeNetworkDataByString:_text]];
    
    return serializeData;
}

@end
