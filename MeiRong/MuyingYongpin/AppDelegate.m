//
//  AppDelegate.m
//  MuyingYongpin
//
//  Created by kai zhang on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Parse/Parse.h>
#import "AppDelegate.h"

#import "TopicViewController.h"
#import "HotProductViewController.h"
#import "BrandViewController.h"
#import "CollectViewController.h"
#import "MobClick.h"

#import "ReachableManager.h"
#import "ATMHud.h"
#import "DataController.h"

//#import "SDImageCache.h"

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
//    [Parse setApplicationId:@"nARw6JOO8oGvPZXE8U3SQPiXMygXh6hbFL2KJ565" clientKey:@"ihSkf0jedHJd61xH48ztDWu1LfiAATWZIfFBOadg"];
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
    
    TopicViewController *topicViewController = [[TopicViewController alloc]initWithTabBar];
    navigationController = [[UINavigationController alloc]initWithRootViewController:topicViewController];
    [controllersArray addObject:navigationController];
    [topicViewController release];
    [navigationController release];
    
    HotProductViewController *hotProductViewController = [[HotProductViewController alloc]initWithTabBar];
    hotProductViewController.catName = @"热销";
//    navigationController = [[UINavigationController alloc]initWithRootViewController:hotProductViewController];
    [controllersArray addObject:hotProductViewController];
    [hotProductViewController release];
//    [navigationController release];
    
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveVersionNum:) name:@"VERSION_READY" object:nil];
    [[DataController sharedDataController]featchVersionNum:YES];
    
    return YES;
}

-(void)recieveVersionNum:(NSNotification *)notification
{
    NSDictionary *dicInfo = [notification object];
    NSNumber *automatic = [dicInfo objectForKey:@"Automatic"];
    NSString *latestVersionNum = [dicInfo objectForKey:@"VersionNum"];
    latestVersionNum = [latestVersionNum stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (!([latestVersionNum floatValue] > [majorVersion floatValue])) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([automatic boolValue]) {
                return;
            }
            ATMHud *versionHud = [[ATMHud alloc] initWithDelegate:self];
            [versionHud setFixedSize:CGSizeMake(110, 110)];
            [self.window addSubview:versionHud.view];
            [versionHud setCaption:@"已是最新版本"];
            [versionHud show];
            [versionHud hideAfter:1.0];
            [versionHud release];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"DISSELECT_CELL" object:nil userInfo:nil];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![automatic boolValue]) {
                [self showAlert:@"亲，去app store更新最新版本吧"];
            }
            NSDate *oldDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"theDateKey"];
            if (oldDate == nil) {
             
                [self showAlert:@"亲，去app store更新最新版本吧"];
            }else{
                NSDate *currentDate = [NSDate date];
                
                NSDateFormatter *cDateFormat = [[NSDateFormatter alloc] init];
                [cDateFormat setDateFormat:@"yyyy-MM-dd"];
                NSString *cDate = [cDateFormat stringFromDate:currentDate];
                
                NSDateFormatter *oDateFormat = [[NSDateFormatter alloc] init];
                [oDateFormat setDateFormat:@"yyyy-MM-dd"];
                NSString *oDate = [oDateFormat stringFromDate:oldDate];
                
                [cDateFormat release];
                [oDateFormat release];
                
                NSArray *currentArray = [cDate componentsSeparatedByString:@"-"];
                NSArray *oldArray = [oDate componentsSeparatedByString:@"-"];
                
                //check month
                int currentMonth = [[currentArray objectAtIndex:1] intValue];
                int oldMonth = [[oldArray objectAtIndex:1] intValue];
                if (currentMonth > oldMonth) {
                    [self showAlert:@"亲，去app store更新最新版本吧"];
                }
                //check day
                int currentDay = [[currentArray objectAtIndex:2] intValue];
                int oldDay = [[oldArray objectAtIndex:2] intValue];
                if (currentMonth == oldMonth) {
                    if (currentDay >= oldDay + 7) {
                        [self showAlert:@"亲，去app store更新最新版本吧"];
                    }
                }

            }
        });
    }
}
-(void)showAlert:(NSString *)alertMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: nil
                              message: alertMessage
                              delegate: self
                              cancelButtonTitle:@"不，谢谢"
                              otherButtonTitles:@"好的",nil];
        [alert show];
        [alert release];
    });
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		
        NSString *iTunesLink = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=612318538&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }else{
        NSDate *myDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults]setObject:myDate forKey:@"theDateKey"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DISSELECT_CELL" object:nil userInfo:nil];
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
//    SDImageCache *imageCache = [SDImageCache sharedImageCache];
//    if ([imageCache getSize] > 50) {
//        [imageCache clearDisk];
//    }else{
//        [imageCache cleanDisk];
//    }
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
