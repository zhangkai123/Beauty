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
    UIButton *temButton;
    UIWebView *webView;
}
- (void)hideUnwantedHTML;
@end

@implementation WebViewController
@synthesize productUrlS;

-(void)dealloc
{
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
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [webView setDelegate:self];
    
    NSLog(@"%@",productUrlS);
    NSURL *url = [NSURL URLWithString:productUrlS];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
    [self.view addSubview:webView];
    
    temButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    temButton.frame = CGRectMake(10, 10, 60, 30);
    [temButton setTitle:@"Back" forState:UIControlStateNormal];
    [temButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:temButton];
}
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    [self hideUnwantedHTML];
    [self.view addSubview:webView];
    [self.view bringSubviewToFront:temButton];
}
-(void)webViewDidStartLoad:(UIWebView *)theWebView
{
    [webView removeFromSuperview];
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
