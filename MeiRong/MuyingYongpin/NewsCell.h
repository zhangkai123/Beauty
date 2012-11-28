//
//  NewsCell.h
//  MuyingYongpin
//
//  Created by zhang kai on 9/15/12.
//
//

#import <UIKit/UIKit.h>

@class NewsCell;

@protocol NewsCellDelegate <NSObject>

-(void)selectTableViewCell:(NewsCell *)cell;

@end

@interface NewsCell : UITableViewCell
{
    UILabel *titleLable;
    UILabel *timeLable;
    UILabel *contentLable;
    
    id<NewsCellDelegate> delegate;
    int rowNum;
}
@property(nonatomic,retain) UILabel *titleLable;
@property(nonatomic,retain) UILabel *timeLable;
@property(nonatomic,retain) UILabel *contentLable;

@property(nonatomic,assign) id<NewsCellDelegate> delegate;
@property(nonatomic,assign) int rowNum;
@end
