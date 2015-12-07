//
//  ITalkerChatRoomViewController.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-17.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerChatViewController.h"
#import "ITalkerUdpNetworkEngine.h"
#import "ITalkerUserInfo.h"
#import "ITalkerTextChatContent.h"
#import "ITalkerVoiceEngine.h"
#import "ITalkerVoiceChatContent.h"
#import "ITalkerVoiceFileManager.h"

#define kITalkerChatViewInputFieldTag           1
#define kInputHeight 260

@implementation ITalkerChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _chatContentArray = [[NSMutableArray alloc] init];

        [[ITalkerChatEngine getInstance] setChatDelegate:self];
        
        _tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
        [_tapGestureRec setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [_chatTableView setDelegate:self];
    [_chatTableView setDataSource:self];
    [_chatTableView addGestureRecognizer:_tapGestureRec];
    
    [_chatInputField setTag:kITalkerChatViewInputFieldTag];
    [_chatInputField setDelegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)addChatContent:(ITalkerBaseChatContent *)chatContent
{
    if (chatContent.contentType == ITalkerChatContentTypeText ||
        chatContent.contentType == ITalkerChatContentTypeVoice ||
        chatContent.contentType == ITalkerChatContentTypeImage) {
        [_chatContentArray addObject:chatContent];
        
        if (self.view && _chatTableView) {
            NSArray * array = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:(_chatContentArray.count - 1) inSection:0], nil];
            
            [_chatTableView beginUpdates];
            [_chatTableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
            [_chatTableView endUpdates];
        }
    }

}

- (IBAction)handleSpeechButtonPressed:(id)sender
{
    [[ITalkerVoiceEngine getInstance] recordVoice];
}

- (IBAction)handleSpeechButtonReleased:(id)sender
{
    ITalkerVoiceRecordId recordId = [[ITalkerVoiceEngine getInstance] stopRecordVoice];
    NSString * filename = [[ITalkerVoiceFileManager getInstance] getFileNameById:recordId];
    ITalkerVoiceChatContent * content = [[ITalkerVoiceChatContent alloc] initWithVoiceFileName:filename];
    [[ITalkerChatEngine getInstance] talk:content ToUser:_chatToUserInfo];
}

- (IBAction)handleSendButtonClicked:(id)sender
{
    ITalkerTextChatContent * content = [[ITalkerTextChatContent alloc] initWithString:_chatInputField.text];
    [[ITalkerChatEngine getInstance] talk:content ToUser:_chatToUserInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_chatContentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * chatContentListCellIdentifier = @"ChatContentListCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chatContentListCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatContentListCellIdentifier];
    }
    
    ITalkerBaseChatContent * content = [_chatContentArray objectAtIndex:indexPath.row];
    switch (content.contentType) {
        case ITalkerChatContentTypeText:
        {
            ITalkerTextChatContent * textContent = (ITalkerTextChatContent *)content;
            cell.textLabel.text = textContent.text;
            break;
        }
        case ITalkerChatContentTypeVoice:
        {
            cell.textLabel.text = @"Click to play!";
            break;
        }
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ITalkerBaseChatContent * content = [_chatContentArray objectAtIndex:indexPath.row];
    switch (content.contentType) {
        case ITalkerChatContentTypeVoice:
        {
            ITalkerVoiceChatContent * voiceContent = (ITalkerVoiceChatContent *)content;
            [[ITalkerVoiceEngine getInstance] playVoiceByData:voiceContent.voiceData];
            break;
        }
        default:
            break;
    }
}

- (void)handleNewMessage:(ITalkerBaseChatContent *)message From:(ITalkerUserInfo *)userInfo
{
    [self addChatContent:message];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == kITalkerChatViewInputFieldTag) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect newFrame = self.view.frame;
            newFrame.size.height -= 170;
            
            self.view.frame = newFrame;
            
            newFrame = _chatInputField.frame;
            newFrame.origin.y -= 170;
            
            _chatInputField.frame = newFrame;

            newFrame = _sendButton.frame;
            newFrame.origin.y -= 170;
            
            _sendButton.frame = newFrame;
            
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == kITalkerChatViewInputFieldTag) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect newFrame = self.view.frame;
            newFrame.size.height += kInputHeight;
            
            self.view.frame = newFrame;
            
            newFrame = _chatInputField.frame;
            newFrame.origin.y += kInputHeight;
            
            _chatInputField.frame = newFrame;
            
            newFrame = _sendButton.frame;
            newFrame.origin.y += kInputHeight;
            
            _sendButton.frame = newFrame;
            
        }];
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [_chatInputField resignFirstResponder];
    return NO;
}

@end
