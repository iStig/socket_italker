//
//  ITalkerTextChatContent.h
//  iTalker
//
//  Created by tuyuanlin on 12-9-27.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerBaseChatContent.h"

@interface ITalkerTextChatContent : ITalkerBaseChatContent

- (id)initWithData:(NSData *)data;

- (id)initWithString:(NSString *)str;

@property (readonly, nonatomic) NSString * text;

@end
