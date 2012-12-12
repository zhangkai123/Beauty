//
//  HotCell.h
//  MuyingYongpin
//
//  Created by zhang kai on 9/9/12.
//
//

#import <UIKit/UIKit.h>
#import "TouchableImageView.h"
#import "HotCellView.h"

@class HotCell;

@protocol HotCellSelectionDelegate <NSObject>

-(void)selectTableViewCell:(HotCell *)cell;
-(void)collectProduct:(HotCell *)cell;
-(void)shareProduct:(HotCell *)cell;

@end


@interface HotCell : UITableViewCell<TouchableImageViewSelectionDelegate>
{
    UILabel *desLable;
    UIButton *collectButton;
    UILabel *collectLabel;
    UIButton *sharedButton;
    id<HotCellSelectionDelegate> delegate;
    int rowNum;
    
    HotCellView *coverView;
    TouchableImageView *myImageView;
}

@property(nonatomic,retain) UILabel *desLable;
@property(nonatomic,retain) UIButton *collectButton;
@property(nonatomic,retain) UILabel *collectLabel;
@property(nonatomic,retain) UIButton *sharedButton;
@property(nonatomic,assign) id<HotCellSelectionDelegate> delegate;
@property(nonatomic,assign) int rowNum;

@property(nonatomic,retain) HotCellView *coverView;
@property(nonatomic,retain) TouchableImageView *myImageView;

-(void)diselectCell;
@end
