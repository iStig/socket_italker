//
//  ITalkerVoiceFileManager.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-3.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerVoiceFileManager.h"

static ITalkerVoiceFileManager * instance;

@implementation ITalkerVoiceFileManager

+ (ITalkerVoiceFileManager *)getInstance
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

- (id)init
{
    self = [super init];
    if (self) {
        //TODO init nextId
        _nextId = 0;
    }
    return self;
}

- (ITalkerVoiceRecordId)generateFile:(NSString **)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString * newFilename = [NSString stringWithFormat:@"VoiceFile_%d.m4a", _nextId];
    *filename = [documentsDirectory stringByAppendingPathComponent:newFilename];
    
    return _nextId++;
}

- (NSString *)getFileNameById:(ITalkerVoiceRecordId)recordId
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString * newFilename = [NSString stringWithFormat:@"VoiceFile_%d.m4a", recordId];
    return [documentsDirectory stringByAppendingPathComponent:newFilename];
}

@end
