//
//  ITalkerTcpNetworkItem.h
//  iTalker
//
//  Created by tuyuanlin on 12-9-27.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsyncSocket.h"

typedef NSInteger ITalkerTcpSocketId;

#define kITalkerInvalidSocketId     -1

@interface ITalkerTcpSocketItem : NSObject

- (id)initWithSocket:(AsyncSocket *)socket AndId:(ITalkerTcpSocketId)socketId;

- (BOOL)isEqualById:(ITalkerTcpSocketId)socketId;

- (BOOL)isEqualBySocket:(AsyncSocket *)socket;

@property (readonly, nonatomic) ITalkerTcpSocketId socketId;

@property (readonly, nonatomic) AsyncSocket * socket;

@property (strong, nonatomic) NSMutableData * data;

@property (nonatomic) NSInteger nextPackageLength;

@end
