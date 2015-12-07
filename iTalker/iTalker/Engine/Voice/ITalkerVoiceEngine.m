//
//  ITalkerVoiceEngine.m
//  iTalker
//
//  Created by tuyuanlin on 12-8-29.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerVoiceEngine.h"

@implementation ITalkerVoiceEngine

static ITalkerVoiceEngine * instance = nil;

+ (ITalkerVoiceEngine *)getInstance
{
    if (instance == nil) {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self getInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


# pragma mark - voice record and play

- (void)initAudioSession
{
    AVAudioSession * session = [AVAudioSession sharedInstance];
    NSError * error = nil;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error) {
        NSLog(@"initAudioSession setCategory error = %@", error.localizedDescription);
        return;
    }
    
    [session setActive:YES error:&error];
    if (error) {
        NSLog(@"initAudioSession setActive error = %@", error.localizedDescription);
        return;
    }

}

- (void)recordVoice
{
    NSMutableDictionary *recordSettings =
    [[NSMutableDictionary alloc] initWithCapacity:10];
    
    [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatMPEG4AAC] forKey: AVFormatIDKey];
    [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
    [recordSettings setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    
    if (_recorder) {
        _recorder = nil;
    }
    
    NSString * filename = nil;
    _curRecordId = [[ITalkerVoiceFileManager getInstance] generateFile:&filename];
    
    NSURL * url = [NSURL fileURLWithPath:filename];
    NSError * error = nil;
    
    [self initAudioSession];
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    if (error) {
        NSLog(@"recordVoice error = %@", error.localizedDescription);
        return;
    }
    
    [_recorder prepareToRecord];
    [_recorder record];
    return;
}

- (ITalkerVoiceRecordId)stopRecordVoice
{
    [_recorder stop];
    _recorder = nil;
    
    ITalkerVoiceRecordId returnId = _curRecordId;
    _curRecordId = kITalkerInvalidVoiceRecordId;
    return returnId;
}

- (void)playVoiceByFileId:(ITalkerVoiceRecordId)recordId
{
    NSURL * url = [NSURL fileURLWithPath:[[ITalkerVoiceFileManager getInstance] getFileNameById:recordId]];
    NSError * error = nil;
    
    if (_player) {
        _player = nil;
    }
    
    [self initAudioSession];
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (error) {
        NSLog(@"playVoice error = %@", error.localizedDescription);
        return;
    }
    
    [_player setDelegate:self];
    [_player prepareToPlay];
    [_player play];

}

- (void)playVoiceByData:(NSData *)data
{
    NSError * error = nil;
    
    if (_player) {
        _player = nil;
    }
    
    [self initAudioSession];
    
    _player = [[AVAudioPlayer alloc] initWithData:data error:&error];

    if (error) {
        NSLog(@"playVoice error = %@", error.localizedDescription);
        return;
    }
    [_player setDelegate:self];
    [_player prepareToPlay];
    
    NSLog(@"start play the sound");
    [_player play];
    NSLog(@"after play");
}

- (void)stopPlay
{
    [_player stop];
    _player = nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (_voiceDelegate && [_voiceDelegate respondsToSelector:@selector(handleVoiceEvent:)]) {
        [_voiceDelegate handleVoiceEvent:ITalkerVoiceEventPlayFinished];
    }
}

@end
