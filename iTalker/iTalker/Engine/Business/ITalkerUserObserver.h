//
//  ITalkerUserObserver.h
//  iTalker
//
//  Created by tuyuanlin on 12-9-19.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ITalkerUdpNetworkEngine.h"

@class ITalkerUserInfo;

typedef enum {
    ITalkerUserObserverUserAdded,
    ITalkerUserObserverUserRemoved
} ITalkerUserObserverEvent;

@protocol ITalkerUserEventDelegate <NSObject>

@optional
- (void)handleUserObserverEvent:(ITalkerUserObserverEvent)event AndUserInfo:(ITalkerUserInfo *)userInfo;

@end

@interface ITalkerUserObserver : NSObject <ITalkerUdpNetworkDelegate> {
    ITalkerUdpNetworkEngine * _udpNetworkEngine;
}

+ (ITalkerUserObserver *)getInstance;

- (void)startObserve;

- (void)publishUser;

@property (assign, nonatomic) id<ITalkerUserEventDelegate> userEventDelegate;

@end
