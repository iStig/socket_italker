//
//  ITalkerTalkbackViewController.m
//  iTalker
//
//  Created by tuyuanlin on 12-10-11.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerTalkbackViewController.h"
#import "ITalkerTalkbackEngine.h"

@interface ITalkerTalkbackViewController ()

@end

@implementation ITalkerTalkbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[ITalkerChatEngine getInstance] setChatDelegate:self];
        _talkbackEngine = [[ITalkerTalkbackEngine alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)handleTalkButtonPressed:(id)sender
{
    if (_chatToUserInfo == nil) {
        return;
    }
    
    [_talkbackEngine startTalk:_chatToUserInfo];
}

- (IBAction)handleTalkButtonReleased:(id)sender
{
    [_talkbackEngine stopTalk];
}

- (void)addChatContent:(ITalkerBaseChatContent *)message
{
    if (message.contentType == ITalkerChatContentTypeTalkback) {
        [_talkbackEngine addVoiceContent:(ITalkerTalkbackChatContent *)message];
        [_talkbackEngine play];
    }
}

- (void)handleNewMessage:(ITalkerBaseChatContent *)message From:(ITalkerUserInfo *)userInfo
{
    [self addChatContent:message];
}

@end
