//
//  HotCell.h
//  MuyingYongpin
//
//  Created by zhang kai on 9/9/12.
//
//

#import <UIKit/UIKit.h>

@interface HotCell : UITableViewCell
{
    UIImageView *theImageView;
    UILabel *desLable;
    UIButton *collectButton;
    UIButton *sharedButton;
}
@property(nonatomic,retain) UIImageView *theImageView;
@property(nonatomic,retain) UILabel *desLable;
@property(nonatomic,retain) UIButton *collectButton;
@property(nonatomic,retain) UIButton *sharedButton;
@end
