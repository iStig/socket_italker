//
//  ITalkerTalkbackChatContent.m
//  iTalker
//
//  Created by tuyuanlin on 12-10-11.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerTalkbackChatContent.h"
#import "ITalkerNetworkUtils.h"

@implementation ITalkerTalkbackChatContent

- (id)initWithVoiceFileName:(NSString *)filename
{
    self = [super initWithVoiceFileName:filename];
    if (self) {
        self.contentType = ITalkerChatContentTypeTalkback;
    }
    return self;
}

- (id)initWithData:(NSData *)data
{
    self = [super initWithData:data];
    if (self) {
        self.contentType = ITalkerChatContentTypeTalkback;
    }
    return self;
}

- (NSData *)serialize
{
    __autoreleasing NSMutableData * serializeData = [[NSMutableData alloc] init];
    [serializeData appendData:[super serialize]];
    [serializeData appendData:[ITalkerNetworkUtils encodeNetworkDataByInt:_contentIndex]];
    return serializeData;
}


- (NSInteger)deserialize:(NSData *)data
{
    NSInteger superLen = [super deserialize:data];
    NSInteger length = 0;
    
    _contentIndex = [ITalkerNetworkUtils decodeIntByNetworkData:data From:superLen AndLength:&length];
    
    return superLen + length;
}

@end
