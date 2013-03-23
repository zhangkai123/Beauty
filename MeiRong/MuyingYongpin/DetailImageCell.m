//
//  DetailImageCell.m
//  TaoZhuang
//
//  Created by zhang kai on 3/23/13.
//
//

#import "DetailImageCell.h"

@implementation DetailImageCell
@synthesize myImageView;

-(void)dealloc
{
    [myImageView release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageHeight:(float)imageH
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, imageH)];
        [self addSubview:myImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
