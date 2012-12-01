//
//  ReachableManager.m
//  MuyingYongpin
//
//  Created by zhang kai on 12/1/12.
//
//

#import "ReachableManager.h"

NSString *const kNotReachabilityNotification = @"kNotReachabilityNotification";

@implementation ReachableManager

-(void)startNotify
{
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called.
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    	
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifier];    
}
//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName: kNotReachabilityNotification object: nil];
            break;
        }
            
        case ReachableViaWWAN:
        {
           // [[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityNotification object: nil];
            break;
        }
        case ReachableViaWiFi:
        {
           // [[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityNotification object: nil];
            break;
        }
        default:
            break;
    }

}

@end
