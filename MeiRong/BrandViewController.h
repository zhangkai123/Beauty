//
//  BrandViewController.h
//  MuyingYongpin
//
//  Created by kai zhang on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavRootViewController.h"

@interface BrandViewController : NavRootViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITableView *myTableView;
    NSMutableArray *dataArray;
    
    NSMutableArray *dataArray1;
    NSMutableArray *dataArray2;
    NSMutableArray *dataArray3;
    NSMutableArray *dataArray4;
}
-(id) initWithTabBar;
@end
