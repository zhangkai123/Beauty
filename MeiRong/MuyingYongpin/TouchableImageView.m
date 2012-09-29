//
//  TouchableImageView.m
//  MuyingYongpin
//
//  Created by zhang kai on 9/11/12.
//
//

#import "TouchableImageView.h"

@implementation TouchableImageView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [delegate touchableImageViewViewWasSelected:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
