//
//  SetupViewController.m
//  TaoZhuang
//
//  Created by zhang kai on 3/21/13.
//
//

#import "SetupViewController.h"

@interface SetupViewController ()

@end

@implementation SetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self createNavBackButton];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SheetBackground"]];
    
    // set the long name shown in the navigation bar at the top
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 220, 30)];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    titleLabel.font = [UIFont fontWithName:@"迷你简黛玉" size:25];
    titleLabel.shadowColor   = [[UIColor blackColor]colorWithAlphaComponent: 0.2f];
    titleLabel.shadowOffset  = CGSizeMake(1.0,1.0);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"设置";
    [self.navigationItem setTitleView:titleLabel];
    [titleLabel release];

    NSArray *dArray = [NSArray arrayWithObjects:@"关于我们", @"意见反馈", @"检查更新", @"亲，给个评价吧", @"清除缓存",nil];
    dataArray = [[NSMutableArray alloc]initWithArray:dArray];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        setupableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 548-44-49) style:UITableViewStyleGrouped];
    } else {
        // code for 3.5-inch screen
        setupableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 460-44-49) style:UITableViewStyleGrouped];
    }
    setupableView.backgroundView = nil;
    [setupableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    ///    setupableView.showsVerticalScrollIndicator = NO;
    setupableView.delegate = self;
    setupableView.dataSource = self;
    [self.view addSubview:setupableView];
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
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
    }
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
