//
//  ProductCell.h
//  TaoZhuang
//
//  Created by zhang kai on 4/9/13.
//
//

#import "PSCollectionViewCell.h"

@interface ProductCell : PSCollectionViewCell

@property(nonatomic,retain) NSString *shopName;
@property(nonatomic,retain) UIImageView *myImageView;
@property(nonatomic,assign) float imageHeight;
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *seller_credit_score;
@property(nonatomic,retain) NSString *price;
@property(nonatomic,retain) NSString *promotionPrice;
@end
