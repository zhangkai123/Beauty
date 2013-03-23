//
//  FirstCell.m
//  TaoZhuang
//
//  Created by zhang kai on 3/23/13.
//
//

#import "FirstCell.h"

@implementation FirstCell
@synthesize myImageView;

-(void)dealloc
{
    [myImageView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageWidth:(float)imageW
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(-(imageW - 320)/2, 0, imageW, 480)];
        [self addSubview:myImageView];        
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
