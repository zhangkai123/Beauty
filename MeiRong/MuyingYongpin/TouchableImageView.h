//
//  TouchableImageView.h
//  MuyingYongpin
//
//  Created by zhang kai on 9/11/12.
//
//

#import <UIKit/UIKit.h>

@class TouchableImageView;

@protocol TouchableImageViewSelectionDelegate <NSObject>
- (void)touchableImageViewViewWasSelected:(TouchableImageView *)thumbnailImageView;
@end

@interface TouchableImageView : UIImageView
{
    id<TouchableImageViewSelectionDelegate> delegate;
}
@property(nonatomic,assign) id<TouchableImageViewSelectionDelegate> delegate;
@end
