//
//  ITalkerNetworkEngine.h
//  iTalker
//
//  Created by tuyuanlin on 12-8-31.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"

@protocol ITalkerUdpNetworkDelegate <NSObject>

@optional
- (void)handleUdpData:(NSData *)data;

@end

@interface ITalkerUdpNetworkEngine : NSObject <AsyncUdpSocketDelegate> {
    AsyncUdpSocket * _udpSocket;
    UInt16 _currentPort;
}

- (BOOL)bindPort:(UInt16)port;

- (void)waitForData;

- (BOOL)broadcastUdpData:(NSData *)data;

- (BOOL)sendUdpData:(NSData *)data ToHost:(NSString *)hostIpAddr;

@property (assign, nonatomic) id<ITalkerUdpNetworkDelegate> networkDelegate;

@end
