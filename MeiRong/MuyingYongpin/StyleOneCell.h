//
//  StyleOneCell.h
//  MuyingYongpin
//
//  Created by zhang kai on 9/9/12.
//
//

#import <UIKit/UIKit.h>
#import "TouchableImageView.h"
#import "StyleOneCellView.h"

@class StyleOneCell;

@protocol StyleOneCellSelectionDelegate <NSObject>

-(void)selectTableViewCell:(StyleOneCell *)cell selectedItemAtIndex:(NSInteger)index;

@end

@interface StyleOneCell : UITableViewCell<TouchableImageViewSelectionDelegate>
{
    TouchableImageView *leftImageView;
    TouchableImageView *rightImageView;
    UILabel *priceLabel2;
    UILabel *priceLabelR2;
    UILabel *likeLabel2;
    UILabel *likeLabel2R;
    StyleOneCellView *coverView2;
    int rowNum;
    id<StyleOneCellSelectionDelegate> delegate;
    
    NSString *price;
    NSString *likes;
}
@property(nonatomic,retain) TouchableImageView *leftImageView;
@property(nonatomic,retain) TouchableImageView *rightImageView;
@property(nonatomic,retain) UILabel *priceLabel2;
@property(nonatomic,retain) UILabel *priceLabelR2;
@property(nonatomic,retain) UILabel *likeLabel2;
@property(nonatomic,retain) UILabel *likeLabel2R;
@property(nonatomic,retain) StyleOneCellView *coverView2;
@property(nonatomic,assign) int rowNum;
@property(nonatomic,assign) id<StyleOneCellSelectionDelegate> delegate;

@property(nonatomic,retain) NSString *price;
@property(nonatomic,retain) NSString *likes;

-(void)diselectCell;
@end
