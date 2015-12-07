//
//  ITalkerFriendListViewController.h
//  iTalker
//
//  Created by tuyuanlin on 12-9-20.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ITalkerUserObserver.h"
#import "ITalkerChatEngine.h"

@interface ITalkerFriendListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ITalkerUserEventDelegate, ITalkerChatDelegate> {
    NSMutableArray * _friendArray;
}

@property (strong, nonatomic) IBOutlet UITableView * tableView;

@end
