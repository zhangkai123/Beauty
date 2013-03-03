//
//  StyleOneCell.m
//  MuyingYongpin
//
//  Created by zhang kai on 9/9/12.
//
//

#import "StyleOneCell.h"

@implementation StyleOneCell
@synthesize leftImageView ,rightImageView ,priceLabel2 ,priceLabelR2 ,likeLabel2 ,likeLabel2R ,coverView2 ,rowNum;
@synthesize price ,likes;
@synthesize delegate;
-(void)dealloc
{
    [leftImageView release];
    [rightImageView release];
    [priceLabel2 release];
    [priceLabelR2 release];
    [likeLabel2 release];
    [likeLabel2R release];
    [coverView2 release];
    [price release];
    [likes release];
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
        
        UILabel *priceLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 155, 40, 35)];
        priceLabel1.text = @"价格:";
        priceLabel1.font = [UIFont fontWithName:@"Heiti TC" size:12];
//        priceLabel1.backgroundColor = [UIColor blueColor];
        [coverView1 addSubview:priceLabel1];
        [priceLabel1 release];
        
        priceLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(5 + 40, 155, 40, 35)];
        priceLabel2.font = [UIFont fontWithName:@"Heiti TC" size:12];
        priceLabel2.textColor = [UIColor colorWithRed:(196/255.f) green:(72/255.f) blue:(72/255.f) alpha:1];
//        priceLabel2.backgroundColor = [UIColor blueColor];
        [coverView1 addSubview:priceLabel2];
        
        UILabel *likeLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(95, 155, 25, 35)];
        likeLabel1.text = @"信誉";
        likeLabel1.font = [UIFont fontWithName:@"Heiti TC" size:12];
//        likeLabel1.backgroundColor = [UIColor yellowColor];
        [coverView1 addSubview:likeLabel1];
        [likeLabel1 release];
        
        likeLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(95 + 25, 155, 30, 35)];
        likeLabel2.font = [UIFont fontWithName:@"Heiti TC" size:12];
        likeLabel2.textColor = [UIColor colorWithRed:(196/255.f) green:(72/255.f) blue:(72/255.f) alpha:1];
        likeLabel2.textAlignment = UITextAlignmentCenter;
//        likeLabel2.backgroundColor = [UIColor blueColor];
        [coverView1 addSubview:likeLabel2];
        
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
        
        UILabel *priceLabelR1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 155, 40, 35)];
        priceLabelR1.text = @"价格:";
        priceLabelR1.font = [UIFont fontWithName:@"Heiti TC" size:12];
//        priceLabelR1.backgroundColor = [UIColor blueColor];
        [coverView2 addSubview:priceLabelR1];
        [priceLabelR1 release];
        
        priceLabelR2 = [[UILabel alloc]initWithFrame:CGRectMake(40, 155, 40, 35)];
        priceLabelR2.font = [UIFont fontWithName:@"Heiti TC" size:12];
        priceLabelR2.textColor = [UIColor colorWithRed:(196/255.f) green:(72/255.f) blue:(72/255.f) alpha:1];
//        priceLabelR2.backgroundColor = [UIColor blueColor];
        [coverView2 addSubview:priceLabelR2];
        
        UILabel *likeLabel1R = [[UILabel alloc]initWithFrame:CGRectMake(90, 155, 25, 35)];
        likeLabel1R.text = @"信誉";
        likeLabel1R.font = [UIFont fontWithName:@"Heiti TC" size:12];
//        likeLabel1R.backgroundColor = [UIColor yellowColor];
        [coverView2 addSubview:likeLabel1R];
        [likeLabel1R release];
        
        likeLabel2R = [[UILabel alloc]initWithFrame:CGRectMake(90 + 25, 155, 30, 35)];
        likeLabel2R.font = [UIFont fontWithName:@"Heiti TC" size:12];
        likeLabel2R.textColor = [UIColor colorWithRed:(196/255.f) green:(72/255.f) blue:(72/255.f) alpha:1];
        likeLabel2R.textAlignment = UITextAlignmentCenter;
//        likeLabel2R.backgroundColor = [UIColor blueColor];
        [coverView2 addSubview:likeLabel2R];
        
        [self addSubview:coverView2];
    }
    return self;
}
- (void)touchableImageViewViewWasSelected:(TouchableImageView *)thumbnailImageView
{
    UIView *selectedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 145, 145)];
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
