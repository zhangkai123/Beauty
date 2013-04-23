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
    UILabel *jiage;
    UILabel *titleLabel;
    UILabel *priceLabel;
    UILabel *promotionPriceLabel;
}
@end

@implementation ProductCell
@synthesize myImageView = _myImageView ,title = _title ,imageHeight = _imageHeight;
@synthesize shopName = _shopName ,seller_credit_score = _seller_credit_score ,price = _price,promotionPrice = _promotionPrice;

-(void)dealloc
{
    [zhanggui release];
    [jiage release];
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
                
        //for product image
        _myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, frame.size.width, frame.size.height)];
        [self addSubview:_myImageView];
        
        //zhang gui
        zhanggui = [[UILabel alloc]initWithFrame:CGRectZero];
        zhanggui.font = [UIFont systemFontOfSize:13];
        [zhanggui setTextColor:[UIColor darkGrayColor]];
        zhanggui.backgroundColor = [UIColor clearColor];
        zhanggui.numberOfLines = 0;
        [self addSubview:zhanggui];
        //shop name label
        shopnameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        shopnameLabel.font = [UIFont systemFontOfSize:13];
        [shopnameLabel setTextColor:[UIColor grayColor]];
        shopnameLabel.backgroundColor = [UIColor clearColor];
        shopnameLabel.numberOfLines = 0;
        [self addSubview:shopnameLabel];
        
        //for product shop stars image
        starImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:starImageView];
        
        //for product title
        titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        titleLabel.font = [UIFont fontWithName:@"Heiti TC" size:12];
        [titleLabel setTextColor:[UIColor grayColor]];
        titleLabel.numberOfLines = 0;
        [self addSubview:titleLabel];
        
        //zhang gui
        jiage = [[UILabel alloc]initWithFrame:CGRectZero];
        jiage.font = [UIFont systemFontOfSize:13];
        [jiage setTextColor:[UIColor darkGrayColor]];
        jiage.backgroundColor = [UIColor clearColor];
        jiage.numberOfLines = 0;
        [self addSubview:jiage];
        //for product price
        priceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        priceLabel.font = [UIFont fontWithName:@"Heiti TC" size:12];
        [priceLabel setTextColor:[UIColor redColor]];
        priceLabel.numberOfLines = 0;
        [self addSubview:priceLabel];
        //for product promotion price
        promotionPriceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        promotionPriceLabel.font = [UIFont fontWithName:@"Heiti TC" size:12];
        [promotionPriceLabel setTextColor:[UIColor redColor]];
        promotionPriceLabel.numberOfLines = 0;
        [self addSubview:promotionPriceLabel];
    }
    return self;
}
-(void)setTitle:(NSString *)title
{
    _title = title;
        
    _myImageView.frame = CGRectMake(5, 5, 148 - 10, _imageHeight);

    zhanggui.text = @"掌柜:";
    zhanggui.frame = CGRectMake(5, 5 + _imageHeight, 30, 0);
    [zhanggui sizeToFit];
    shopnameLabel.text = _shopName;
    CGRect shopLabelFrame = shopnameLabel.frame;
    shopLabelFrame.size.width = 148 - 10 - 30;
    shopLabelFrame.origin.y = 5 + _imageHeight;
    shopLabelFrame.origin.x = 35 + 2;
    shopnameLabel.frame = shopLabelFrame;
    [shopnameLabel sizeToFit];

    UIImage *starImage = [UIImage imageNamed:[self getStarImgaeName]];
    starImageView.frame = CGRectMake(5,_imageHeight + shopnameLabel.frame.size.height + 5, starImage.size.width, 10);
    starImageView.image = starImage;
    
    titleLabel.text = _title;
    CGRect labelFrame = titleLabel.frame;
    labelFrame.size.width = 148 - 10;
    labelFrame.origin.y = _imageHeight + shopnameLabel.frame.size.height + 5 + 10;
    labelFrame.origin.x = 5;
    titleLabel.frame = labelFrame;
    [titleLabel sizeToFit];
    
    jiage.text = @"价格:";
    jiage.frame = CGRectMake(5, _imageHeight + shopnameLabel.frame.size.height + titleLabel.frame.size.height + 5 + 10, 30, 0);
    [jiage sizeToFit];
    priceLabel.text = _price;
    CGRect priceLabelFrame = priceLabel.frame;
    priceLabelFrame.size.width = 40;
    priceLabelFrame.origin.y = _imageHeight + shopnameLabel.frame.size.height + titleLabel.frame.size.height + 5 + 10 + 2;
    priceLabelFrame.origin.x = 35 + 2;
    priceLabel.frame = priceLabelFrame;
    [priceLabel sizeToFit];
    
    backgroundImageView.frame = CGRectMake(0, 0, 148, _imageHeight + shopnameLabel.frame.size.height + titleLabel.frame.size.height + 5 + 10 + 10 + 10);
    if (![_price isEqualToString:_promotionPrice]) {
        if ([_promotionPrice isEqualToString:@"<null>"]) {
            promotionPriceLabel.hidden = YES;
            return;
        }
        promotionPriceLabel.hidden = NO;
        promotionPriceLabel.text = _promotionPrice;
        CGRect promotionPriceLabelFrame = promotionPriceLabel.frame;
        promotionPriceLabelFrame.size.width = 40;
        promotionPriceLabelFrame.origin.y = _imageHeight + shopnameLabel.frame.size.height + titleLabel.frame.size.height + 5 + 10 + 2;
        promotionPriceLabelFrame.origin.x = 35 + 40;
        promotionPriceLabel.frame = promotionPriceLabelFrame;
        [promotionPriceLabel sizeToFit];
    }else{
        promotionPriceLabel.hidden = YES;
    }
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
