//
//  AppDelegate.m
//  MuyingYongpin
//
//  Created by kai zhang on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "HotProductViewController.h"
#import "BrandViewController.h"
#import "CollectViewController.h"
#import "NewsFeedViewController.h"
#import "MobClick.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

-(void)dealloc
{
    [self.tabBarController release];
    [self.window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MobClick startWithAppkey:@"xxxxxxxxxxxxxxx" reportPolicy:REALTIME channelId:nil];
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

    NewsFeedViewController *newsFeedViewController = [[NewsFeedViewController alloc]initWithTabBar];
    navigationController = [[UINavigationController alloc]initWithRootViewController:newsFeedViewController];
    [controllersArray addObject:navigationController];
    [newsFeedViewController release];
    [navigationController release];
    
    self.tabBarController.viewControllers = controllersArray;
    [controllersArray release];
    
    self.tabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"tabBarBg"];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
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

@end
