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
#import "HotCell.h"
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
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];  
//    headerView.backgroundColor = [UIColor blackColor];
//    [headerView setAlpha:0.8];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
//    label.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont boldSystemFontOfSize:10];
//    label.textColor = [UIColor whiteColor];
//    
//    [headerView addSubview:label];
//    return headerView;
//}
//
//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 44.0;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    Product *product = [dataController.productsArray objectAtIndex:section];
//    return product.title;
//}
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

    Product *product = [productsArray objectAtIndex:indexPath.row];
    [cell.theImageView setImageWithURL:[NSURL URLWithString:product.pic_url] placeholderImage:[UIImage imageNamed:@"placefold.jpeg"]];
    cell.desLable.text = product.title;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Product *product = [productsArray objectAtIndex:indexPath.row];
    WebViewController *webViewController = [[WebViewController alloc]init];
    webViewController.productUrlS = product.click_url;
    [self presentModalViewController:webViewController animated:YES];
    [webViewController release];
}
/*
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Product *product = [dataController.productsArray objectAtIndex:indexPath.row];
//    
//    NSURL *imageURL = [NSURL URLWithString:product.pic_url];
//    
//    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, NULL);
//    if(imageSourceRef == NULL){
//     
//        return 0;
//    }
//    
//    CFDictionaryRef props = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);    
//    CFRelease(imageSourceRef);
//    
//    NSLog(@"%@", (__bridge NSDictionary *)props);
//    NSNumber *width;
//    NSNumber *height;
//    if (props) {
//        width = (__bridge NSNumber *)CFDictionaryGetValue(props, kCGImagePropertyPixelWidth);
//        height = (__bridge NSNumber *)CFDictionaryGetValue(props, kCGImagePropertyPixelHeight);
//        NSLog(@"Image dimensions: %@ x %@ px", width, height);
//    }
//    
//    CFRelease(props);
//    
//    float cellHeight = [height intValue] * 320 / [width intValue];
    float cellHeight = 320;
    return cellHeight;
}
*/
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
