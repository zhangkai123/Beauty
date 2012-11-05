//
//  ShareSns.h
//  MuyingYongpin
//
//  Created by zhang kai on 10/14/12.
//
//

#import <Foundation/Foundation.h>
#import "UMSNSService.h"

@interface ShareSns : NSObject<UIActionSheetDelegate ,UMSNSViewDisplayDelegate ,UMSNSDataSendDelegate>
{
    UIActionSheet *snsActionSheet;
}
-(void)showSnsShareSheet:(UIView *)myView viewController:(UIViewController *)myViewController shareImage:(UIImage *)sImage shareText:(NSString *)sText;
@end
