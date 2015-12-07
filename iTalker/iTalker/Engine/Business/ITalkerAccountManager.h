//
//  ITalkerUserManager.h
//  iTalker
//
//  Created by tuyuanlin on 12-9-20.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITalkerUserInfo;

@interface ITalkerAccountManager : NSObject

+ (ITalkerUserInfo *)currentUser;

- (void)setCurrentUser:(ITalkerUserInfo *)userInfo;

@end
