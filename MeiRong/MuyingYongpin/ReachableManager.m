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
@synthesize reachable;

+(id)sharedReachableManager
{
    static ReachableManager *reachableManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        reachableManager = [[ReachableManager alloc]init];
    });
    return reachableManager;
}
-(void)startNotify
{
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called.
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    	
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifier];
    
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        reachable = NO;
    }else{
        reachable = YES;
    }
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
            reachable = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName: kNotReachabilityNotification object: nil];
            break;
        }
            
        case ReachableViaWWAN:
        {
            reachable = YES;
            break;
        }
        case ReachableViaWiFi:
        {
            reachable = YES;
            break;
        }
        default:
            break;
    }

}

@end
