//
//  ViewController.m
//  MuyingYongpin
//
//  Created by kai zhang on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import "HotProductViewController.h"
#import "UIImageView+WebCache.h"
#import "Product.h"
#import "DataController.h"
#import "WebViewController.h"  
#import "SVPullToRefresh.h"
#import "CoreDataController.h"
#import "CollectProduct.h"
#import "ShareSns.h"

@interface HotProductViewController()
{
    UITableViewCell *selectedCell;
    BOOL finishLoad;
    BOOL refresh;
}
@end

@implementation HotProductViewController

- (void)didReceiveMemoryWarning
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];

    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(id) initWithTabBar {
    if ([self init]) {
        //this is the label on the tab button itself
        self.title = @"热销单品";
        
        //use whatever image you want and add it to your project
        self.tabBarItem.image = [UIImage imageNamed:@"iconListTab"];

        // set the long name shown in the navigation bar at the top
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 220, 30)];
//        titleLabel.textColor = [UIColor colorWithRed:1 green: 0.6 blue:0.8 alpha:1];
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        titleLabel.font = [UIFont fontWithName:@"迷你简黛玉" size:25];
        titleLabel.shadowColor   = [[UIColor blackColor]colorWithAlphaComponent: 0.2f];
        titleLabel.shadowOffset  = CGSizeMake(1.0,1.0);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"热销单品";
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveHotProducts:) name:@"HOT_PRODUCTS_REARDY" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCollected:) name:@"REFRESH_COLLECTED" object:nil];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_background"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setOpaque:1.0];
    }
    
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
    
     productsArray = [[NSMutableArray alloc]init];
    
    __block UITableView *weaktheTalbleView = productTableView;
    __block NSMutableArray *weakproductsArray = productsArray;
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
        [dataController fetachHotProducts:1];
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
        [dataController fetachHotProducts:pageN + 1];
        weakCurrentPage = pageN;
    }];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SheetBackground"]];
    
    DataController *dataController = [DataController sharedDataController];
    [dataController fetachHotProducts:1];
    
    [self startActivity];
}
-(void)recieveHotProducts:(NSNotification *)notification
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
        [productsArray removeAllObjects];
    }
    for (int i = 0; i < [myArray count]; i++) {
        Product *product = [myArray objectAtIndex:i];
        
        NSManagedObjectContext *context = [[CoreDataController sharedInstance]backgroundManagedObjectContext];

        NSFetchRequest *request= [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CollectProduct" inManagedObjectContext:context];
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"pic_url==%@",product.pic_url];
        [request setEntity:entity];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *array = [context executeFetchRequest:request error:&error];
        [request release];
        if ([array count] > 0) {
            product.collect = YES;
        }
    }
    
    int currentCount = [productsArray count];
    NSMutableArray *rowsInsertIndexPath = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [myArray count]; i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:currentCount + i inSection:0];
        [rowsInsertIndexPath addObject:tempIndexPath];
    }
    [productsArray addObjectsFromArray:myArray];
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
-(void)refreshCollected:(NSNotification *)notification
{
    Product *delProduct = [[notification userInfo]valueForKey:@"deletedProduct"];
    
    for (int i = 0; i < [productsArray count]; i++) {
        Product *product = [productsArray objectAtIndex:i];
        
        if ([product.pic_url isEqualToString:delProduct.pic_url]) {
            product.collect = NO;
        }
    }
    [productTableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [productsArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[HotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
    }
    cell.delegate = self;
    cell.rowNum = indexPath.row;
    Product *product = [productsArray objectAtIndex:indexPath.row];
    [cell.myImageView setImageWithURL:[NSURL URLWithString:product.pic_url] placeholderImage:[UIImage imageNamed:@"bPlaceHolder.png"]];
    cell.desLable.text = product.title;
    cell.priceLabel2.text = product.price;
    cell.likeLabel2.text = product.seller_credit_score;
    if (product.collect) {
        [cell.collectLabel setText:@"已收藏"];
        cell.collectButton.enabled = NO;
    }else{
        [cell.collectLabel setText:@"收藏"];
        cell.collectButton.enabled = YES;
    }
    return cell;
}
#pragma HotCellSelectionDelegate
-(void)selectTableViewCell:(HotCell *)cell
{
    selectedCell = cell;
    Product *product = [productsArray objectAtIndex:cell.rowNum];
    WebViewController *webViewController = [[WebViewController alloc]init];
    webViewController.productUrlS = product.click_url;
    [self presentModalViewController:webViewController animated:YES];
    [webViewController release];
}
-(void)collectProduct:(HotCell *)cell
{
    Product *product = [productsArray objectAtIndex:cell.rowNum];
    
    NSManagedObjectContext *context = [[CoreDataController sharedInstance]masterManagedObjectContext];
    CollectProduct *collectProduct = [NSEntityDescription
                                            insertNewObjectForEntityForName:@"CollectProduct"
                                            inManagedObjectContext:context];
    collectProduct.pic_url = product.pic_url;
    collectProduct.title = product.title;
    collectProduct.price = product.price;
    collectProduct.seller_credit_score = product.seller_credit_score;
    collectProduct.click_url = product.click_url;

    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }else{
        product.collect = YES;
        [cell.collectLabel setText:@"已收藏"];
        cell.collectButton.enabled = NO;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"COLLECT_SUCCESS" object:nil userInfo:nil];
    }
}
-(void)shareProduct:(HotCell *)cell
{
    ShareSns *shareSns = [[ShareSns alloc]init];
    [shareSns showSnsShareSheet:self.tabBarController.view viewController:self shareImage:cell.myImageView.image shareText:cell.desLable.text];
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
