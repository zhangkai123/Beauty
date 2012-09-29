//
//  WebViewController.h
//  MuyingYongpin
//
//  Created by zhang kai on 9/18/12.
//
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>
{
    NSString *productUrlS;
}

@property(nonatomic,copy) NSString *productUrlS;
@end
