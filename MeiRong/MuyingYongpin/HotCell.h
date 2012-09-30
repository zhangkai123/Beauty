//
//  HotCell.h
//  MuyingYongpin
//
//  Created by zhang kai on 9/9/12.
//
//

#import <UIKit/UIKit.h>
#import "TouchableImageView.h"

@class HotCell;

@protocol HotCellSelectionDelegate <NSObject>

-(void)selectTableViewCell:(HotCell *)cell;

@end


@interface HotCell : UITableViewCell<TouchableImageViewSelectionDelegate>
{
    TouchableImageView *theImageView;
    UILabel *desLable;
    UIButton *collectButton;
    UIButton *sharedButton;
    id<HotCellSelectionDelegate> delegate;
    int rowNum;
}
@property(nonatomic,retain) TouchableImageView *theImageView;
@property(nonatomic,retain) UILabel *desLable;
@property(nonatomic,retain) UIButton *collectButton;
@property(nonatomic,retain) UIButton *sharedButton;
@property(nonatomic,assign) id<HotCellSelectionDelegate> delegate;
@property(nonatomic,assign) int rowNum;
@end
