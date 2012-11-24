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
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 460-44)];
    webView.scalesPageToFit = YES;
    [webView setDelegate:self];
    
    NSLog(@"%@",productUrlS);
    NSURL *url = [NSURL URLWithString:productUrlS];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    webView.hidden = YES;
    
    [self.view addSubview:webView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [self hideUnwantedHTML];
}
-(void)webViewDidStartLoad:(UIWebView *)theWebView
{
}
- (void)hideUnwantedHTML{
    
    [webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
     
     "script.type = 'text/javascript';"
     
     "script.text = \"function hideID(idName) { "
     
     "var id = document.getElementById(idName);"
     
     "id.style.display = 'none';"
     
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"hideID('header');"
     "window.location = 'fake://myApp/something_happened:param1:param2:param3';"];
}
- (BOOL)webView:(UIWebView *)webView2 shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
	NSString *requestString = [[request URL] absoluteString];
	NSArray *components = [requestString componentsSeparatedByString:@":"];
    
	if ([components count] > 1 &&
		[(NSString *)[components objectAtIndex:0] isEqualToString:@"fake"]) {
        
        [self performSelector:@selector(hideWebview) withObject:nil afterDelay:0.3];
		return NO;
	}
    
	return YES; // Return YES to make sure regular navigation works as expected.
}
-(void)hideWebview
{
    webView.hidden = NO;
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
