//
//  ITalkerVoiceChatContent.h
//  iTalker
//
//  Created by tuyuanlin on 12-10-8.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITalkerBaseChatContent.h"

@interface ITalkerVoiceChatContent : ITalkerBaseChatContent

- (id)initWithData:(NSData *)data;

- (id)initWithVoiceFileName:(NSString *)filename;

@property (readonly, nonatomic) NSData * voiceData;

@end
