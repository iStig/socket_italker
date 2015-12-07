//
//  ITalkerTcpNetworkEngine.h
//  iTalker
//
//  Created by tuyuanlin on 12-9-21.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsyncSocket.h"
#import "ITalkerTcpSocketItem.h"

typedef enum {
    ITalkerTcpNetworkEventConnected,
    ITalkerTcpNetworkEventConnectError,
    ITalkerTcpNetworkEventDisconnected
} ITalkerTcpNetworkEvent;

@protocol ITalkerTcpNetworkDelegate <NSObject>

@optional
- (void)handleTcpData:(NSData *)data FromSocketId:(ITalkerTcpSocketId)socketId;

- (void)handleAcceptNewSocket:(ITalkerTcpSocketId)newSocketId;

- (void)handleTcpEvent:(ITalkerTcpNetworkEvent)event ForSocketId:(ITalkerTcpSocketId)socketId;

@end

@interface ITalkerTcpNetworkEngine : NSObject <AsyncSocketDelegate> {
    NSMutableArray * _socketItemArray;
    AsyncSocket * _listenSocket;
}

- (BOOL)acceptPort:(UInt16)port;

- (ITalkerTcpSocketId)connectHost:(NSString *)hostIpAddr OnPort:(UInt16)port;

- (void)sendData:(NSData *)data FromSocketById:(ITalkerTcpSocketId)socketId;

- (void)disconnectSocketById:(ITalkerTcpSocketId)socketId;

@property (assign, nonatomic) id<ITalkerTcpNetworkDelegate> networkDelegate;

@end
