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

@implementation HotProductViewController

- (void)didReceiveMemoryWarning
{
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
        self.navigationItem.title=@"热销单品";        
    }
    return self;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveHotProducts) name:@"HOT_PRODUCTS_REARDY" object:nil];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBg"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setOpaque:1.0];
    }
    
    productTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 460-44-49) style:UITableViewStylePlain];
    productTableView.backgroundColor = [UIColor clearColor];
//    [productTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    productTableView.delegate = self;
    productTableView.dataSource = self;
    productTableView.rowHeight = 400;
    [self.view addSubview:productTableView];
    
    //add the pull fresh and add more data
    // setup the pull-to-refresh view
    [productTableView addPullToRefreshWithActionHandler:^{
        NSLog(@"refresh dataSource");
        if (productTableView.pullToRefreshView.state == SVPullToRefreshStateLoading)
            NSLog(@"Pull to refresh is loading");
        [productTableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }];
    [productTableView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"load more data");
        int productN = [productsArray count];
        int pageN;
        if (productN % 20 == 0) {
            pageN = productN / 20;
            if (pageN <= currentPage) {
                pageN = -1;
            }
        }else{
            pageN = -1;
        }
        DataController *dataController = [DataController sharedDataController];
        [dataController fetachHotProducts:pageN + 1];
        currentPage = pageN;
    }];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    productsArray = [[NSMutableArray alloc]init];
    DataController *dataController = [DataController sharedDataController];
    [dataController fetachHotProducts:1];
}
-(void)recieveHotProducts
{
    DataController *dataController = [DataController sharedDataController];
    [productsArray addObjectsFromArray:dataController.productsArray];
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
    [cell.theImageView setImageWithURL:[NSURL URLWithString:product.pic_url] placeholderImage:[UIImage imageNamed:@"placefold.jpeg"]];
    cell.desLable.text = product.title;
    return cell;
}
#pragma HotCellSelectionDelegate
-(void)selectTableViewCell:(HotCell *)cell
{
    Product *product = [productsArray objectAtIndex:cell.rowNum];
    WebViewController *webViewController = [[WebViewController alloc]init];
    webViewController.productUrlS = product.click_url;
    [self presentModalViewController:webViewController animated:YES];
    [webViewController release];
}
-(void)collectProduct:(HotCell *)cell
{
    
}
-(void)shareProduct:(HotCell *)cell
{
    
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
