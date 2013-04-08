//
//  ProductCell.h
//  TaoZhuang
//
//  Created by zhang kai on 4/9/13.
//
//

#import "PSCollectionViewCell.h"
#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"
#import "SDWebImageManager.h"

@interface ProductCell : PSCollectionViewCell<SDWebImageManagerDelegate>

@property(nonatomic,retain) UIImage *myImage;

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;
- (void)cancelCurrentImageLoad;
@end
