//
//  ITalkerBaseChatContent.h
//  iTalker
//
//  Created by tuyuanlin on 12-9-26.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ITalkerChatContentTypeText,
    ITalkerChatContentTypeVoice,
    ITalkerChatContentTypeImage,
    ITalkerChatContentTypeTalkback
} ITalkerChatContentType;

@interface ITalkerBaseChatContent : NSObject

- (NSData *)serialize;

- (NSInteger)deserialize:(NSData *)data;

@property (nonatomic) ITalkerChatContentType contentType;

@end
