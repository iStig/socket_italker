//
//  ITalkerUserManager.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-20.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerAccountManager.h"
#import "ITalkerUserInfo.h"

@implementation ITalkerAccountManager

static ITalkerUserInfo * currentUserInfo = nil;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (ITalkerUserInfo *)currentUser
{
    return currentUserInfo;
}

- (void)setCurrentUser:(ITalkerUserInfo *)userInfo
{
    currentUserInfo = userInfo;
}

@end
