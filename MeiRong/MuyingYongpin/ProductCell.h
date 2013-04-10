//
//  ProductCell.h
//  TaoZhuang
//
//  Created by zhang kai on 4/9/13.
//
//

#import "PSCollectionViewCell.h"

@interface ProductCell : PSCollectionViewCell
{
    UIImageView *backgroundImageView;
    UILabel *titleLabel;
}
@property(nonatomic,retain) UIImageView *myImageView;
@property(nonatomic,assign) float imageHeight;
@property(nonatomic,retain) NSString *title;
@end
