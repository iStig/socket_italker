//
//  ITalkerChatItem.h
//  iTalker
//
//  Created by tuyuanlin on 12-10-12.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITalkerTcpSocketItem.h"

@class ITalkerUserInfo;

@interface ITalkerChatItem : NSObject

@property (strong, nonatomic) ITalkerUserInfo * chatToUserInfo;

@property (strong, nonatomic) NSMutableArray * chatContentArray;

@property (nonatomic) ITalkerTcpSocketId socketId;

@end
