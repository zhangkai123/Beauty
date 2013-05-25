//
//  ViewController.m
//  MuyingYongpin
//
//  Created by kai zhang on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import "TopicViewController.h"
#import "UIImageView+WebCache.h"
#import "TopicProductViewController.h"
#import "Story.h"
#import "DataController.h"
#import "WebViewController.h"  
#import "SVPullToRefresh.h"
#import "NewCategoryProductViewController.h"

@interface TopicViewController()
{
    UITableViewCell *selectedCell;
    BOOL finishLoad;
    BOOL refresh;
}
@end

@implementation TopicViewController

- (void)didReceiveMemoryWarning
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];

    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(id) initWithNavBar {
    if (self = [super initWithNavBar]) {
        //this is the label on the tab button itself
        self.title = @"专题";
        
        //use whatever image you want and add it to your project
        self.tabBarItem.image = [UIImage imageNamed:@"ico_nav_special"];

        titleLabel.text = @"专题";
        
        backButton.hidden = YES;
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
    rightItem.backgroundColor = [UIColor clearColor];
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveStories:) name:@"Story_Ready" object:nil];
        
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        productTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 548-44-49) style:UITableViewStylePlain];
    } else {
        // code for 3.5-inch screen
        productTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 460-44-49) style:UITableViewStylePlain];
    }
    productTableView.backgroundColor = [UIColor clearColor];
    [productTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
///    productTableView.showsVerticalScrollIndicator = NO;
    productTableView.delegate = self;
    productTableView.dataSource = self;
    productTableView.rowHeight = 380;
    [self.view addSubview:productTableView];
    
     storiesArray = [[NSMutableArray alloc]init];
    
    __block UITableView *weaktheTalbleView = productTableView;
    __block NSMutableArray *weakproductsArray = storiesArray;
    __block NSInteger weakCurrentPage = currentPage;
    
    //add the pull fresh and add more data
    // setup the pull-to-refresh view
    [productTableView addPullToRefreshWithActionHandler:^{
        
        refresh = YES;
        if (weaktheTalbleView.pullToRefreshView.state == SVPullToRefreshStateLoading)
            NSLog(@"Pull to refresh is loading");
        //[weakproductsArray removeAllObjects];
        weakCurrentPage = 0;
        DataController *dataController = [DataController sharedDataController];
        [dataController featchStories:1];
    }];
    [productTableView addInfiniteScrollingWithActionHandler:^{
        
        refresh = NO;
        if (!finishLoad) {
            return;
        }
        finishLoad = NO;
        int productN = [weakproductsArray count];
        int pageN;
        if (productN % 20 == 0) {
            pageN = productN / 20;
        }
        else{
            [weaktheTalbleView.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
            return;
        }
        DataController *dataController = [DataController sharedDataController];
        [dataController featchStories:pageN + 1];
        weakCurrentPage = pageN;
    }];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SheetBackground"]];
    
    DataController *dataController = [DataController sharedDataController];
    [dataController featchStories:1];
    
    [self startActivity];
}
-(void)recieveStories:(NSNotification *)notification
{
    finishLoad = YES;
    NSMutableArray *myArray = [notification object];
    [myArray retain];
    
    if ([myArray count] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [productTableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
            [productTableView.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
            [self stopActivity];
        });
        [myArray release];
        return;
    }
    if (refresh) {
        [storiesArray removeAllObjects];
    }
    
    int currentCount = [storiesArray count];
    NSMutableArray *rowsInsertIndexPath = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [myArray count]; i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:currentCount + i inSection:0];
        [rowsInsertIndexPath addObject:tempIndexPath];
    }
    [storiesArray addObjectsFromArray:myArray];
    [myArray release];
    
    //nofification is recieved in another thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [productTableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
        [productTableView.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
        [self stopActivity];
        if (refresh) {
            [productTableView reloadData];
        }else{
            if (currentCount == 0) {
                [productTableView insertRowsAtIndexPaths:rowsInsertIndexPath withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [productTableView insertRowsAtIndexPaths:rowsInsertIndexPath withRowAnimation:UITableViewRowAnimationRight];
            }
            [rowsInsertIndexPath release];
        }
    });
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [storiesArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[HotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
    }
    cell.delegate = self;
    cell.rowNum = indexPath.row;
    Story *story = [storiesArray objectAtIndex:indexPath.row];
    [cell.myImageView setImageWithURL:[NSURL URLWithString:story.imagePath] placeholderImage:[UIImage imageNamed:@"bPlaceHolder.png"]];
    cell.titleLable.text = story.title;
    cell.articleLable.text = story.article;
    return cell;
}
#pragma HotCellSelectionDelegate
-(void)selectTableViewCell:(HotCell *)cell
{
    selectedCell = cell;
    Story *story = [storiesArray objectAtIndex:cell.rowNum];
        
    NewCategoryProductViewController *newCategoryProductViewController = [[NewCategoryProductViewController alloc]initWithNavBar];
    newCategoryProductViewController.hidesBottomBarWhenPushed = YES;
    newCategoryProductViewController.catName = story.keyWord;
    newCategoryProductViewController.catId = story.categoryId;
    [self.navigationController pushViewController:newCategoryProductViewController animated:YES];
    [newCategoryProductViewController release];
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
    [productTableView deselectRowAtIndexPath:[productTableView indexPathForSelectedRow] animated:YES];
    if (selectedCell != nil) {
        [(HotCell *)selectedCell diselectCell];
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
    return NO;
}

@end
