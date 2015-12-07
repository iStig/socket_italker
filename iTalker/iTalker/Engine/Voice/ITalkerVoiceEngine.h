//
//  ITalkerVoiceEngine.h
//  iTalker
//
//  Created by tuyuanlin on 12-8-29.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "ITalkerVoiceFileManager.h"

typedef enum {
    ITalkerVoiceEventPlayFinished,
    ITalkerVoiceEventRecordFinished
} ITalkerVoiceEvent;

@protocol ITalkerVoiceEngineDelegate <NSObject>

@optional
- (void)handleVoiceEvent:(ITalkerVoiceEvent)event;

@end

@interface ITalkerVoiceEngine : NSObject <AVAudioPlayerDelegate> {
    AVAudioRecorder * _recorder;
    AVAudioPlayer * _player;
    ITalkerVoiceRecordId _curRecordId;
}

@property (assign, nonatomic) id<ITalkerVoiceEngineDelegate> voiceDelegate;

+ (ITalkerVoiceEngine *)getInstance;

- (void)recordVoice;

- (ITalkerVoiceRecordId)stopRecordVoice;

- (void)playVoiceByFileId:(ITalkerVoiceRecordId)voiceId;

- (void)playVoiceByData:(NSData *)data;

- (void)stopPlay;

@end
