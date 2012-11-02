//
//  HotCell.m
//  MuyingYongpin
//
//  Created by zhang kai on 9/9/12.
//
//

#import <QuartzCore/QuartzCore.h>
#import "HotCell.h"

@implementation HotCell
@synthesize theImageView ,desLable;
@synthesize collectButton ,collectLabel ,sharedButton;
@synthesize delegate ,rowNum;
@synthesize coverView;
-(void)dealloc
{
    [theImageView release];
    [coverView release];
    [desLable release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        TouchableImageView *imageView = [[TouchableImageView alloc]initWithFrame:CGRectMake(10, 10, 300, 300)];
        imageView.delegate = self;
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor clearColor];
        self.theImageView = imageView;
        [imageView release];
        
        UILabel *dLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 310, 300, 45)];
        dLable.backgroundColor = [UIColor whiteColor];
        dLable.lineBreakMode = UILineBreakModeWordWrap;
        dLable.numberOfLines = 0;
        [dLable setFont:[UIFont fontWithName:@"Heiti TC" size:15]];
        self.desLable = dLable;
        [dLable release];
        
        UIImage *cImage = [UIImage imageNamed:@"likeButton"];
        UIImage *stretchableButtonImageNormal = [cImage stretchableImageWithLeftCapWidth:23 topCapHeight:0];
        UIButton *cButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cButton.frame = CGRectMake(183, 360, cImage.size.width*2 + 8, cImage.size.height);
        [cButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
        [cButton addTarget:self action:@selector(collectProduct) forControlEvents:UIControlEventTouchDown];
        self.collectButton = cButton;
        
        UILabel *cLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 1, 36, 20)];
        cLabel.numberOfLines = 1;
        [cLabel setTextAlignment:UITextAlignmentCenter];
        [cLabel setTextColor:[UIColor darkGrayColor]];
        cLabel.shadowColor   = [[UIColor whiteColor]colorWithAlphaComponent: 0.5f];
        cLabel.shadowOffset  = CGSizeMake(1.0,1.0);
        cLabel.backgroundColor = [UIColor clearColor];
        [cLabel setFont:[UIFont fontWithName:@"Heiti TC" size:12]];
        self.collectLabel = cLabel;
        [cLabel release];
        [self.collectButton addSubview:self.collectLabel];
        collectLabel.text = @"收藏";

        UIImage *moreButtonImage = [UIImage imageNamed:@"moreButton"];
        UIButton *sButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        sButton.frame = CGRectMake(255, 360, moreButtonImage.size.width, moreButtonImage.size.height);
        [sButton setBackgroundImage:moreButtonImage forState:UIControlStateNormal];
        [sButton addTarget:self action:@selector(shareProduct) forControlEvents:UIControlEventTouchDown];
        self.sharedButton = sButton;
        
        HotCellView *cView = [[HotCellView alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
        self.coverView = cView;
        [cView release];
//        [coverView addSubview:self.theImageView];
        
        [self.coverView addSubview:self.desLable];
        [self.coverView addSubview:self.collectButton];
        [self.coverView addSubview:self.sharedButton];
        
        [self.contentView addSubview:self.coverView];        
    }
    return self;
}
-(void)prepareForReuse
{
    self.coverView.notFirstDraw = NO;
    [self.coverView setNeedsDisplay];
    [super prepareForReuse];
}

//- (void)layoutSubviews
//{
//    [self.coverView setNeedsDisplay];
//    [super layoutSubviews];
//}
-(void)collectProduct
{
    [delegate collectProduct:self];
}
-(void)shareProduct
{
    [delegate shareProduct:self];
}
- (void)touchableImageViewViewWasSelected:(TouchableImageView *)thumbnailImageView
{
    [delegate selectTableViewCell:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
@end
