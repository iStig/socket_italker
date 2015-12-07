//
//  ITalkerTalkbackViewController.h
//  iTalker
//
//  Created by tuyuanlin on 12-10-11.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ITalkerChatEngine.h"

@class ITalkerTalkbackEngine;

@interface ITalkerTalkbackViewController : UIViewController <ITalkerChatDelegate> {
    ITalkerTalkbackEngine * _talkbackEngine;
}

- (IBAction)handleTalkButtonPressed:(id)sender;

- (IBAction)handleTalkButtonReleased:(id)sender;

- (void)addChatContent:(ITalkerBaseChatContent *)message;

@property (strong, nonatomic) ITalkerUserInfo * chatToUserInfo;

@end
