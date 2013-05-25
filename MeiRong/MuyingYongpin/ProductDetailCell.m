//
//  ProductDetailCell.m
//  TaoZhuang
//
//  Created by zhang kai on 5/9/13.
//
//

#import "ProductDetailCell.h"

@implementation ProductDetailCell
@synthesize desLabel = _desLabel ,priLabel = _priLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // Initialization code
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
        backView.backgroundColor = [UIColor blackColor];
        [backView setAlpha:0.6];
        [self addSubview:backView];
        [backView release];

        _desLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 310, 45)];
        [_desLabel setFont:[UIFont systemFontOfSize:13]];
        [_desLabel setTextColor:[UIColor whiteColor]];
        _desLabel.numberOfLines = 0;
        _desLabel.lineBreakMode = UILineBreakModeWordWrap;
        _desLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_desLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
