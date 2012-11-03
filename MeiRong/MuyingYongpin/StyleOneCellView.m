//
//  StyleOneCellView.m
//  MuyingYongpin
//
//  Created by zhang kai on 10/22/12.
//
//

#import "StyleOneCellView.h"

@implementation StyleOneCellView

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

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGGradientRef gradient = [self normalGradient];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef outlinePath = CGPathCreateMutable();
    float offset = 7.0;
    float w  = [self bounds].size.width;
    float h  = [self bounds].size.height;
    CGPathMoveToPoint(outlinePath, nil, offset*2.0, offset);
    CGPathAddArcToPoint(outlinePath, nil, offset, offset, offset, offset*2, offset);
    CGPathAddLineToPoint(outlinePath, nil, offset, h - offset*2.0);
    CGPathAddArcToPoint(outlinePath, nil, offset, h - offset, offset *2.0, h-offset, offset);
    CGPathAddLineToPoint(outlinePath, nil, w - offset *2.0, h - offset);
    CGPathAddArcToPoint(outlinePath, nil, w - offset, h - offset, w - offset, h - offset * 2.0, offset);
    CGPathAddLineToPoint(outlinePath, nil, w - offset, offset*2.0);
    CGPathAddArcToPoint(outlinePath, nil, w - offset , offset, w - offset*2.0, offset, offset);
    CGPathCloseSubpath(outlinePath);
    
    CGContextSetShadow(ctx, CGSizeMake(1,1), 3);
    CGContextAddPath(ctx, outlinePath);
    CGContextFillPath(ctx);
    
    CGContextAddPath(ctx, outlinePath);
    CGContextClip(ctx);
    CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint end = CGPointMake(rect.origin.x, rect.size.height);
    CGContextDrawLinearGradient(ctx, gradient, start, end, 0);
    
    CGPathRelease(outlinePath);
}

- (CGGradientRef)normalGradient
{
    
    NSMutableArray *normalGradientLocations = [NSMutableArray arrayWithObjects:
                                               [NSNumber numberWithFloat:0.0f],
                                               [NSNumber numberWithFloat:1.0f],
                                               nil];
    
    
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:2];
    
    UIColor *color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    NSMutableArray  *normalGradientColors = colors;
    
    int locCount = [normalGradientLocations count];
    CGFloat locations[locCount];
    for (int i = 0; i < [normalGradientLocations count]; i++)
    {
        NSNumber *location = [normalGradientLocations objectAtIndex:i];
        locations[i] = [location floatValue];
    }
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef normalGradient = CGGradientCreateWithColors(space, (CFArrayRef)normalGradientColors, locations);
    CGColorSpaceRelease(space);
    
    return normalGradient;
}
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
