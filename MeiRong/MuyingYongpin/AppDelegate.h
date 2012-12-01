//
//  AppDelegate.h
//  MuyingYongpin
//
//  Created by kai zhang on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATMHudDelegate.h"

@class ATMHud;
@interface AppDelegate : UIResponder <UIApplicationDelegate ,ATMHudDelegate>
{
     ATMHud *hud;   
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UITabBarController *tabBarController;

@end
