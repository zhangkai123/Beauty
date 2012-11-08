//
//  WebViewController.m
//  MuyingYongpin
//
//  Created by zhang kai on 9/18/12.
//
//

#import "WebViewController.h"
#import "UIWebView+Clean.h"
#import "MBProgressHUD.h"

@interface WebViewController ()
{
    UIWebView *webView;
}
- (void)hideUnwantedHTML;
@end

@implementation WebViewController
@synthesize productUrlS;

-(void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];

    [productUrlS release];
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
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"Btn_Normal"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    UIButton *topBarBackButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 7, 50, 30)];
    [topBarBackButton setTitle:@"关闭" forState:UIControlStateNormal];
    [topBarBackButton setShowsTouchWhenHighlighted:YES];
    topBarBackButton.titleLabel.font  = [UIFont fontWithName:@"Georgia-Bold" size:12];
    [topBarBackButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [topBarBackButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [topBarBackButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
    [topBar addSubview:topBarBackButton];
    [self.view addSubview:topBar];
    [topBarBackButton release];
    [topBar release];
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 460-44)];
    [webView setDelegate:self];
    
    NSLog(@"%@",productUrlS);
    NSURL *url = [NSURL URLWithString:productUrlS];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
    [self.view addSubview:webView];
    
    [MBProgressHUD showHUDAddedTo:webView animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
//    [self hideUnwantedHTML];
//    [self.view addSubview:webView];
    [MBProgressHUD hideHUDForView:webView animated:NO];
    [self.view addSubview:webView];
}
-(void)webViewDidStartLoad:(UIWebView *)theWebView
{
//    [webView removeFromSuperview];
//    [self hideUnwantedHTML];
    [self hideUnwantedHTML];
}
- (void)hideUnwantedHTML{
    
    [webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
     
     "script.type = 'text/javascript';"
     
     "script.text = \"function hideID(idName) { "
     
     "var id = document.getElementById(idName);"
     
     "id.style.display = 'none';"
     
     "}\";"
     
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"hideID('header');"];
}

-(void)goBack
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
