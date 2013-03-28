//
//  ProductRootViewController.h
//  TaoZhuang
//
//  Created by zhang kai on 3/28/13.
//
//

#import <UIKit/UIKit.h>
#import "StyleOneCell.h"

@interface ProductRootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,StyleOneCellSelectionDelegate>
{
    UITableView *theTalbleView;
    NSMutableArray *productsArray;
    int currentPage;
    BOOL finishLoad;
    BOOL refresh;
    UILabel *titleLabel;
}
@property(nonatomic,retain) UILabel *titleLabel;
-(id) initWithTabBar;
-(void)startActivity;
-(void)stopActivity;
@end
