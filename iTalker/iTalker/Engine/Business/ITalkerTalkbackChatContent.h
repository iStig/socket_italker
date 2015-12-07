//
//  ITalkerTalkbackChatContent.h
//  iTalker
//
//  Created by tuyuanlin on 12-10-11.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerVoiceChatContent.h"

#define kITalkerFirstTalkbackContentIndex            0
#define kITalkerLastTalkbackContentIndex             NSIntegerMax

@interface ITalkerTalkbackChatContent : ITalkerVoiceChatContent

@property (nonatomic) NSInteger contentIndex;

@end
