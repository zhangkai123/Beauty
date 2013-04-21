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
    UILabel *zhanggui;
    UILabel *shopnameLabel;
    
    UIImageView *starImageView;
    UILabel *titleLabel;
    UILabel *priceLabel;
    UILabel *promotionPriceLabel;
}
@end

@implementation ProductCell
@synthesize myImageView = _myImageView ,title = _title ,imageHeight = _imageHeight;
@synthesize shopName = _shopName ,seller_credit_score = _seller_credit_score;

-(void)dealloc
{
    [zhanggui release];
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
        
        //zhang gui
        zhanggui = [[UILabel alloc]initWithFrame:CGRectZero];
        zhanggui.font = [UIFont systemFontOfSize:13];
        [zhanggui setTextColor:[UIColor yellowColor]];
        zhanggui.backgroundColor = [UIColor greenColor];
        zhanggui.numberOfLines = 0;
        [self addSubview:zhanggui];
        //shop name label
        shopnameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        shopnameLabel.font = [UIFont systemFontOfSize:13];
        [shopnameLabel setTextColor:[UIColor blueColor]];
        shopnameLabel.backgroundColor = [UIColor yellowColor];
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
        
    _myImageView.frame = CGRectMake(5, 5 + shopnameLabel.frame.size.height, 148 - 10, _imageHeight);
    
    zhanggui.frame = CGRectMake(5, 5 + _imageHeight, 30, 0);
    zhanggui.text = @"掌柜:";
    [zhanggui sizeToFit];
    shopnameLabel.text = _shopName;
    CGRect shopLabelFrame = shopnameLabel.frame;
    shopLabelFrame.size.width = 148 - 10 - 30;
    shopLabelFrame.origin.y = 5 + _imageHeight;
    shopLabelFrame.origin.x = 35;
    shopnameLabel.frame = shopLabelFrame;
    [shopnameLabel sizeToFit];

    UIImage *starImage = [UIImage imageNamed:[self getStarImgaeName]];
    starImageView.frame = CGRectMake(5, 5 + _imageHeight + shopnameLabel.frame.size.height + 10, starImage.size.width, 10);
    starImageView.image = starImage;
    
    titleLabel.text = _title;
    CGRect labelFrame = titleLabel.frame;
    labelFrame.size.width = 148 - 10;
    labelFrame.origin.y = _imageHeight + shopnameLabel.frame.size.height + 5 + 5 + 20;
    labelFrame.origin.x = 5;
    titleLabel.frame = labelFrame;
    [titleLabel sizeToFit];
    
    backgroundImageView.frame = CGRectMake(0, 0, 148, _imageHeight + shopnameLabel.frame.size.height + titleLabel.frame.size.height + 5 + 5 + 5 + 20);
}
-(NSString *)getStarImgaeName
{
    NSString *starImageName;
    if (![_seller_credit_score isKindOfClass:NSClassFromString(@"NSString")]) {
        return nil;
    }
    int starNum = [_seller_credit_score intValue];
    if (starNum >= 1 && starNum <= 5) {
        starImageName = [NSString stringWithFormat:@"buyer-1-%d",starNum];
    }
    if (starNum >= 6 && starNum <= 10) {
        starImageName = [NSString stringWithFormat:@"buyer-2-%d",starNum - 5];
    }
    if (starNum >= 11 && starNum <= 15) {
        starImageName = [NSString stringWithFormat:@"buyer-3-%d",starNum - 10];
    }
    if (starNum >= 16 && starNum <= 20) {
        starImageName = [NSString stringWithFormat:@"buyer-4-%d",starNum - 15];
    }
    return starImageName;
}
@end
