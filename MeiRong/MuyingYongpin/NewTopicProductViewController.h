//
//  NewTopicProductViewController.h
//  TaoZhuang
//
//  Created by zhang kai on 4/9/13.
//
//

#import <UIKit/UIKit.h>

@interface NewTopicProductViewController : UIViewController
{
    NSString *keyWord;
    NSMutableArray *productsArray;
}
@property(nonatomic,retain) NSString *keyWord;
@property(nonatomic,retain) NSMutableArray *productsArray;
@end
