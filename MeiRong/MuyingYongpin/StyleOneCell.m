//
//  StyleOneCell.m
//  MuyingYongpin
//
//  Created by zhang kai on 9/9/12.
//
//

#import "StyleOneCell.h"

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
        // Initialization code
        TouchableImageView *lImageView = [[TouchableImageView alloc]initWithFrame:CGRectMake(0, 0, 160, 160)];
        lImageView.backgroundColor = [UIColor blueColor];
        lImageView.userInteractionEnabled = YES;
        lImageView.delegate = self;
        self.leftImageView = lImageView;
        [lImageView release];
        
        TouchableImageView *rImageView = [[TouchableImageView alloc]initWithFrame:CGRectMake(160, 0, 160, 160)];
        rImageView.backgroundColor = [UIColor yellowColor];
        rImageView.userInteractionEnabled = YES;
        rImageView.delegate = self;
        self.rightImageView = rImageView;
        [rImageView release];
        
        [self addSubview:self.leftImageView];
        [self addSubview:self.rightImageView];
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
