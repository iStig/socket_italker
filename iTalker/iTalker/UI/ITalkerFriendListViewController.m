//
//  ITalkerFriendListViewController.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-20.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerFriendListViewController.h"
#import "ITalkerUserObserver.h"
#import "ITalkerUserInfo.h"
#import "ITalkerChatViewController.h"
#import "ITalkerTalkbackViewController.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface ITalkerFriendListViewController ()

@end

@implementation ITalkerFriendListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _friendArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  self.title = [self getIPAddress];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    
    ITalkerUserObserver * observer = [ITalkerUserObserver getInstance];
    [observer setUserEventDelegate:self];
    [observer startObserve]; 
    [observer publishUser];
  
    [[ITalkerChatEngine getInstance] setChatDelegate:self];
}

#pragma mark - private
- (NSString *)getIPAddress
{
  NSString *address = @"error";
  struct ifaddrs *interfaces = NULL;
  struct ifaddrs *temp_addr = NULL;
  int success = 0;
  // retrieve the current interfaces - returns 0 on success
  success = getifaddrs(&interfaces);
  if (success == 0)
  {
    // Loop through linked list of interfaces
    temp_addr = interfaces;
    while(temp_addr != NULL)
    {
      if(temp_addr->ifa_addr->sa_family == AF_INET)
      {
        // Check if interface is en0 which is the wifi connection on the iPhone
        if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
        {
          // Get NSString from C String
          address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
        }
      }
      temp_addr = temp_addr->ifa_next;
    }
  }
  // Free memory
  freeifaddrs(interfaces);
  return address;
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[ITalkerChatEngine getInstance] setChatDelegate:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)handleUserObserverEvent:(ITalkerUserObserverEvent)event AndUserInfo:(ITalkerUserInfo *)userInfo
{
    if (userInfo == nil) {
        return;
    }
    
    switch (event) {
        case ITalkerUserObserverUserAdded: {
          
          for (ITalkerUserInfo *user in  _friendArray) {
            if ([user.IpAddr isEqualToString:userInfo.IpAddr]) {
              return;
            }
          }
          
          
            [_friendArray addObject:userInfo];
            
            NSArray * array = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:(_friendArray.count - 1) inSection:0], nil];
            
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
            [_tableView endUpdates];
            break;
        }
        default:
            break;
    }
}

- (void)handleNewMessage:(ITalkerBaseChatContent *)message From:(ITalkerUserInfo *)userInfo
{
    if (message.contentType == ITalkerChatContentTypeTalkback) {
        ITalkerTalkbackViewController * talkbackViewController = [[ITalkerTalkbackViewController alloc] initWithNibName:@"ITalkerTalkbackViewController" bundle:nil];
        talkbackViewController.chatToUserInfo = userInfo;
        [talkbackViewController addChatContent:message];
        [self.navigationController pushViewController:talkbackViewController animated:YES];
    } else {
        ITalkerChatViewController * chatViewController = [[ITalkerChatViewController alloc] initWithNibName:@"ITalkerChatViewController" bundle:nil];
        chatViewController.chatToUserInfo = userInfo;
        [chatViewController addChatContent:message];
        [self.navigationController pushViewController:chatViewController animated:YES];
    }
}

#pragma mark - table view data source delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_friendArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * friendListCellIdentifier = @"FriendListCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendListCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:friendListCellIdentifier];
    }

    if (indexPath && indexPath.section == 0 && indexPath.row < _friendArray.count) {
        ITalkerUserInfo * userInfo = [_friendArray objectAtIndex:indexPath.row];
        cell.textLabel.text = userInfo.IpAddr;
        
        UIButton * talkbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        talkbackButton.frame = CGRectMake(0, 5, 50, 30);
        talkbackButton.tag = indexPath.row;
        [talkbackButton addTarget:self action:@selector(handleTalkbackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = talkbackButton;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ITalkerChatViewController * chatViewController = [[ITalkerChatViewController alloc] initWithNibName:@"ITalkerChatViewController" bundle:nil];
    ITalkerUserInfo * info = [_friendArray objectAtIndex:indexPath.row];
    [[ITalkerChatEngine getInstance] startChatWith:info];
    chatViewController.chatToUserInfo = info;
    [self.navigationController pushViewController:chatViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)handleTalkbackButtonClicked:(id)sender
{
    UIButton * button = (UIButton *)sender;
    ITalkerUserInfo * userInfo = [_friendArray objectAtIndex:button.tag];
    ITalkerTalkbackViewController * talkbackViewController = [[ITalkerTalkbackViewController alloc] initWithNibName:@"ITalkerTalkbackViewController" bundle:nil];
    talkbackViewController.chatToUserInfo = userInfo;

    [self.navigationController pushViewController:talkbackViewController animated:YES];
}

@end
