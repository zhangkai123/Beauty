//
//  ProductCell.m
//  TaoZhuang
//
//  Created by zhang kai on 4/9/13.
//
//

#import "ProductCell.h"

@interface ProductCell()
{
    UIImageView *backgroundImageView;
    UILabel *shopnameLabel;
    UIImageView *starImageView;
    UILabel *titleLabel;
    UILabel *priceLabel;
    UILabel *promotionPriceLabel;
}
@end

@implementation ProductCell
@synthesize myImageView = _myImageView ,title = _title ,imageHeight = _imageHeight;

-(void)dealloc
{
    [shopnameLabel release];
    [backgroundImageView release];
    [_myImageView release];
    [titleLabel release];
    [starImageView release];
    [priceLabel release];
    [promotionPriceLabel release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *bImage = [UIImage imageNamed:@"ShadowFlattened"];
        UIImage *stretchableButtonImageNormal = [bImage stretchableImageWithLeftCapWidth:2 topCapHeight:2];
        
        backgroundImageView = [[UIImageView alloc]initWithFrame:frame];
        backgroundImageView.image = stretchableButtonImageNormal;
        [self addSubview:backgroundImageView];
        self.backgroundColor = [UIColor clearColor];
        
        //shop name label
        shopnameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        shopnameLabel.font = [UIFont fontWithName:@"Heiti TC" size:12];
        [shopnameLabel setTextColor:[UIColor grayColor]];
        shopnameLabel.numberOfLines = 0;
        [self addSubview:shopnameLabel];
        
        //for product image
        _myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, frame.size.width, frame.size.height)];
        [self addSubview:_myImageView];
        
        //for product shop stars image
        starImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:starImageView];
        
        //for product title
        titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        titleLabel.font = [UIFont fontWithName:@"Heiti TC" size:12];
        [titleLabel setTextColor:[UIColor grayColor]];
        titleLabel.numberOfLines = 0;
        [self addSubview:titleLabel];
        
        //for product price
        priceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        priceLabel.font = [UIFont fontWithName:@"Heiti TC" size:12];
        [priceLabel setTextColor:[UIColor grayColor]];
        priceLabel.numberOfLines = 0;
        [self addSubview:priceLabel];

        promotionPriceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        promotionPriceLabel.font = [UIFont fontWithName:@"Heiti TC" size:12];
        [promotionPriceLabel setTextColor:[UIColor grayColor]];
        promotionPriceLabel.numberOfLines = 0;
        [self addSubview:promotionPriceLabel];
    }
    return self;
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    
    titleLabel.text = _title;

    CGRect labelFrame = titleLabel.frame;
    labelFrame.size.width = 148 - 10;
    labelFrame.origin.y = _imageHeight + 5 + 5;
    labelFrame.origin.x = 5;
    titleLabel.frame = labelFrame;
    [titleLabel sizeToFit];
    
    _myImageView.frame = CGRectMake(5, 5, 148 - 10, _imageHeight);
    
    backgroundImageView.frame = CGRectMake(0, 0, 148, _imageHeight + titleLabel.frame.size.height + 5 + 5 + 5);
}
@end
