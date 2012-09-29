//
//  NewsWebViewController.m
//  MuyingYongpin
//
//  Created by zhang kai on 9/26/12.
//
//

#import "NewsWebViewController.h"
#import "UIWebView+Clean.h"

@interface NewsWebViewController ()
{
    UIWebView *webView;
}
@end

@implementation NewsWebViewController
@synthesize newsUrls;

-(void)dealloc
{
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
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    webView.scalesPageToFit = YES;
    [webView setDelegate:self];
    
    NSURL *url = [NSURL URLWithString:newsUrls];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
    [self.view addSubview:webView];
    
    UIButton *temButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    temButton.frame = CGRectMake(10, 10, 60, 30);
    [temButton setTitle:@"Back" forState:UIControlStateNormal];
    [temButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:temButton];
}
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    
}
-(void)goBack
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
