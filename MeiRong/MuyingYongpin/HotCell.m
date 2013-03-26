//
//  HotCell.m
//  MuyingYongpin
//
//  Created by zhang kai on 9/9/12.
//
//

#import <QuartzCore/QuartzCore.h>
#import "HotCell.h"

@interface HotCell()
{
}
@end

@implementation HotCell
@synthesize titleLable;
@synthesize delegate ,rowNum;
@synthesize coverView ,myImageView;
@synthesize articleLable ;
-(void)dealloc
{
    [coverView release];
    [myImageView release];
    [titleLable release];
    [articleLable release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *tLable = [[UILabel alloc]initWithFrame:CGRectMake(25, 305, 270, 15)];
        tLable.backgroundColor = [UIColor clearColor];
        [tLable setTextAlignment:NSTextAlignmentCenter];
        tLable.numberOfLines = 1;
        [tLable setFont:[UIFont fontWithName:@"Heiti TC" size:15]];
//        dLable.backgroundColor = [UIColor yellowColor];
        self.titleLable = tLable;
        [tLable release];
        
        UIView *separateLineView = [[UIView alloc]initWithFrame:CGRectMake(15, 300 - 1, 290, 1)];
        separateLineView.backgroundColor = [UIColor darkGrayColor];
        [separateLineView setAlpha:0.1];
        [self addSubview:separateLineView];
        [separateLineView release];
            
        articleLable = [[UILabel alloc]initWithFrame:CGRectMake(25, 320, 275, 45)];
        articleLable.font = [UIFont fontWithName:@"Heiti TC" size:12];
        articleLable.lineBreakMode = UILineBreakModeWordWrap;
        articleLable.numberOfLines = 0;
        articleLable.textColor = [UIColor grayColor];
//        priceLabel2.backgroundColor = [UIColor blueColor];
                
        TouchableImageView *mImageView = [[TouchableImageView alloc]initWithFrame:CGRectMake(15, 10, 290,290)];
        mImageView.backgroundColor = [UIColor clearColor];
        mImageView.userInteractionEnabled = YES;
        mImageView.delegate = self;
        self.myImageView = mImageView;
        [mImageView release];
                
        HotCellView *cView = [[HotCellView alloc]initWithFrame:CGRectMake(0, 0, 320, 380)];
        self.coverView = cView;
        [cView release];
        [self.coverView addSubview:self.myImageView];
        [self.coverView addSubview:self.titleLable];
        
        [self.coverView addSubview:articleLable];
        
        [self.contentView addSubview:self.coverView];        
    }
    return self;
}
-(void)prepareForReuse
{
    [super prepareForReuse];
}

-(void)collectProduct
{
    [delegate collectProduct:self];
}
-(void)shareProduct
{
    [delegate shareProduct:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)diselectCell
{
    UIView *selectedView = [self viewWithTag:1000];
    [selectedView removeFromSuperview];
}

- (void)touchableImageViewViewWasSelected:(TouchableImageView *)thumbnailImageView
{
    UIView *selectedView = [[UIView alloc]initWithFrame:CGRectMake(15, 10, 290,290)];
    selectedView.backgroundColor = [UIColor colorWithRed:1 green:0.6 blue:0.8 alpha:1.0];
    selectedView.tag = 1000;
    [selectedView setAlpha:0.2];
    [self addSubview:selectedView];
    [selectedView release];
    [delegate selectTableViewCell:self];
}
@end
