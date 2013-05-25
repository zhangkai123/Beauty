//
//  ProductCSBCell.m
//  TaoZhuang
//
//  Created by zhang kai on 5/25/13.
//
//

#import "ProductCSBCell.h"

@implementation ProductCSBCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 32)];
        backView.backgroundColor = [UIColor blackColor];
        [backView setAlpha:0.8];
        [self addSubview:backView];
        [backView release];
        
        UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        collectButton.titleLabel.text = @"收藏";
        [collectButton setImage:[UIImage imageNamed:@"ico_footer_like"] forState:UIControlStateNormal];
        [collectButton addTarget:self action:@selector(collectProduct) forControlEvents:UIControlEventTouchUpInside];
        collectButton.frame = CGRectMake(15, 5, 28, 22);
        [self addSubview:collectButton];
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.titleLabel.text = @"分享";
        [shareButton setImage:[UIImage imageNamed:@"ico_footer_share"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareProduct) forControlEvents:UIControlEventTouchUpInside];
        shareButton.frame = CGRectMake(75, 5, 28, 22);
        [self addSubview:shareButton];

        UIButton *buyButton = [[UIButton alloc]initWithFrame:CGRectMake(220, 0, 100, 32)];
        [buyButton setTitle:@"查看详情" forState:UIControlStateNormal];
        [buyButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buyButton.backgroundColor = [UIColor colorWithRed:1 green: 0.6 blue:0.8 alpha:1];
        [self addSubview:buyButton];
    }
    return self;
}
-(void)collectProduct
{
    
}
-(void)shareProduct
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
