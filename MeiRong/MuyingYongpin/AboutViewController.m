//
//  AboutViewController.m
//  TaoZhuang
//
//  Created by zhang kai on 3/27/13.
//
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

-(id) initWithTabBar {
    if ([self init]) {        
        
        // set the long name shown in the navigation bar at the top
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 160, 30)];
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        titleLabel.font = [UIFont fontWithName:@"迷你简黛玉" size:25];
        titleLabel.shadowColor   = [[UIColor blackColor]colorWithAlphaComponent: 0.2f];
        titleLabel.shadowOffset  = CGSizeMake(1.0,1.0);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"关于我们";
        [self.navigationItem setTitleView:titleLabel];
        [titleLabel release];
    }
    return self;
    
}
-(void)createNavBackButton
{
    UIImage *buttonImageNormal = [UIImage imageNamed:@"button_back"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 49, 44);
    [backButton setImage:buttonImageNormal forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self createNavBackButton];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SheetBackground"]];
    
    UILabel *desLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 300, 30)];
    desLabel.text = @"＊淘吧出品，必属精品＊";
    [desLabel setTextAlignment:UITextAlignmentCenter];
    desLabel.textColor = [UIColor blackColor];
    desLabel.font = [UIFont fontWithName:@"迷你简黛玉" size:20];
    desLabel.shadowColor   = [[UIColor whiteColor]colorWithAlphaComponent: 0.2f];
    desLabel.shadowOffset  = CGSizeMake(1.0,1.0);
    desLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:desLabel];
    [desLabel release];
    
    UILabel *desLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 300, 200)];
    desLabel2.text = @"    爱美丽女生必备的淘宝利器，每天数万件化妆品推荐，看到就可以买到！"
    "时尚女生逛淘宝必备应用，让你变得更美丽！"
    "掌握最前沿的时尚潮流，做最美丽的自己！"
    "淘妆是为爱美女性量身打造的一款淘宝化妆品精选应用，覆盖了护肤、彩妆、香水、美体、美发等类别，基于淘宝网权威的"
    "销售数据和淘妆团队的买手精选，帮你发现最TOP的时尚美妆，最TOP的美妆销量排行榜！"
    "做最美丽的你！";
    desLabel2.textColor = [UIColor blackColor];
    desLabel2.font = [UIFont systemFontOfSize:15];
    desLabel2.numberOfLines = 0;
    desLabel2.lineBreakMode = UILineBreakModeWordWrap;
    desLabel2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:desLabel2];
    [desLabel2 release];
    
    UILabel *contactLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 255, 300, 30)];
    contactLabel.text = @"合作QQ: 176776005";
    contactLabel.textColor = [UIColor blackColor];
    contactLabel.font = [UIFont systemFontOfSize:15];
    contactLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contactLabel];
    [contactLabel release];
}
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
