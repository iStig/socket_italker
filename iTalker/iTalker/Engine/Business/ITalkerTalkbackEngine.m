//
//  ITalkerTalkbackEngine.m
//  iTalker
//
//  Created by tuyuanlin on 12-10-11.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerTalkbackEngine.h"
#import "ITalkerTalkbackChatContent.h"
#import "ITalkerVoiceFileManager.h"
#import "ITalkerChatEngine.h"
#import "ITalkerUserInfo.h"

@implementation ITalkerTalkbackEngine

- (id)init
{
    self = [super init];
    if (self) {
        _voiceContentArray = [[NSMutableArray alloc] init];
        _state = ITalkerTalkbackIdleState;
        [[ITalkerVoiceEngine getInstance] setVoiceDelegate:self];
        _contentIndexCount = 0;
    }
    return self;
}

- (void)addVoiceContent:(ITalkerTalkbackChatContent *)newContent
{
    NSInteger i = 0;
    NSLog(@"addVoiceContent %d", newContent.contentIndex);
    for (; i < [_voiceContentArray count]; ++i) {
        ITalkerTalkbackChatContent * content = [_voiceContentArray objectAtIndex:i];
        if (content.contentIndex > newContent.contentIndex) {
            break;
        }
    }
    
    [_voiceContentArray insertObject:newContent atIndex:i];
}

- (void)startTalk:(ITalkerUserInfo *)chatTo
{
    if (_state != ITalkerTalkbackIdleState) {
        return;
    }
    
    _contentIndexCount = 0;
    _state = ITalkerTalkbackRecordState;
    _chatToUserInfo = chatTo;
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    [[ITalkerChatEngine getInstance] startChatWith:chatTo];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runStateLoop) userInfo:nil repeats:YES];
    [[ITalkerVoiceEngine getInstance] recordVoice];
}

- (void)stopTalk
{
    _state = ITalkerTalkbackSendState;
    _contentIndexCount = kITalkerLastTalkbackContentIndex;
    [self doRecordVoice];
}

- (void)play
{
    if (_state != ITalkerTalkbackIdleState) {
        return;
    }
    
    _state = ITalkerTalkbackPlayState;
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }

    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runStateLoop) userInfo:nil repeats:YES];
}

- (void)runStateLoop
{
    if (_state == ITalkerTalkbackRecordState || _state == ITalkerTalkbackRecordAndSendState) {
        [self doRecordVoice];
        _contentIndexCount ++;
        
        if (_state == ITalkerTalkbackRecordState && [_voiceContentArray count] > 0) {
            _state = ITalkerTalkbackRecordAndSendState;
        }
    }
    
    if ((_state == ITalkerTalkbackRecordAndSendState || _state == ITalkerTalkbackSendState) && [_voiceContentArray count] > 0) {
        ITalkerTalkbackChatContent * content = (ITalkerTalkbackChatContent *)[_voiceContentArray objectAtIndex:0];
        [[ITalkerChatEngine getInstance] talk:content ToUser:_chatToUserInfo];
        NSLog(@"send content %d", content.contentIndex);
        [_voiceContentArray removeObjectAtIndex:0];
        if (content.contentIndex == kITalkerLastTalkbackContentIndex) {
            _state = ITalkerTalkbackIdleState;
            _chatToUserInfo = nil;
        }
    }
    
    if (_state == ITalkerTalkbackPlayState && [_voiceContentArray count] > 0) {
        [self doPlayVoice];
        [_timer invalidate];
        _timer = nil;
    }
    
    if (_state == ITalkerTalkbackSendState && [_voiceContentArray count] == 0) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)doRecordVoice
{
    ITalkerVoiceEngine * voiceEngine = [ITalkerVoiceEngine getInstance];
    ITalkerVoiceRecordId recordId = [voiceEngine stopRecordVoice];
    
    if (_contentIndexCount != kITalkerLastTalkbackContentIndex) {
        [voiceEngine recordVoice];
    }
    
    ITalkerTalkbackChatContent * content = [[ITalkerTalkbackChatContent alloc] initWithVoiceFileName:[[ITalkerVoiceFileManager getInstance] getFileNameById:recordId]];
    
    content.contentIndex = _contentIndexCount;
    
    [_voiceContentArray addObject:content];
    
    NSLog(@"record content %d", content.contentIndex);
}

- (void)doPlayVoice
{
    if (_state == ITalkerTalkbackPlayState && [_voiceContentArray count] > 0) {
        ITalkerTalkbackChatContent * content = [_voiceContentArray objectAtIndex:0];
        [[ITalkerVoiceEngine getInstance] playVoiceByData:content.voiceData];
        [_voiceContentArray removeObjectAtIndex:0];
        
        if (content.contentIndex == kITalkerLastTalkbackContentIndex) {
            _state = ITalkerTalkbackIdleState;
        }
    }
}

- (void)handleVoiceEvent:(ITalkerVoiceEvent)event
{
    switch (event) {
        case ITalkerVoiceEventPlayFinished:
        {
            [self doPlayVoice];
            break;
        }
        default:
            break;
    }
}

@end
