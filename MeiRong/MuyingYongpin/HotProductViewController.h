//
//  ViewController.h
//  MuyingYongpin
//
//  Created by kai zhang on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotCell.h"

@interface HotProductViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HotCellSelectionDelegate>
{
    UITableView *productTableView;
    NSMutableArray *storiesArray;
    int currentPage;
}
-(id) initWithTabBar;
@end
