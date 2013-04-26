//
//  NavRootViewController.m
//  TaoZhuang
//
//  Created by zhang kai on 4/26/13.
//
//

#import "NavRootViewController.h"

@interface NavRootViewController ()

@end

@implementation NavRootViewController

-(void)dealloc
{
    [titleLabel release];
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

#pragma mark - View lifecycle
-(id) initWithNavBar {
    if ([self init]) {
        // set the long name shown in the navigation bar at the top
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 220, 30)];
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        titleLabel.font = [UIFont fontWithName:@"迷你简黛玉" size:25];
        titleLabel.shadowColor   = [[UIColor blackColor]colorWithAlphaComponent: 0.2f];
        titleLabel.shadowOffset  = CGSizeMake(1.0,1.0);
        titleLabel.backgroundColor = [UIColor clearColor];
        [self.navigationItem setTitleView:titleLabel];
        
        UIImage *buttonImageNormal = [UIImage imageNamed:@"btn_header_back"];
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 49, 44);
        [backButton setImage:buttonImageNormal forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backButtonItem;
        [backButtonItem release];
    }
    return self;
}
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_background"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setOpaque:1.0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
