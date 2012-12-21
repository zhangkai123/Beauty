//
//  StyleOneCell.m
//  MuyingYongpin
//
//  Created by zhang kai on 9/9/12.
//
//

#import "StyleOneCell.h"

@implementation StyleOneCell
@synthesize leftImageView ,rightImageView ,coverView2 ,rowNum;
@synthesize delegate;
-(void)dealloc
{
    [leftImageView release];
    [rightImageView release];
    [coverView2 release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // Initialization code
        TouchableImageView *lImageView = [[TouchableImageView alloc]initWithFrame:CGRectMake(10, 10, 145, 145)];
        lImageView.backgroundColor = [UIColor clearColor];
        lImageView.userInteractionEnabled = YES;
        lImageView.delegate = self;
        self.leftImageView = lImageView;
        [lImageView release];
        
        StyleOneCellView *coverView1 = [[StyleOneCellView alloc]initWithFrame:CGRectMake(0, 0, 160, 200)];
        coverView1.frameRect = CGRectMake(10, 10, 145, 180);
        [coverView1 addSubview:self.leftImageView];
        
        [self addSubview:coverView1];
        [coverView1 release];
        
        TouchableImageView *rImageView = [[TouchableImageView alloc]initWithFrame:CGRectMake(5, 10, 145, 145)];
        rImageView.backgroundColor = [UIColor clearColor];
        rImageView.userInteractionEnabled = YES;
        rImageView.delegate = self;
        self.rightImageView = rImageView;
        [rImageView release];
                
        StyleOneCellView *rCoverView = [[StyleOneCellView alloc]initWithFrame:CGRectMake(160, 0, 160, 200)];
        rCoverView.frameRect = CGRectMake(5, 10, 145, 180);
        [rCoverView addSubview:self.rightImageView];
        self.coverView2 = rCoverView;
        [rCoverView release];
        
        [self addSubview:coverView2];
    }
    return self;
}
- (void)touchableImageViewViewWasSelected:(TouchableImageView *)thumbnailImageView
{
    UIView *selectedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 137, 137)];
    selectedView.backgroundColor = [UIColor colorWithRed:1 green:0.6 blue:0.8 alpha:1.0];
    selectedView.tag = 1000;
    [selectedView setAlpha:0.2];

    if (self.leftImageView == thumbnailImageView) {
        [leftImageView addSubview:selectedView];
        [selectedView release];
        [delegate selectTableViewCell:self selectedItemAtIndex:0];
    }else{
        [rightImageView addSubview:selectedView];
        [selectedView release];
        [delegate selectTableViewCell:self selectedItemAtIndex:1];
    }
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
