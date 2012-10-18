//
//  HotCell.m
//  MuyingYongpin
//
//  Created by zhang kai on 9/9/12.
//
//

#import "HotCell.h"

@implementation HotCell
@synthesize theImageView ,desLable;
@synthesize collectButton ,sharedButton;
@synthesize delegate ,rowNum;
-(void)dealloc
{
    [theImageView release];
    [desLable release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor blackColor];
        TouchableImageView *imageView = [[TouchableImageView alloc]initWithFrame:CGRectMake(10, 10, 300, 300)];
        imageView.delegate = self;
        imageView.userInteractionEnabled = YES;
        self.theImageView = imageView;
        [imageView release];
        
        UILabel *dLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 310, 300, 45)];
        dLable.backgroundColor = [UIColor whiteColor];
        dLable.lineBreakMode = UILineBreakModeWordWrap;
        dLable.numberOfLines = 0;
        [dLable setFont:[UIFont systemFontOfSize:15]];
        self.desLable = dLable;
        [dLable release];
        
        UIButton *cButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cButton.frame = CGRectMake(180, 360, 60, 30);
        [cButton setTitle:@"收藏" forState:UIControlStateNormal];
        [cButton addTarget:self action:@selector(collectProduct) forControlEvents:UIControlEventTouchDown];
        self.collectButton = cButton;

        UIButton *sButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        sButton.frame = CGRectMake(250, 360, 60, 30);
        [sButton setTitle:@"分享" forState:UIControlStateNormal];
        [sButton addTarget:self action:@selector(shareProduct) forControlEvents:UIControlEventTouchDown];
        self.sharedButton = sButton;
        
        [self addSubview:self.theImageView];
        [self addSubview:self.desLable];
        [self addSubview:self.collectButton];
        [self addSubview:self.sharedButton];
    }
    return self;
}
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
