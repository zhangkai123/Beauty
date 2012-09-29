//
//  NewsWebViewController.h
//  MuyingYongpin
//
//  Created by zhang kai on 9/26/12.
//
//

#import <UIKit/UIKit.h>

@interface NewsWebViewController : UIViewController<UIWebViewDelegate>
{
    NSString *newsUrls;
}

@property(nonatomic,copy) NSString *newsUrls;
@end
