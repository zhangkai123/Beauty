//
//  NewsWebViewController.m
//  MuyingYongpin
//
//  Created by zhang kai on 9/26/12.
//
//

#import "NewsWebViewController.h"
#import "UIWebView+Clean.h"
#import "MBProgressHUD.h"

@interface NewsWebViewController ()
{
    UIWebView *webView;
}
@end

@implementation NewsWebViewController
@synthesize newsUrls;

-(void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];

    [newsUrls release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [webView cleanForDealloc];
    [webView release];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *topBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    topBar.image = [UIImage imageNamed:@"navbar_background"];
    topBar.userInteractionEnabled = YES;
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"backbutton"];
    UIImage *buttonImageCliced = [UIImage imageNamed:@"backbuttonclicked"];
    UIButton *topBarBackButton = [[UIButton alloc]initWithFrame:CGRectMake(7, 0, 50, 44)];
    [topBarBackButton setImage:buttonImageNormal forState:UIControlStateNormal];
    [topBarBackButton setImage:buttonImageCliced forState:UIControlEventTouchDown];
    [topBarBackButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
    [topBar addSubview:topBarBackButton];
    [self.view addSubview:topBar];
    [topBarBackButton release];
    [topBar release];
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 460 - 44)];
    webView.scalesPageToFit = YES;
    [webView setDelegate:self];
    
    NSURL *url = [NSURL URLWithString:newsUrls];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
    [self.view addSubview:webView];
    
    [MBProgressHUD showHUDAddedTo:webView animated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [MBProgressHUD hideHUDForView:webView animated:YES];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}
-(void)goBack
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
