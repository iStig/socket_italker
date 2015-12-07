//
//  ITalkerChatBaseEngine.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-21.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerChatEngine.h"
#import "ITalkerConst.h"
#import "ITalkerUserInfo.h"
#import "ITalkerTextChatContent.h"
#import "ITalkerAccountManager.h"
#import "JSONKit.h"
#import "ITalkerVoiceChatContent.h"
#import "ITalkerNetworkUtils.h"
#import "ITalkerTalkbackChatContent.h"
#import "ITalkerChatItem.h"

#define kTalkContentKeyUserInfo                     @"userinfo"
#define kTalkContentKeyContentType                  @"contenttype"
#define kTalkContentKeyContentData                  @"contentdata"

@implementation ITalkerChatEngine

static ITalkerChatEngine * instance;

+ (ITalkerChatEngine *)getInstance
{
    if (instance == nil) {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [ITalkerChatEngine getInstance];
}

+ (id)copyWithZone:(NSZone *)zone
{
    return [ITalkerChatEngine getInstance];
}

- (id)init
{
    self = [super init];
    if (self) {
        _networkEngine = [[ITalkerTcpNetworkEngine alloc] init];
        [_networkEngine acceptPort:kChatAcceptPort];
        _networkEngine.networkDelegate = self;
        _chatArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - chat methods

- (BOOL)startChatWith:(ITalkerUserInfo *)userInfo
{
    if ([self findChatItemByUserInfo:userInfo] != nil) {
        return YES;
    }
    
    ITalkerTcpSocketId socketId = [_networkEngine connectHost:userInfo.IpAddr OnPort:kChatAcceptPort];
    if (socketId == kITalkerInvalidSocketId) {
        return NO;
    }
    
    ITalkerChatItem * newItem = [[ITalkerChatItem alloc] init];
    newItem.socketId = socketId;
    newItem.chatToUserInfo = userInfo;
    [_chatArray addObject:newItem];
    return YES;
}

- (void)stopChatWith:(ITalkerUserInfo *)userInfo
{
    ITalkerChatItem * item = [self findChatItemByUserInfo:userInfo];
    if (item == nil) {
        return;
    }
    
    [_networkEngine disconnectSocketById:item.socketId];
    [_chatArray removeObject:item];
}

- (void)talk:(ITalkerBaseChatContent *)message ToUser:(ITalkerUserInfo *)userInfo
{
    ITalkerChatItem * item = [self findChatItemByUserInfo:userInfo];
    if (message == nil || item == nil) {
        return;
    }
    
    NSMutableData * data = [[NSMutableData alloc] init];
    [data appendData:[ITalkerNetworkUtils encodeNetworkDataByData:[[[ITalkerAccountManager currentUser] serialize] JSONData]]];
    [data appendData:[message serialize]];

    [_networkEngine sendData:data FromSocketById:item.socketId];
}

- (ITalkerChatItem *)findChatItemByUserInfo:(ITalkerUserInfo *)userInfo
{
    if (userInfo == nil) {
        return nil;
    }
    
    for (ITalkerChatItem * item in _chatArray) {
        if ([item.chatToUserInfo isEqualToUserInfo:userInfo]) {
            return item;
        }
    }
    return nil;
}

- (ITalkerChatItem *)findChatItemBySocketId:(ITalkerTcpSocketId)socketId
{
    for (ITalkerChatItem * item in _chatArray) {
        if (item.socketId == socketId) {
            return item;
        }
    }
    return nil;
}

#pragma mark - tcp network delegate methods

- (void)handleTcpData:(NSData *)data FromSocketId:(ITalkerTcpSocketId)socketId
{
    ITalkerChatItem * item = [self findChatItemBySocketId:socketId];
    if (item == nil) {
        return;
    }
    
    if (_chatDelegate && [_chatDelegate respondsToSelector:@selector(handleNewMessage:From:)]) {
        NSInteger length = 0;
        NSData * userInfoData = [ITalkerNetworkUtils decodeDataByNetworkData:data From:0 AndLength:&length];
        
        NSData * chatData = [data subdataWithRange:NSMakeRange(length, [data length] - length)];
        NSDictionary * userInfoDic = [[JSONDecoder decoder] objectWithData:userInfoData];
        
        if (item.chatToUserInfo == nil) {
            item.chatToUserInfo = [[ITalkerUserInfo alloc] init];
            [item.chatToUserInfo deserialize:userInfoDic];
        }
        
        ITalkerBaseChatContent * content = [[ITalkerBaseChatContent alloc] init];
        [content deserialize:chatData];
        
        switch (content.contentType) {
            case ITalkerChatContentTypeText:
            {
                ITalkerTextChatContent * chatContent = [[ITalkerTextChatContent alloc] initWithData:chatData];
                [item.chatContentArray addObject:chatContent];
                [_chatDelegate handleNewMessage:chatContent From:item.chatToUserInfo];
                break;
            }
            case ITalkerChatContentTypeVoice:
            {
                ITalkerVoiceChatContent * chatContent = [[ITalkerVoiceChatContent alloc] initWithData:chatData];
                [item.chatContentArray addObject:chatContent];
                [_chatDelegate handleNewMessage:chatContent From:item.chatToUserInfo];
                break;
            }
            case ITalkerChatContentTypeTalkback:
            {
                ITalkerTalkbackChatContent * chatContent = [[ITalkerTalkbackChatContent alloc] initWithData:chatData];
                [item.chatContentArray addObject:chatContent];
                [_chatDelegate handleNewMessage:chatContent From:item.chatToUserInfo];
                break;
            }
            default:
                break;
        }
    }
}

- (void)handleAcceptNewSocket:(ITalkerTcpSocketId)newSocketId
{
    if ([self findChatItemBySocketId:newSocketId] == nil) {
        ITalkerChatItem * item = [[ITalkerChatItem alloc] init];
        item.socketId = newSocketId;
        [_chatArray addObject:item];
    }
}

- (void)handleTcpEvent:(ITalkerTcpNetworkEvent)event ForSocketId:(ITalkerTcpSocketId)socketId
{
    switch (event) {
        case ITalkerTcpNetworkEventDisconnected:
        {
            ITalkerChatItem * item = [self findChatItemBySocketId:socketId];
            if (item) {
                [_chatArray removeObject:item];
            }
            break;
        }
        default:
            break;
    }
}


@end
