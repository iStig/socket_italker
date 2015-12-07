//
//  ITalkerTcpNetworkItem.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-27.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerTcpSocketItem.h"

@implementation ITalkerTcpSocketItem

- (id)initWithSocket:(AsyncSocket *)socket AndId:(ITalkerTcpSocketId)socketId
{
    self = [super init];
    if (self) {
        _socket = socket;
        _socketId = socketId;
        _data = [[NSMutableData alloc] init];
        _nextPackageLength = -1;
    }
    return self;
}

- (BOOL)isEqualById:(ITalkerTcpSocketId)socketId;
{
    if (_socketId == socketId) {
        return YES;
    }
    return NO;
}

- (BOOL)isEqualBySocket:(AsyncSocket *)socket
{
    if ([_socket isEqual:socket]) {
        return YES;
    }
    return NO;
}

@end
