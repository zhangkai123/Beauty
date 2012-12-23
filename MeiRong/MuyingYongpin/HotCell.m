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
@synthesize desLable;
@synthesize collectButton ,collectLabel ,sharedButton;
@synthesize delegate ,rowNum;
@synthesize coverView ,myImageView;
@synthesize priceLabel2 ,likeLabel2;
-(void)dealloc
{
    [coverView release];
    [myImageView release];
    [desLable release];
    [priceLabel2 release];
    [likeLabel2 release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *dLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 300, 280, 37)];
        dLable.backgroundColor = [UIColor clearColor];
        dLable.lineBreakMode = UILineBreakModeWordWrap;
        dLable.numberOfLines = 0;
        [dLable setFont:[UIFont fontWithName:@"Heiti TC" size:12]];
        self.desLable = dLable;
        [dLable release];
        
        UIView *separateLineView = [[UIView alloc]initWithFrame:CGRectMake(15, 300 - 1, 290, 1)];
        separateLineView.backgroundColor = [UIColor darkGrayColor];
        [separateLineView setAlpha:0.1];
        [self addSubview:separateLineView];
        [separateLineView release];
    
        UILabel *priceLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15 + 10, 337, 40, 25)];
        priceLabel1.text = @"价格:";
        priceLabel1.font = [UIFont fontWithName:@"Heiti TC" size:12];
//        priceLabel1.backgroundColor = [UIColor yellowColor];
        
        priceLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(5 + 40 + 10, 337, 40, 25)];
        priceLabel2.font = [UIFont fontWithName:@"Heiti TC" size:12];
        priceLabel2.textColor = [UIColor colorWithRed:(196/255.f) green:(72/255.f) blue:(72/255.f) alpha:1];
//        priceLabel2.backgroundColor = [UIColor blueColor];
        
        UILabel *likeLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(95, 337, 25, 25)];
        likeLabel1.text = @"喜欢";
        likeLabel1.font = [UIFont fontWithName:@"Heiti TC" size:12];
//        likeLabel1.backgroundColor = [UIColor yellowColor];
        
        likeLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(95 + 25 + 3, 337, 30, 25)];
        likeLabel2.font = [UIFont fontWithName:@"Heiti TC" size:12];
        likeLabel2.textColor = [UIColor colorWithRed:(196/255.f) green:(72/255.f) blue:(72/255.f) alpha:1];
//        likeLabel2.backgroundColor = [UIColor blueColor];

        UIImage *cImage = [UIImage imageNamed:@"likeButton"];
        UIImage *stretchableButtonImageNormal = [cImage stretchableImageWithLeftCapWidth:23 topCapHeight:0];
        UIButton *cButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cButton.frame = CGRectMake(183, 337, cImage.size.width*2 + 8, cImage.size.height);
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
        sButton.frame = CGRectMake(255, 337, moreButtonImage.size.width, moreButtonImage.size.height);
        [sButton setBackgroundImage:moreButtonImage forState:UIControlStateNormal];
        [sButton addTarget:self action:@selector(shareProduct) forControlEvents:UIControlEventTouchDown];
        self.sharedButton = sButton;
        
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
        [self.coverView addSubview:self.desLable];
        [self.coverView addSubview:self.collectButton];
        [self.coverView addSubview:self.sharedButton];
        
        [self.coverView addSubview:priceLabel1];
        [self.coverView addSubview:priceLabel2];
        [self.coverView addSubview:likeLabel1];
        [self.coverView addSubview:likeLabel2];
        [priceLabel1 release];
        [likeLabel1 release];
        
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
