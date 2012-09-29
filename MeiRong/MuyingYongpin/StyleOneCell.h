//
//  StyleOneCell.h
//  MuyingYongpin
//
//  Created by zhang kai on 9/9/12.
//
//

#import <UIKit/UIKit.h>
#import "TouchableImageView.h"

@class StyleOneCell;

@protocol StyleOneCellSelectionDelegate <NSObject>

-(void)selectTableViewCell:(StyleOneCell *)cell selectedItemAtIndex:(NSInteger)index;

@end

@interface StyleOneCell : UITableViewCell<TouchableImageViewSelectionDelegate>
{
    TouchableImageView *leftImageView;
    TouchableImageView *rightImageView;
    int rowNum;
    id<StyleOneCellSelectionDelegate> delegate;
}
@property(nonatomic,retain) TouchableImageView *leftImageView;
@property(nonatomic,retain) TouchableImageView *rightImageView;
@property(nonatomic,assign) int rowNum;
@property(nonatomic,assign) id<StyleOneCellSelectionDelegate> delegate;
@end
