//
//  ReachableManager.h
//  MuyingYongpin
//
//  Created by zhang kai on 12/1/12.
//
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

extern NSString *const kNotReachabilityNotification;

@class Reachability;
@interface ReachableManager : NSObject
{
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
}

-(void)startNotify;
@end
