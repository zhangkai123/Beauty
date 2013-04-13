//
//  NewCategoryProductViewController.h
//  TaoZhuang
//
//  Created by zhang kai on 4/12/13.
//
//

#import "NewProductRootViewController.h"

@interface NewCategoryProductViewController : NewProductRootViewController
{
    NSString *catName;
    NSString *catId;
}
@property(nonatomic,retain)  NSString *catName;
@property(nonatomic,retain)  NSString *catId;
@end
