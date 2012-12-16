//
//  NewsFeedViewController.m
//  MuyingYongpin
//
//  Created by kai zhang on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "NewsWebViewController.h"
#import "DataController.h"
#import "FashionNews.h"
#import "SVPullToRefresh.h"

@interface NewsFeedViewController()
{
    UIView *bgColorView;
    UITableViewCell *selectedCell;
}
@end

@implementation NewsFeedViewController
-(void)dealloc
{
    [theTableView release];
    [dataArray release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(id) initWithTabBar {
    if ([self init]) {
        //this is the label on the tab button itself
        self.title = @"时尚";
        
        //use whatever image you want and add it to your project
        self.tabBarItem.image = [UIImage imageNamed:@"iconAppsTab"];
        
        // set the long name shown in the navigation bar at the top
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 220, 30)];
//        titleLabel.textColor = [UIColor colorWithRed:1 green: 0.6 blue:0.8 alpha:1];
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        titleLabel.font = [UIFont fontWithName:@"迷你简黛玉" size:25];
        titleLabel.shadowColor   = [[UIColor blackColor]colorWithAlphaComponent: 0.2f];
        titleLabel.shadowOffset  = CGSizeMake(1.0,1.0);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"时尚";
        [self.navigationItem setTitleView:titleLabel];
        [titleLabel release];

        [self createActivity];
    }
    return self;
    
}
-(void)startActivity{
    
    UIActivityIndicatorView *activityView = [[[self navigationItem].rightBarButtonItem.customView subviews]objectAtIndex:0];
    [activityView startAnimating];
}

-(void)stopActivity{
    
    UIActivityIndicatorView *activityView = [[[self navigationItem].rightBarButtonItem.customView subviews]objectAtIndex:0];
    [activityView stopAnimating];
}

-(void)createActivity
{
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [activityIndicator stopAnimating];
    [activityIndicator hidesWhenStopped];
    UIView *rightItem = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    [rightItem addSubview:activityIndicator];
    [activityIndicator release];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    [self navigationItem].rightBarButtonItem = barButton;
    [rightItem release];
    [barButton release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SheetBackground"]];
    
    //for tableview selected color
    bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:1 green:0.6 blue:0.8 alpha:1.0]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveNews:) name:@"NEWS_READY" object:nil];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_background"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setOpaque:1.0];
    }
//    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, self.navigationController.navigationBar.frame.size.height, 0);
    
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460-44-49) style:UITableViewStylePlain];
    theTableView.rowHeight = 180;
    [theTableView setSeparatorStyle:UITableViewCellSelectionStyleNone];
    theTableView.backgroundColor = [UIColor clearColor];
    theTableView.dataSource = self;
    theTableView.delegate = self;
//    theTableView.scrollIndicatorInsets = insets;
//    theTableView.contentInset = insets;
    [self.view addSubview:theTableView];
    
    __block UITableView *weaktheTalbleView = theTableView;
    [theTableView addPullToRefreshWithActionHandler:^{
        
        if (weaktheTalbleView.pullToRefreshView.state == SVPullToRefreshStateLoading)
            NSLog(@"Pull to refresh is loading");
        DataController *dataController = [DataController sharedDataController];
        [dataController featchRssData];
    }];

    dataArray = [[NSMutableArray alloc]init];
    DataController *dataController = [DataController sharedDataController];
    [dataController featchRssData];
    
    [self startActivity];
}
-(void)recieveNews:(NSNotification *)notification
{
    if ([[notification object]count] == 0) {
        //nofification is recieved in another thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [theTableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
            [self stopActivity];
            return;
        });
    }
    [dataArray removeAllObjects];
    [dataArray addObjectsFromArray:[notification object]];
    
    //nofification is recieved in another thread
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [theTableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
        [self stopActivity];
        [theTableView reloadData];
    });
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
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
        cell.delegate = self;
        [cell setSelectedBackgroundView:bgColorView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FashionNews *fashionNews = [dataArray objectAtIndex:indexPath.row];
    cell.titleLable.text = fashionNews.title;
    cell.timeLable.text = fashionNews.pubDate;
    cell.contentLable.text = fashionNews.description;
    cell.rowNum = indexPath.row;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FashionNews *fashionNews = [dataArray objectAtIndex:indexPath.row];
    NewsWebViewController *newsWebViewController = [[NewsWebViewController alloc]init];
    newsWebViewController.newsUrls = fashionNews.link;
    [self presentModalViewController:newsWebViewController animated:YES];
    [newsWebViewController release];
}
#pragma NewsCellDelegate
-(void)selectTableViewCell:(NewsCell *)cell
{
    selectedCell = cell;
    FashionNews *fashionNews = [dataArray objectAtIndex:cell.rowNum];
    NewsWebViewController *newsWebViewController = [[NewsWebViewController alloc]init];
    newsWebViewController.newsUrls = fashionNews.link;
    [self presentModalViewController:newsWebViewController animated:YES];
    [newsWebViewController release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [dataArray count] - 1) {
        return 200;
    }else{
        return 180;
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [theTableView deselectRowAtIndexPath:[theTableView indexPathForSelectedRow] animated:YES];
    if (selectedCell != nil) {
        [(NewsCell *)selectedCell diselectCell];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
