//
//  StoreCell.m
//  TaoZhuang
//
//  Created by zhang kai on 5/25/13.
//
//

#import "StoreCell.h"

@implementation StoreCell
@synthesize storeNameLabel ,starImageView ,seller_credit_score = _seller_credit_score;
-(void)dealloc
{
    [storeNameLabel release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
        backView.backgroundColor = [UIColor blackColor];
        [backView setAlpha:0.4];
        [self addSubview:backView];
        [backView release];
        
        UILabel *storeNameL = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 50, 20)];
        storeNameL.numberOfLines = 1;
        storeNameL.backgroundColor = [UIColor clearColor];
        [storeNameL setFont:[UIFont systemFontOfSize:13]];
        [storeNameL setTextColor:[UIColor whiteColor]];
        [storeNameL setText:@"掌柜:"];
        [self addSubview:storeNameL];
        [storeNameL release];

        storeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 150, 20)];
        storeNameLabel.numberOfLines = 1;
        storeNameLabel.backgroundColor = [UIColor clearColor];
        [storeNameLabel setFont:[UIFont systemFontOfSize:13]];
        [storeNameLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:storeNameLabel];
        
        starImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:starImageView];
    }
    return self;
}
-(void)setSeller_credit_score:(NSString *)score
{
    if (![score isEqualToString:_seller_credit_score]) {
        [_seller_credit_score release];
        _seller_credit_score = score;
        [_seller_credit_score retain];
        
        UIImage *starImage = [UIImage imageNamed:[self getStarImgaeName]];
        starImageView.frame = CGRectMake(205,10, starImage.size.width, 10);
        starImageView.image = starImage;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
