//
//  NewProductRootViewController.h
//  TaoZhuang
//
//  Created by zhang kai on 4/12/13.
//
//

#import <UIKit/UIKit.h>
#import "PSCollectionView.h"

@interface NewProductRootViewController : UIViewController
{
    PSCollectionView *_collectionView;
    NSMutableArray *productsArray;
    int currentPage;
}

@property(nonatomic,retain) PSCollectionView *_collectionView;
@end
