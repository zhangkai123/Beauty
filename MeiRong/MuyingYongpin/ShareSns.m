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
                                      status:@"haha"
                                       image:myImage
                                    platform:umShareToType];
}

#pragma mark - UMSNSShowActionSheetDelegate method
- (BOOL)shouldShowInActionSeet:(UMShareToType)platform
{
    if (platform == UMShareToTypeRenr) {
        return NO;
    }
    else {
        return YES;
    }
}


#pragma mark - UMSNSDataSendDelegate method

- (void)dataSendDidFinish:(UIViewController *)aViewController andReturnStatus:(UMReturnStatusType)returnStatus andPlatformType:(UMShareToType)platfrom{
    
    [aViewController dismissModalViewControllerAnimated:YES];
}

- (NSString *)invitationContent:(UMShareToType)platfrom {
    
    return @"私信邀请！";
}

- (void)willSendStatus:(NSString *)status{
    NSLog(@"will send status is %@",status);
}

- (BOOL)shouldShowAppInfor:(UMShareToType)platfrom {
    
//    if (platfrom == UMShareToTypeRenr)
//    {
//        return NO;
//    }
//    else
//    {
//        return YES;
//    }
    return NO;
}

- (NSDictionary *)appInfor:(UMShareToType)platfrom {
    
    if (platfrom == UMShareToTypeSina)
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:@"新浪微博", @"name", @"北京", @"location", @"播报每日全球各类重要资讯", @"description", @"1950956950", @"uid", nil];
    }
    else if (platfrom == UMShareToTypeTenc)
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:@"腾讯微博", @"name", @"上海", @"location", @"@Innovation-Works iOS-Dev", @"description", @"freedomtest", @"uid", nil];
    }
    else
    {
        return nil;
    }
}



- (BOOL)privateMsgInvitationEnabled:(UMShareToType)platfrom {
    if (platfrom == UMShareToTypeTenc)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)insertTopicEnabled:(UMShareToType)platfrom {
    
    return YES;
}

- (BOOL)atSomebodyEnabled:(UMShareToType)platfrom {
    
    return YES;
}

- (BOOL)insertEmotionEnabled:(UMShareToType)platfrom {
    
    return YES;
}

- (BOOL)priviteMessageEnabled:(UMShareToType)platfrom {
    
    return NO;
}

- (BOOL)textCountCheckEnabled:(UMShareToType)platfrom {
    
    return NO;
}

@end
