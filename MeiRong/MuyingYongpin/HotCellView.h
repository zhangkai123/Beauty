//
//  HotCellView.h
//  MuyingYongpin
//
//  Created by zhang kai on 10/19/12.
//
//

#import <UIKit/UIKit.h>
#import "TouchableImageView.h"
#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"
#import "SDWebImageManager.h"

@class HotCellView;
@protocol HotCellViewDelegate

- (void)hotCellViewWasSelected:(HotCellView *)hotCellView;

@end

@interface HotCellView : UIView <SDWebImageManagerDelegate,TouchableImageViewSelectionDelegate>
{
    TouchableImageView *myImageView;
    id<HotCellViewDelegate> delegate;
}

@property(nonatomic,retain) TouchableImageView *myImageView;
@property(nonatomic,assign) id<HotCellViewDelegate> delegate;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
