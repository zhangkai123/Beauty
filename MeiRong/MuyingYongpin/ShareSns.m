//
//  ShareSns.m
//  MuyingYongpin
//
//  Created by zhang kai on 10/14/12.
//
//

#import "ShareSns.h"

#define useAppkey @"5065b5735270151341000065"

@interface ShareSns()
{
    UIViewController *viewController;
    UIImage *myImage;
}
@end

@implementation ShareSns

+(ShareSns *)shareSnsSingleton
{
    static ShareSns *shareSns;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shareSns = [[ShareSns alloc]init];
    });
    return shareSns;
}

-(id)init
{
    if (self = [super init]) {
        snsActionSheet = [[UIActionSheet alloc] initWithTitle:@"SNS分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"腾讯微薄",@"人人网",nil];
    }
    return self;
}
-(void)showSnsShareSheet:(UIView *)myView viewController:(UIViewController *)myViewController shareImage:(UIImage *)sImage
{
    [snsActionSheet showInView:myView];
    viewController = myViewController;
    myImage = sImage;
}

#pragma mark - UIActionSheetDelegate method
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >2) {
        return;
    }
    UMShareToType umShareToType = buttonIndex;
    
    [UMSNSService setViewDisplayDelegate:self];
    [UMSNSService setDataSendDelegate:self];
    [UMSNSService presentSNSInController:viewController
                                      appkey:useAppkey
                                      status:@"fuck haha"
                                       image:myImage
                                    platform:umShareToType];
}

@end
