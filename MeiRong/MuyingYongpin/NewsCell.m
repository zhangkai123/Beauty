//
//  NewsCell.m
//  MuyingYongpin
//
//  Created by zhang kai on 9/15/12.
//
//

#import <QuartzCore/QuartzCore.h>
#import "NewsCell.h"

@interface NewsCell()
{
    
}
@end

@implementation NewsCell
@synthesize titleLable ,timeLable ,contentLable;
@synthesize delegate ,rowNum;

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
        
        UIImage *bImage = [UIImage imageNamed:@"NewsNode"];
        UIImage *stretchableButtonImageNormal = [bImage stretchableImageWithLeftCapWidth:14 topCapHeight:16];
        UIButton *bButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        bButton.frame = CGRectMake(10, 10, 300, 180);
        [bButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
        [bButton addTarget:self action:@selector(goToNews) forControlEvents:UIControlEventTouchDown];
        [self addSubview:bButton];
        
        UILabel *tLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 280, 40)];
        tLable.font         = [UIFont fontWithName:@"Georgia-Bold" size:18];
        tLable.textColor    = [UIColor darkTextColor];
        tLable.shadowColor  = [[UIColor whiteColor]colorWithAlphaComponent: 0.5f];
        tLable.shadowOffset = CGSizeMake(0.5, 0.5);
        self.titleLable = tLable;
        [tLable release];
        
        UILabel *mLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 280, 20)];
        mLable.font = [UIFont fontWithName:@"Heiti TC" size:15];
        self.timeLable = mLable;
        [mLable release];
        UILabel *cLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 280, 90)];
        cLable.numberOfLines = 0;
        cLable.font=[UIFont fontWithName:@"Heiti TC" size:15];
        self.contentLable = cLable;
        [cLable release];
        
        [bButton addSubview:self.titleLable];
        [bButton addSubview:self.timeLable];
        [bButton addSubview:self.contentLable];
        self.titleLable.backgroundColor = [UIColor clearColor];
        self.timeLable.backgroundColor = [UIColor clearColor];
        self.contentLable.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)goToNews
{
    UIView *selectedView = [[UIView alloc]initWithFrame:CGRectMake(15, 16, 290, 168)];
    selectedView.backgroundColor = [UIColor colorWithRed:1 green:0.6 blue:0.8 alpha:1.0];
    selectedView.layer.cornerRadius = 10.0;
    selectedView.tag = 1000;
    [selectedView setAlpha:0.2];
    [self addSubview:selectedView];
    [selectedView release];

    [delegate selectTableViewCell:self];
}
-(void)diselectCell
{
    UIView *selectedView = [self viewWithTag:1000];
    [selectedView removeFromSuperview];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
