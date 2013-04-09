//
//  ProductCell.m
//  TaoZhuang
//
//  Created by zhang kai on 4/9/13.
//
//

#import "ProductCell.h"

@implementation ProductCell
@synthesize myImageView = _myImageView ,imageHeight = _imageHeight;
//@synthesize myImage = _myImage;
-(void)dealloc
{
//    [_myImage release];
    [_myImageView release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor yellowColor];
        
        _myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_myImageView];
    }
    return self;
}
-(void)setImageHeight:(float)imageHeight
{
    _imageHeight = imageHeight;
    _myImageView.frame = CGRectMake(0, 0, 148, _imageHeight);
}

//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    [_myImage drawInRect:rect];
//}
//
//- (void)setImageWithURL:(NSURL *)url
//{
//    [self setImageWithURL:url placeholderImage:nil];
//}
//
//- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
//{
//    [self setImageWithURL:url placeholderImage:placeholder options:0];
//}
//
//- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
//{
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    
//    // Remove in progress downloader from queue
//    [manager cancelForDelegate:self];
//    
//    self.myImage = placeholder;
//    [self setNeedsDisplay];
//    
//    if (url)
//    {
//        [manager downloadWithURL:url delegate:self options:options];
//    }
//}
//
//- (void)cancelCurrentImageLoad
//{
//    [[SDWebImageManager sharedManager] cancelForDelegate:self];
//}
//
//- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
//{
//    self.myImage = image;
//    [self setNeedsDisplay];
//}
//
//- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
//{
//    self.myImage = image;
//    [self setNeedsDisplay];
//}

@end
