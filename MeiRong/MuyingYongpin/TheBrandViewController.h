//
//  TheBrandViewController.h
//  MuyingYongpin
//
//  Created by zhang kai on 9/8/12.
//
//

#import <UIKit/UIKit.h>
#import "StyleOneCell.h"

@interface TheBrandViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,StyleOneCellSelectionDelegate>
{
    UITableView *theTalbleView;
    NSString *catName;
    NSMutableArray *productsArray;
    int currentPage;
    BOOL finishLoad;
    BOOL refresh;
}
@property(nonatomic,retain)  NSString *catName;
@end
