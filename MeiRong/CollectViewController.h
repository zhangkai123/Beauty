//
//  CollectViewController.h
//  MuyingYongpin
//
//  Created by kai zhang on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyleOneCell.h"
#import "NavRootViewController.h"

@interface CollectViewController : NavRootViewController<UITableViewDelegate,UITableViewDataSource,StyleOneCellSelectionDelegate>
{
    UITableView *myTableView;
    NSMutableArray *dataArray;
}
-(id) initWithTabBar;
@end
