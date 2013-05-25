//
//  StoreCell.h
//  TaoZhuang
//
//  Created by zhang kai on 5/25/13.
//
//

#import <UIKit/UIKit.h>

@interface StoreCell : UITableViewCell
{
    UILabel *storeNameLabel;
    UIImageView *starImageView;
}
@property(nonatomic,retain) UILabel *storeNameLabel;
@property(nonatomic,retain) UIImageView *starImageView;
@property(nonatomic,retain) NSString *seller_credit_score;
@end
