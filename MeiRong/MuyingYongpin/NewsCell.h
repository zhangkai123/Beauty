//
//  NewsCell.h
//  MuyingYongpin
//
//  Created by zhang kai on 9/15/12.
//
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell
{
    UILabel *titleLable;
    UILabel *timeLable;
    UILabel *contentLable;
}
@property(nonatomic,retain) UILabel *titleLable;
@property(nonatomic,retain) UILabel *timeLable;
@property(nonatomic,retain) UILabel *contentLable;
@end
