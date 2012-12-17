//
//  WebViewController.m
//  MuyingYongpin
//
//  Created by zhang kai on 9/18/12.
//
//

#import "WebViewController.h"
#import "UIWebView+Clean.h"

@interface WebViewController ()
{
    UIWebView *webView;
    UIActivityIndicatorView * activityIndicator;
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
    [activityIndicator release];
    [super dealloc];
}
-(void)showAlert:(NSString *)alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: nil
                          message: alertMessage
                          delegate: self
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil,nil];
    [alert show];
    [alert release];
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
        
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 460 - 44 - 40)];
    webView.scalesPageToFit = YES;
    [webView setDelegate:self];
    
    NSLog(@"%@",productUrlS);
    NSURL *url = [NSURL URLWithString:productUrlS];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    webView.hidden = YES;
    [self.view addSubview:webView];
    
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
    
    UIImageView *shadowView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 320, 1)];
    shadowView.backgroundColor = [UIColor blackColor];
    [shadowView setAlpha:0.3];
    [self.view addSubview:shadowView];
    [shadowView release];
    
    UIImageView *bottomBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 460 - 40, 320, 40)];
    bottomBar.image = [UIImage imageNamed:@"navbar_background"];
    bottomBar.userInteractionEnabled = YES;
    [self.view addSubview:bottomBar];
    [bottomBar release];
    
    UIButton *leftArrow = [[UIButton alloc]initWithFrame:CGRectMake(40, 0, 40, 40)];
    [leftArrow setImage:[UIImage imageNamed:@"web_tab_back"] forState:UIControlStateNormal];
    [leftArrow addTarget:self action:@selector(webGoback) forControlEvents:UIControlEventTouchDown];
//    leftArrow.backgroundColor = [UIColor blueColor];
    leftArrow.showsTouchWhenHighlighted = YES;
    [bottomBar addSubview:leftArrow];
    [leftArrow release];
    
    UIButton *rightArrow = [[UIButton alloc]initWithFrame:CGRectMake(140, 0, 40, 40)];
    [rightArrow setImage:[UIImage imageNamed:@"web_tab_forward"] forState:UIControlStateNormal];
    [rightArrow addTarget:self action:@selector(webGoforward) forControlEvents:UIControlEventTouchDown];
//    rightArrow.backgroundColor = [UIColor blueColor];
    rightArrow.showsTouchWhenHighlighted = YES;
    [bottomBar addSubview:rightArrow];
    [rightArrow release];
    
    UIButton *refreshButton = [[UIButton alloc]initWithFrame:CGRectMake(250, 0, 40, 40)];
    [refreshButton setImage:[UIImage imageNamed:@"button_refresh"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(webRefresh) forControlEvents:UIControlEventTouchDown];
//    refreshButton.backgroundColor = [UIColor blueColor];
    refreshButton.showsTouchWhenHighlighted = YES;
    [bottomBar addSubview:refreshButton];
    [refreshButton release];
    
    UIImageView *shadowView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 460 - 40 - 1, 320, 1)];
    shadowView2.backgroundColor = [UIColor blackColor];
    [shadowView2 setAlpha:0.1];
    [self.view addSubview:shadowView2];
    [shadowView2 release];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(285, 12, 20, 20)];
    //set the initial property
    [activityIndicator startAnimating];
    [activityIndicator hidesWhenStopped];
    [topBar addSubview:activityIndicator];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
-(void)webGoback
{
    [webView goBack];
}
-(void)webGoforward
{
    [webView goForward];
}
-(void)webRefresh
{
    [webView reload];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [self hideUnwantedHTML];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self showAlert:[error description]];
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
        
    [webView stringByEvaluatingJavaScriptFromString:@"hideID('h5back_btn');"
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
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [activityIndicator stopAnimating];
    webView.hidden = NO;
}
-(void)goBack
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
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
