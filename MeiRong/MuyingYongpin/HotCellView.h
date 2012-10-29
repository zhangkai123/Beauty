//
//  HotCellView.h
//  MuyingYongpin
//
//  Created by zhang kai on 10/19/12.
//
//

#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"
#import "SDWebImageManager.h"

@interface HotCellView : UIView <SDWebImageManagerDelegate>
{
    UIImage *myImage;
    UIImage *myHolderImage;
    BOOL notFirstDraw;
    
    CGMutablePathRef outlinePath;
    UIImage *coverImage;
}
@property(nonatomic,retain) UIImage *myImage;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
