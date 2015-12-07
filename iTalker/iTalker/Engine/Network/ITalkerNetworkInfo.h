//
//  NetworkInfo.h
//  G3Wlan
//
//  Created by  omssdk on 12-4-5.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;

@interface ITalkerNetworkInfo : NSObject {

	Reachability *wifiReach;
    Reachability *internetReach;

}

+ (ITalkerNetworkInfo *)getInstance;
- (BOOL) startWifiNotifierWithObserver:(id)observer selector:(SEL)aSelector;
- (void) stopWifiNotifierWithObserver:(id)observer;
- (NSString *) getWiFiSSID; 
- (NSString *) getWiFiIPAddresses;

@end
