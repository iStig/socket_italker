//
//  ITalkerChatItem.m
//  iTalker
//
//  Created by tuyuanlin on 12-10-12.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerChatItem.h"

@implementation ITalkerChatItem

- (id)init
{
    self = [super init];
    if (self) {
        _chatContentArray = [[NSMutableArray alloc] init];
        _chatToUserInfo = nil;
        _socketId = kITalkerInvalidSocketId;
    }
    return self;
}

@end
