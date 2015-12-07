//
//  ITalkerTalkbackEngine.h
//  iTalker
//
//  Created by tuyuanlin on 12-10-11.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ITalkerVoiceEngine.h"

@class ITalkerTalkbackChatContent;
@class ITalkerUserInfo;

typedef enum {
    ITalkerTalkbackIdleState,
    ITalkerTalkbackRecordState,
    ITalkerTalkbackRecordAndSendState,
    ITalkerTalkbackSendState,
    ITalkerTalkbackPlayState
} ITalkerTalkbackState;

@interface ITalkerTalkbackEngine : NSObject <ITalkerVoiceEngineDelegate> {
    NSMutableArray * _voiceContentArray;
    NSTimer * _timer;
    ITalkerTalkbackState _state;
    ITalkerUserInfo * _chatToUserInfo;
    NSInteger _contentIndexCount;
}

- (void)addVoiceContent:(ITalkerTalkbackChatContent *)newContent;

- (void)startTalk:(ITalkerUserInfo *)chatTo;

- (void)stopTalk;

- (void)play;

@end
