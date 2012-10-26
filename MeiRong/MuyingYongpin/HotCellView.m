//
//  HotCellView.m
//  MuyingYongpin
//
//  Created by zhang kai on 10/19/12.
//
//

#import "HotCellView.h"

@implementation HotCellView
@synthesize myImage;

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}
-(UIImage*) MTDContextCreateRoundedMask:(CGRect)rect tl:(CGFloat)radius_tl tr:(CGFloat)radius_tr bl:(CGFloat)radius_bl br:(CGFloat)radius_br theImage:(UIImage *)tImage {
    
    CGContextRef context;
    CGColorSpaceRef colorSpace;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a bitmap graphics context the size of the image
    context = CGBitmapContextCreate( NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast );
    
    // free the rgb colorspace
    CGColorSpaceRelease(colorSpace);
    
    if ( context == NULL ) {
        return NULL;
    }
        
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
    
    CGContextSetShadow(context, CGSizeMake(4,4), 3);
    CGContextAddPath(context, outlinePath);
    CGContextFillPath(context);
    
    CGContextAddPath(context, outlinePath);
    CGContextClip(context);

    
    CGContextDrawImage(context, CGRectMake(0, 100, w, 300), tImage.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    
    return newImage;
}
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
        notFirstDraw = NO;
    }
    return self;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    self.myImage = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

#pragma SDWebImageView
- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
{
    self.myImage = image;
    [self setNeedsLayout];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self performSelectorInBackground:@selector(drawImage:) withObject:image];
}

#pragma drawRect
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (!notFirstDraw) {
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
        
        notFirstDraw = YES;
    }else{
        [self.myImage drawInRect:self.frame];
    }
}
-(void)drawImage:(UIImage *)img
{
    self.myImage = [self MTDContextCreateRoundedMask:self.bounds tl:7.0 tr:7.0 bl:0.0 br:0.0 theImage:img];
    [self setNeedsDisplay];
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
