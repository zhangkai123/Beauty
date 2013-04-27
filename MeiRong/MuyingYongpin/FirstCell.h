//
//  FirstCell.h
//  TaoZhuang
//
//  Created by zhang kai on 3/23/13.
//
//

#import "DetailImageCell.h"

@interface FirstCell : UITableViewCell
{
    UIImageView *myImageView;
}
@property(nonatomic,retain) UIImageView *myImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageHeight:(float)imageH;
@end
