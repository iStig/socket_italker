//
//  ITalkerUserInfo.h
//  iTalker
//
//  Created by tuyuanlin on 12-9-19.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITalkerUserInfo : NSObject

@property (strong, nonatomic) NSString * userId;
@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString * IpAddr;

- (NSDictionary *)serialize;

- (BOOL)deserialize:(NSDictionary *)data;

- (BOOL)isEqualToUserInfo:(ITalkerUserInfo *)userInfo;

@end
