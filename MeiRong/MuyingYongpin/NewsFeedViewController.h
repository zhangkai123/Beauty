//
//  NewsFeedViewController.h
//  MuyingYongpin
//
//  Created by kai zhang on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *theTableView;
    NSMutableArray *dataArray;
}
-(id) initWithTabBar;
@end
