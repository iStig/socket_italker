//
//  ITalkerTcpNetworkEngine.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-21.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerTcpNetworkEngine.h"
#import "ITalkerConst.h"
#import "ITalkerNetworkUtils.h"

#define kSendTcpTag             1
#define kReceiveTcpTag          2

static NSInteger staticIdCount = 0;

@implementation ITalkerTcpNetworkEngine

- (id)init
{
    self = [super init];
    if (self) {
        _socketItemArray = [[NSMutableArray alloc] init];
        _listenSocket = [[AsyncSocket alloc] initWithDelegate:self];
    }
    
    return self;
}

- (BOOL)acceptPort:(UInt16)port
{
    return [_listenSocket acceptOnPort:port error:nil];
}

- (ITalkerTcpSocketId)connectHost:(NSString *)hostIpAddr OnPort:(UInt16)port;
{
    AsyncSocket * socket = [[AsyncSocket alloc] initWithDelegate:self];
    if ([socket connectToHost:hostIpAddr onPort:port withTimeout:kNetworkTimeOut error:nil]) {
        ITalkerTcpSocketItem * newItem = [[ITalkerTcpSocketItem alloc] initWithSocket:socket AndId:staticIdCount++];
        [_socketItemArray addObject:newItem];
        return newItem.socketId;
    }
    return kITalkerInvalidSocketId;
}

- (void)sendData:(NSData *)data FromSocketById:(ITalkerTcpSocketId)socketId;
{
    ITalkerTcpSocketItem * item = [self findSocketItemById:socketId];
    if (item) {
        NSData * networkData = [ITalkerNetworkUtils encodeNetworkDataByData:data];
        NSLog(@"sendData %d", networkData.length);
        [item.socket writeData:networkData withTimeout:kNetworkTimeOut tag:kSendTcpTag];
    }
}

- (void)disconnectSocketById:(ITalkerTcpSocketId)socketId;
{
    ITalkerTcpSocketItem * item = [self findSocketItemById:socketId];
    if (item) {
        [item.socket disconnect];
    }
}

- (ITalkerTcpSocketItem *)findSocketItemById:(ITalkerTcpSocketId)socketId
{
    for (ITalkerTcpSocketItem * item in _socketItemArray) {
        if ([item isEqualById:socketId]) {
            return item;
        }
    }
    return nil;
}

- (ITalkerTcpSocketItem *)findSocketItemBySocket:(AsyncSocket *)socket
{
    for (ITalkerTcpSocketItem * item in _socketItemArray) {
        if ([item isEqualBySocket:socket]) {
            return item;
        }
    }
    return nil;
}

#pragma mark - AsyncSocketDelegate

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    ITalkerTcpSocketItem * item = [self findSocketItemBySocket:sock];
    if (item) {
        if (_networkDelegate && [_networkDelegate respondsToSelector:@selector(handleTcpEvent:ForSocketId:)]) {
            [_networkDelegate handleTcpEvent:ITalkerTcpNetworkEventDisconnected ForSocketId:item.socketId];
        }
        [_socketItemArray removeObject:item];
    }
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    if (sock && [sock isEqual:_listenSocket]) {
        ITalkerTcpSocketItem * newItem = [[ITalkerTcpSocketItem alloc] initWithSocket:newSocket AndId:staticIdCount++];
        [_socketItemArray addObject:newItem];
        [newSocket readDataWithTimeout:-1 tag:kReceiveTcpTag];
        if (_networkDelegate && [_networkDelegate respondsToSelector:@selector(handleAcceptNewSocket:)]) {
            [_networkDelegate handleAcceptNewSocket:newItem.socketId];
        }
    }
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    if (_networkDelegate && [_networkDelegate respondsToSelector:@selector(handleTcpEvent:ForSocketId:)]) {
        ITalkerTcpSocketItem * item = [self findSocketItemBySocket:sock];
        if (item) {
            [item.socket readDataWithTimeout:-1 tag:kReceiveTcpTag];
            [_networkDelegate handleTcpEvent:ITalkerTcpNetworkEventConnected ForSocketId:item.socketId];
        }
    }
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if (_networkDelegate && [_networkDelegate respondsToSelector:@selector(handleTcpData:FromSocketId:)]) {
        ITalkerTcpSocketItem * item = [self findSocketItemBySocket:sock];
        if (item) {
            [item.data appendData:data];
            [self parseData:item];
            
            [item.socket readDataWithTimeout:-1 tag:kReceiveTcpTag];
        }
    }
}

- (void)parseData:(ITalkerTcpSocketItem *)item
{
    if (item.nextPackageLength == -1 && item.data.length > sizeof(NSInteger)) {
        NSInteger bytesOfHeader = 0;
        NSInteger total = [ITalkerNetworkUtils decodeLengthByNetworkData:item.data From:0 AndLength:&bytesOfHeader];
        
        item.nextPackageLength = total;
        [item.data replaceBytesInRange:NSMakeRange(0, bytesOfHeader) withBytes:NULL length:0];
    }
    
    if (item.data.length >= item.nextPackageLength) {
        [_networkDelegate handleTcpData:[item.data subdataWithRange:NSMakeRange(0, item.nextPackageLength)] FromSocketId:item.socketId];
        [item.data replaceBytesInRange:NSMakeRange(0, item.nextPackageLength) withBytes:NULL length:0];
        item.nextPackageLength = -1;

        [self parseData:item];
    }
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if (sock) {
        [sock readDataWithTimeout:-1 tag:kReceiveTcpTag];
    }
}

@end
