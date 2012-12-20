//
//  HotCellView.m
//  MuyingYongpin
//
//  Created by zhang kai on 10/19/12.
//
//

#import "HotCellView.h"

@implementation HotCellView

-(void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma drawRect
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGPathRef outlinePath = [self newPathForRoundedRect:CGRectMake(15, 10, 290, 360) radius:5];
    
    CGContextSetShadow(ctx, CGSizeMake(1,1), 3);
    CGContextAddPath(ctx, outlinePath);
    CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextFillPath(ctx);
            
    CGPathRelease(outlinePath);
}
//Create a pill with the given rect
- (CGPathRef) newPathForRoundedRect:(CGRect)rect radius:(CGFloat)radius
{
	CGMutablePathRef retPath = CGPathCreateMutable();
    
	CGRect innerRect = CGRectInset(rect, radius, radius);
    
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height;
    
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y;
	CGFloat outside_left = rect.origin.x;
    
	CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
    
	CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
	CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
    
	CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);
    
	CGPathCloseSubpath(retPath);
    
	return retPath;
}
@end
