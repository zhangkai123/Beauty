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
    
    CGContextSetShadow(ctx, CGSizeMake(4,4), 3);
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

@end
