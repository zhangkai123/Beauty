//
//  SetupViewController.h
//  TaoZhuang
//
//  Created by zhang kai on 3/21/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "NavRootViewController.h"

@interface SetupViewController : NavRootViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>
{
    UITableView *setupableView;
    NSMutableArray *dataArray;
}
@end
