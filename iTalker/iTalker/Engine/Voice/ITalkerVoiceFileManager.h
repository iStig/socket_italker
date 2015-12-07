//
//  ITalkerVoiceFileManager.h
//  iTalker
//
//  Created by tuyuanlin on 12-9-3.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSInteger ITalkerVoiceRecordId;

#define kITalkerInvalidVoiceRecordId            -1

@interface ITalkerVoiceFileManager : NSObject {
    ITalkerVoiceRecordId _nextId;
}

+ (ITalkerVoiceFileManager *)getInstance;

- (ITalkerVoiceRecordId)generateFile:(NSString **)filename;

- (NSString *)getFileNameById:(ITalkerVoiceRecordId)recordId;

@end
