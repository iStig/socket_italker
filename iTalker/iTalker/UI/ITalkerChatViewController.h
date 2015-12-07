//
//  ITalkerChatRoomViewController.h
//  iTalker
//
//  Created by tuyuanlin on 12-9-17.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITalkerChatEngine.h"

@class ITalkerUserInfo;

@interface ITalkerChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, ITalkerChatDelegate> {
    NSMutableArray * _chatContentArray;
    UITapGestureRecognizer * _tapGestureRec;
}

@property (strong, nonatomic) ITalkerUserInfo * chatToUserInfo;

@property (strong, nonatomic) IBOutlet UITableView * chatTableView;

@property (strong, nonatomic) IBOutlet UITextField * chatInputField;

@property (strong, nonatomic) IBOutlet UIButton * sendButton;

@property (strong, nonatomic) IBOutlet UIButton * speechButton;

- (IBAction)handleSpeechButtonPressed:(id)sender;

- (IBAction)handleSpeechButtonReleased:(id)sender;

- (IBAction)handleSendButtonClicked:(id)sender;

- (void)addChatContent:(ITalkerBaseChatContent *)chatContent;

@end
