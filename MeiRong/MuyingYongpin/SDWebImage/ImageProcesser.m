//
//  ImageProcesser.m
//  MuyingYongpin
//
//  Created by zhang kai on 10/30/12.
//
//

#import "ImageProcesser.h"

#define PROCESSED_IMAGE_KEY @"processedImage"
#define PROCESS_INFO_KEY @"processInfo"

#define IMAGE_KEY @"image"
#define DELEGATE_KEY @"delegate"

@implementation ImageProcesser
static ImageProcesser *sharedInstance;

- (void)dealloc
{
    SDWISafeRelease(imageProcessQueue);
    SDWISuperDealoc;
}

+(ImageProcesser *)sharedImageProcesser
{
    if (!sharedInstance)
    {
        sharedInstance = [[ImageProcesser alloc] init];
    }
    return sharedInstance;
}
- (id)init
{
    if ((self = [super init]))
    {
        // Initialization code here.
        imageProcessQueue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

-(void)processImage:(UIImage *)image withDelegate:(id<ImageProcesserDelegate>)delegate 
{
    NSDictionary *processInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                image, IMAGE_KEY,
                                delegate, DELEGATE_KEY,nil];
    
    NSOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(processImageWithInfo:) object:processInfo];
    [imageProcessQueue addOperation:operation];
    SDWIRelease(operation);
}
-(void)processImageWithInfo:(NSDictionary *)processInfo
{
    UIImage *image = [processInfo objectForKey:IMAGE_KEY];
    
    UIImage *processedImage = [image imageWithRoundedCorners:30 alphaBackground:[UIColor blueColor]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          processedImage, PROCESSED_IMAGE_KEY,
                          processInfo,PROCESS_INFO_KEY,nil];
    
    [self performSelectorOnMainThread:@selector(notifyDelegateOnMainThreadWithInfo:) withObject:dict waitUntilDone:NO];
}
- (void)notifyDelegateOnMainThreadWithInfo:(NSDictionary *)dict
{
    SDWIRetain(dict);
    NSDictionary *processInfo = [dict objectForKey:PROCESS_INFO_KEY];
    UIImage *processedImage = [dict objectForKey:PROCESSED_IMAGE_KEY];
    
    id <ImageProcesserDelegate> delegate = [processInfo objectForKey:DELEGATE_KEY];
    
    [delegate imageProcess:self didFinishProcessImage:processedImage];
    SDWIRelease(dict);
}

@end

@implementation UIImage (RoundedCorners)

/**
 *	Takes a image, gives it rounded corners and returns it
 *	@param	radius The size of the corners
 *	@param	aColor The color of the area outside the masked area, pass nil or clearColor
 *	@return A newly masked image
 */
-(UIImage*) imageWithRoundedCorners:(CGFloat) radius alphaBackground:(UIColor*) aColor
{
    return [self imageWithSize:CGSizeMake(300, 300)//[self size]
						 block:^(CGContextRef context) {
                             
							 CGImageRef	mask,imageMask,maskedImage;
							 CGPathRef	path;
							 CGRect		rect	= CGRectZero;
                             
//							 rect.size = [self size];
                             rect.size = CGSizeMake(300, 300);
                             
							 //Create a path
							 path = [self newPathForRoundedRect:rect
														 radius:radius];
                             
							 //Fill the rect with a backing color
							 CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
							 CGContextFillRect(context, rect);
                             
							 // Add the path
							 CGContextAddPath(context, path);
                             
							 // Fill the path
							 CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
							 CGContextFillPath(context);
                             
							 imageMask = CGBitmapContextCreateImage(context);
                             
							 //Reset the context
							 CGContextClearRect(context,rect);
                             
							 mask = CGImageMaskCreate(
                                                      CGImageGetWidth(imageMask),
                                                      CGImageGetHeight(imageMask),
                                                      CGImageGetBitsPerComponent(imageMask),
                                                      CGImageGetBitsPerPixel(imageMask),
                                                      CGImageGetBytesPerRow(imageMask),
                                                      CGImageGetDataProvider(imageMask),
                                                      NULL,
                                                      false
                                                      );
                             
							 if( !mask ){
                                 //Log failure
//                                 DDLogWarn(@"Mask failed");
                             }
                             
							 //Mask the image
							 maskedImage = CGImageCreateWithMask([self CGImage], mask);
                             
							 //Set a possible background fill color
							 if( aColor ){
								 //Fill the rect with the background color
								 CGContextSetFillColorWithColor(context, [aColor CGColor]);
                                 
								 CGContextFillRect(context, rect);								 
							 }
                             
							 //Then draw the masked image
							 CGContextDrawImage(context, rect, maskedImage);
                             
							 //Clean up
							 CGImageRelease(maskedImage);
							 CGPathRelease(path);
                             
						 }];
    
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
-(UIImage*) imageWithSize:(CGSize) aSize block:(void(^)(CGContextRef ctx)) aBlock{
    
	CGContextRef		context;
	void				*bitmapData;
	CGColorSpaceRef		colorSpace;
	int					bitmapByteCount;
	int					bitmapBytesPerRow;
	CGImageRef			image;
	UIImage				*finalImage;
    
	//mask the image with the path
	bitmapBytesPerRow	= (aSize.width * 4);
	bitmapByteCount		= (bitmapBytesPerRow * aSize.height);
    
	//Create the color space
	colorSpace = CGColorSpaceCreateDeviceRGB();
//    colorSpace = CGColorSpaceCreateDeviceGray();
    
	bitmapData = malloc( bitmapByteCount );
    
	//Check the the buffer is alloc'd
	if( bitmapData == NULL ){
//		DebugLog(@"Buffer could not be alloc'd");
	}
    
	//Create the context
	context = CGBitmapContextCreate(bitmapData, aSize.width, aSize.height, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    
	if( context == NULL ){
//		DebugLog(@"Context could not be created");
	}
    
	//Run the block
	aBlock( context );
    
	//transer the data into an UIImage so we can cleanup
	image = CGBitmapContextCreateImage(context);
    
	finalImage = [UIImage imageWithCGImage:image];
    
	CGImageRelease(image);
    
	//Clean up
	free(bitmapData);
	CGColorSpaceRelease(colorSpace);
	CGContextRelease(context);
    
	return finalImage;
}
@end



