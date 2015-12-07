//
//  ITalkerUserInfo.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-19.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerUserInfo.h"

@implementation ITalkerUserInfo

#define kUserInfoKeyUserId          @"userid"
#define kUserInfoKeyUserName        @"username"
#define kUserInfoKeyIpAddress       @"ipaddr"

- (NSDictionary *)serialize
{
    if (_userId && _userName && _IpAddr) {
        __autoreleasing NSDictionary * outData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                  _userId, kUserInfoKeyUserId,
                                                  _userName, kUserInfoKeyUserName,
                                                  _IpAddr, kUserInfoKeyIpAddress,
                                                  nil];
        return outData;
    }
    return nil;
}

- (BOOL)deserialize:(NSDictionary *)data
{
    if (data != nil) {
        NSString * userid = [data objectForKey:kUserInfoKeyUserId];
        NSString * name = [data objectForKey:kUserInfoKeyUserName];
        NSString * ip = [data objectForKey:kUserInfoKeyIpAddress];
        
        if (userid && name && ip) {
            self.userId = userid;
            self.userName = name;
            self.IpAddr = ip;
            return YES;
        }
    }
    return NO;
}

- (BOOL)isEqualToUserInfo:(ITalkerUserInfo *)userInfo
{
    if ([userInfo.IpAddr isEqualToString:_IpAddr] &&
        [userInfo.userId isEqualToString:_userId]) {
        return YES;
    }
    return NO;
}

@end
