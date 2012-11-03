//
//  StyleOneCell.m
//  MuyingYongpin
//
//  Created by zhang kai on 9/9/12.
//
//

#import "StyleOneCell.h"
#import "StyleOneCellView.h"

@implementation StyleOneCell
@synthesize leftImageView ,rightImageView ,rowNum;
@synthesize delegate;
-(void)dealloc
{
    [leftImageView release];
    [rightImageView release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // Initialization code
        TouchableImageView *lImageView = [[TouchableImageView alloc]initWithFrame:CGRectMake(10, 10, 137, 137)];
        lImageView.backgroundColor = [UIColor blueColor];
        lImageView.userInteractionEnabled = YES;
        lImageView.delegate = self;
        self.leftImageView = lImageView;
        [lImageView release];
        
        TouchableImageView *rImageView = [[TouchableImageView alloc]initWithFrame:CGRectMake(10, 10, 137, 137)];
        rImageView.backgroundColor = [UIColor yellowColor];
        rImageView.userInteractionEnabled = YES;
        rImageView.delegate = self;
        self.rightImageView = rImageView;
        [rImageView release];
                
        StyleOneCellView *coverView1 = [[StyleOneCellView alloc]initWithFrame:CGRectMake(0, 0, 160, 155)];
        [coverView1 addSubview:self.leftImageView];
        
        [self addSubview:coverView1];
        [coverView1 release];

        StyleOneCellView *coverView2 = [[StyleOneCellView alloc]initWithFrame:CGRectMake(160, 0, 160, 155)];
        [coverView2 addSubview:self.rightImageView];
        
        [self addSubview:coverView2];
        [coverView2 release];
    }
    return self;
}
- (void)touchableImageViewViewWasSelected:(TouchableImageView *)thumbnailImageView
{
    if (self.leftImageView == thumbnailImageView) {
        
        [delegate selectTableViewCell:self selectedItemAtIndex:0];
    }else{
        
        [delegate selectTableViewCell:self selectedItemAtIndex:1];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
