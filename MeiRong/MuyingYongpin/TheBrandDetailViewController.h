//
//  TheBrandDetailViewController.h
//  MuyingYongpin
//
//  Created by zhang kai on 10/9/12.
//
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "HotCell.h"

@interface TheBrandDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HotCellSelectionDelegate>
{
    UITableView *theTableView;
    Product *product;
}
@property(nonatomic,retain) Product *product;
@end
