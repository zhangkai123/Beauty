//
//  NewsFeedViewController.m
//  MuyingYongpin
//
//  Created by kai zhang on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "NewsWebViewController.h"
#import "NewsCell.h"
#import "DataController.h"
#import "FashionNews.h"
#import "MBProgressHUD.h"

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
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        titleLabel.textColor = [UIColor colorWithRed:1 green: 0.6 blue:0.8 alpha:1];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        titleLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:22];
        titleLabel.shadowColor   = [[UIColor whiteColor]colorWithAlphaComponent: 1.0f];
        titleLabel.shadowOffset  = CGSizeMake(1.0,1.0);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"时尚";
        [self.navigationItem setTitleView:titleLabel];
        [titleLabel release];
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SheetBackground"]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveNews) name:@"NEWS_READY" object:nil];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_background"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setOpaque:1.0];
    }
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460-44-49) style:UITableViewStylePlain];
    theTableView.rowHeight = 180;
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    theTableView.backgroundColor = [UIColor clearColor];
    theTableView.dataSource = self;
    theTableView.delegate = self;
    [self.view addSubview:theTableView];
    
    dataArray = [[NSMutableArray alloc]init];
    DataController *dataController = [DataController sharedDataController];
    [dataController featchRssData];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)recieveNews
{
    DataController *dataController = [DataController sharedDataController];
    [dataArray addObjectsFromArray:dataController.productsArray];

    //nofification is recieved in another thread
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FashionNews *fashionNews = [dataArray objectAtIndex:indexPath.row];
    cell.titleLable.text = fashionNews.title;
    cell.timeLable.text = fashionNews.pubDate;
    cell.contentLable.text = fashionNews.description;
    
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
