//
//  AppDelegate.m
//  MuyingYongpin
//
//  Created by kai zhang on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Parse/Parse.h>
#import "AppDelegate.h"

#import "HotProductViewController.h"
#import "BrandViewController.h"
#import "CollectViewController.h"
#import "NewsFeedViewController.h"
#import "MobClick.h"

#import "ReachableManager.h"
#import "ATMHud.h"

#import "SDImageCache.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

-(void)dealloc
{
    [self.tabBarController release];
    [self.window release];
    [hud release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
    [Parse setApplicationId:@"mKBDiBdpxitQVxnwChP2FQDUQTbZOl4ITyos3XPo" clientKey:@"WN12hGmbWjJRSLaU7mPpYKism9KKlM4WIs4I88ME"];
    [PFUser enableAutomaticUser];
    PFACL *defaultACL = [PFACL ACL];
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];

    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showHud) name:kNotReachabilityNotification object:nil];
    
    [MobClick startWithAppkey:@"5065b5735270151341000065" reportPolicy:REALTIME channelId:nil];
    
    [[ReachableManager sharedReachableManager] startNotify];
    
    self.tabBarController = [[[UITabBarController alloc]init]autorelease];
    UINavigationController *navigationController;
    
    NSMutableArray *controllersArray = [[NSMutableArray alloc]initWithCapacity:4];
    HotProductViewController *hotProductViewController = [[HotProductViewController alloc]initWithTabBar];
    navigationController = [[UINavigationController alloc]initWithRootViewController:hotProductViewController];
    [controllersArray addObject:navigationController];
    [hotProductViewController release];
    [navigationController release];
    
    BrandViewController *brandViewController = [[BrandViewController alloc]initWithTabBar];
    navigationController = [[UINavigationController alloc]initWithRootViewController:brandViewController];
    [controllersArray addObject:navigationController];
    [brandViewController release];
    [navigationController release];

    CollectViewController *collectViewController = [[CollectViewController alloc]initWithTabBar];
    navigationController = [[UINavigationController alloc]initWithRootViewController:collectViewController];
    [controllersArray addObject:navigationController];
    [collectViewController release];
    [navigationController release];

//    NewsFeedViewController *newsFeedViewController = [[NewsFeedViewController alloc]initWithTabBar];
//    navigationController = [[UINavigationController alloc]initWithRootViewController:newsFeedViewController];
//    [controllersArray addObject:navigationController];
//    [newsFeedViewController release];
//    [navigationController release];
    
    self.tabBarController.viewControllers = controllersArray;
    [controllersArray release];
    
    self.tabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar_background"];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont fontWithName:@"Heiti TC" size:10], UITextAttributeFont,
                                                       [[UIColor whiteColor] colorWithAlphaComponent: 0.6f], UITextAttributeTextColor,
                                                      // [[UIColor whiteColor]colorWithAlphaComponent: 0.0f], UITextAttributeTextShadowColor,
                                                       //[NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)], UITextAttributeTextShadowOffset,
                                                       nil] forState:UIControlStateNormal];
    
    self.tabBarController.tabBar.selectedImageTintColor = [UIColor colorWithRed:1 green: 0.6 blue:0.8 alpha:1];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    hud = [[ATMHud alloc] initWithDelegate:self];
    [hud setFixedSize:CGSizeMake(150, 150)];
	[self.window addSubview:hud.view];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    return YES;
}
-(void)showHud
{
//    [hud setFixedSize:CGSizeMake(150, 150)];
//    [hud setCaption:@"无网络连接"];
//    [hud show];
//    [hud hideAfter:3.0];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    if ([imageCache getSize] > 50) {
        [imageCache clearDisk];
    }else{
        [imageCache cleanDisk];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
//notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    [PFPush storeDeviceToken:newDeviceToken];
    [PFPush subscribeToChannelInBackground:@"" target:self selector:@selector(subscribeFinished:error:)];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
	}
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

#pragma mark - ()

- (void)subscribeFinished:(NSNumber *)result error:(NSError *)error {
    if ([result boolValue]) {
        NSLog(@"ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
    } else {
        NSLog(@"ParseStarterProject failed to subscribe to push notifications on the broadcast channel.");
    }
}

@end
