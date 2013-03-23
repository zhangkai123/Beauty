//
//  TheBrandDetailViewController.h
//  MuyingYongpin
//
//  Created by zhang kai on 10/9/12.
//
//

#import <UIKit/UIKit.h>
#import "Product.h"
//#import "HotCell.h"

@interface TheBrandDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *theTableView;
    Product *product;
    UIImageView *myImageView;
    UIImage *smallImage;
    BOOL collection;
}
@property(nonatomic,retain) Product *product;
@property(nonatomic,retain) UIImage *smallImage;
@property(nonatomic,assign) BOOL collection;
@end
