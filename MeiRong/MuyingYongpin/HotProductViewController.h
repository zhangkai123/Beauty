//
//  ViewController.h
//  MuyingYongpin
//
//  Created by kai zhang on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotProductViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *productTableView;
    NSMutableArray *productsArray;
    int currentPage;
}
-(id) initWithTabBar;
@end
