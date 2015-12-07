//
//  ITalkerAppDelegate.m
//  iTalker
//
//  Created by tuyuanlin on 12-8-16.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerAppDelegate.h"
#import "ITalkerChatViewController.h"
#import "ITalkerFriendListViewController.h"
#import "ITalkerNetworkInfo.h"
#import "ITalkerUserInfo.h"
#import "ITalkerAccountManager.h"
#import "ITalkerChatEngine.h"
#import "ITalkerTalkbackViewController.h"

@implementation ITalkerAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //TODO do these after login
    _userManager = [[ITalkerAccountManager alloc] init];
    [ITalkerChatEngine getInstance];
    ITalkerUserInfo * userInfo = [[ITalkerUserInfo alloc] init];
    userInfo.userId = @"12345";
    userInfo.userName = @"Friend";
    userInfo.IpAddr = [[ITalkerNetworkInfo getInstance] getWiFiIPAddresses];
    [_userManager setCurrentUser:userInfo];
    //TODO
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ITalkerFriendListViewController * mainViewController = [[ITalkerFriendListViewController alloc] initWithNibName:@"ITalkerFriendListViewController" bundle:nil];
    //ITalkerChatViewController * mainViewController = [[ITalkerChatViewController alloc] initWithNibName:@"ITalkerChatViewController" bundle:nil];
    //ITalkerTalkbackViewController * mainViewController = [[ITalkerTalkbackViewController alloc] initWithNibName:@"ITalkerTalkbackViewController" bundle:nil];
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];

    [self.window setRootViewController:navigationController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
