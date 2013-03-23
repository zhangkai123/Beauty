//
//  FirstCell.m
//  TaoZhuang
//
//  Created by zhang kai on 3/23/13.
//
//

#import "FirstCell.h"

@implementation FirstCell
@synthesize titleLabel;
@synthesize myImageView;

-(void)dealloc
{
    [myImageView release];
     [titleLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageWidth:(float)imageW
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(-(imageW - 320)/2, 0, imageW, 460)];
        [self addSubview:myImageView];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, imageW - 60, 320, 60)];
        backView.backgroundColor = [UIColor blackColor];
        [backView setAlpha:0.4];
        [self addSubview:backView];
        [backView release];
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, imageW - 45, 280, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel setFont:[UIFont systemFontOfSize:12]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:titleLabel];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
