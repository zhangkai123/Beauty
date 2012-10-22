//
//  NewsCell.m
//  MuyingYongpin
//
//  Created by zhang kai on 9/15/12.
//
//

#import "NewsCell.h"

@implementation NewsCell
@synthesize titleLable ,timeLable ,contentLable;

-(void)dealloc
{
    [titleLable release];
    [timeLable release];
    [contentLable release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel *tLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        tLable.font         = [UIFont fontWithName:@"Heiti TC" size:tLable.font.pointSize];
        tLable.textColor    = [UIColor darkTextColor];
        tLable.shadowColor  = [[UIColor whiteColor]colorWithAlphaComponent: 0.5f];
        tLable.shadowOffset = CGSizeMake(0.5, 0.5);
        
        self.titleLable = tLable;
        [tLable release];
        UILabel *mLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 320, 20)];
        mLable.font = [UIFont fontWithName:@"Heiti TC" size:15];
        self.timeLable = mLable;
        [mLable release];
        UILabel *cLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 320, 120)];
        cLable.numberOfLines = 0;
        cLable.font=[UIFont fontWithName:@"Heiti TC" size:15];
        self.contentLable = cLable;
        [cLable release];
        
        [self addSubview:self.titleLable];
        [self addSubview:self.timeLable];
        [self addSubview:self.contentLable];
        self.titleLable.backgroundColor = [UIColor clearColor];
        self.timeLable.backgroundColor = [UIColor clearColor];
        self.contentLable.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
