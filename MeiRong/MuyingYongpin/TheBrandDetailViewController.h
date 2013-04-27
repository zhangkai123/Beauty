//
//  TheBrandDetailViewController.h
//  MuyingYongpin
//
//  Created by zhang kai on 10/9/12.
//
//

#import <UIKit/UIKit.h>
#import "NavRootViewController.h"
#import "Product.h"

@interface TheBrandDetailViewController : NavRootViewController<UITableViewDataSource,UITableViewDelegate>
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

-(id)initWithProduct:(Product *)myProduct;
@end
