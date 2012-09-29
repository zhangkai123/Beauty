//
//  TheBrandViewController.m
//  MuyingYongpin
//
//  Created by zhang kai on 9/8/12.
//
//

#import "TheBrandViewController.h"
#import "Product.h"
#import "UIImageView+WebCache.h"
#import "DataController.h"
#import "WebViewController.h"
#import "SVPullToRefresh.h"

@interface TheBrandViewController ()

-(NSString *)getNotificationName;
@end

@implementation TheBrandViewController
@synthesize catName;
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [theTalbleView release];
    [productsArray release];
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
            
    NSString *notificationName = [self getNotificationName];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveCatProducts) name:notificationName object:nil];
    
	// Do any additional setup after loading the view.
    theTalbleView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460-44-50) style:UITableViewStylePlain];
    theTalbleView.rowHeight = 160;
    theTalbleView.dataSource = self;
    theTalbleView.delegate = self;
    [self.view addSubview:theTalbleView];
    
    productsArray = [[NSMutableArray alloc]init];
    
    __block UITableView *weaktheTalbleView = theTalbleView;
    __block NSMutableArray *weakproductsArray = productsArray;
    __block NSString *weakcatName = self.catName;
    __block NSInteger weakCurrentPage = currentPage;
    //add the pull fresh and add more data
    // setup the pull-to-refresh view
    [theTalbleView addPullToRefreshWithActionHandler:^{
        NSLog(@"refresh dataSource");
        if (weaktheTalbleView.pullToRefreshView.state == SVPullToRefreshStateLoading)
            NSLog(@"Pull to refresh is loading");
        [weaktheTalbleView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }];
    [theTalbleView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"load more data");
        int productN = [weakproductsArray count];
        int pageN;
        if (productN % 20 == 0) {
            pageN = productN / 20;
            if (pageN <= weakCurrentPage) {
                pageN = -1;
            }
        }else{
            pageN = -1;
        }
        DataController *dataController = [DataController sharedDataController];
        [dataController fetachCateProducts:weakcatName notiName:notificationName pageNumber:pageN + 1];
        weakCurrentPage = pageN;
    }];
    
    DataController *dataController = [DataController sharedDataController];
    [dataController fetachCateProducts:self.catName notiName:notificationName pageNumber:1];
}
-(NSString *)getNotificationName
{
    NSString *notificationName;
    if ([self.catName isEqualToString:@"碧欧泉"]) {
        
        notificationName = @"NOTIFICATION_1";
    }else if([self.catName isEqualToString:@"香奈儿"]){
        
        notificationName = @"NOTIFICATION_2";
    }else if([self.catName isEqualToString:@"倩碧"]){
        
        notificationName = @"NOTIFICATION_3";
    }else if([self.catName isEqualToString:@"雅诗兰黛"]){
        
        notificationName = @"NOTIFICATION_4";
    }else if([self.catName isEqualToString:@"兰蔻"]){
        
        notificationName = @"NOTIFICATION_5";
    }else if([self.catName isEqualToString:@"玫琳凯"]){
        
        notificationName = @"NOTIFICATION_6";
    }else if([self.catName isEqualToString:@"迪奥"]){
        
        notificationName = @"NOTIFICATION_7";
    }else if([self.catName isEqualToString:@"欧莱雅"]){
        
        notificationName = @"NOTIFICATION_8";
    }else if([self.catName isEqualToString:@"相宜本草"]){
        
        notificationName = @"NOTIFICATION_9";
    }else if([self.catName isEqualToString:@"玉兰油"]){
        
        notificationName = @"NOTIFICATION_10";
    }else if([self.catName isEqualToString:@"the face shop"]){
        
        notificationName = @"NOTIFICATION_11";
    }else if([self.catName isEqualToString:@"美宝莲"]){
        
        notificationName = @"NOTIFICATION_12";
    }else if([self.catName isEqualToString:@"skin79"]){
        
        notificationName = @"NOTIFICATION_13";
    }else if([self.catName isEqualToString:@"卡姿兰"]){
        
        notificationName = @"NOTIFICATION_14";
    }
    return notificationName;
}
-(void)recieveCatProducts
{
    DataController *dataController = [DataController sharedDataController];
    [productsArray addObjectsFromArray:dataController.productsArray];
    [theTalbleView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount;
    int totalProducts = [productsArray count];
    if (totalProducts%2 == 1) {
        rowCount = (totalProducts +1)/2;
    }else{
        rowCount = totalProducts/2;
    }
    return rowCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StyleOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[StyleOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
    }
    cell.rowNum = indexPath.row;
    cell.delegate = self;
    Product *leftProduct = [productsArray objectAtIndex:indexPath.row*2];
    NSString *lProduct = [NSString stringWithFormat:@"%@_160x160.jpg",leftProduct.pic_url];
    [cell.leftImageView setImageWithURL:[NSURL URLWithString:lProduct] placeholderImage:[UIImage imageNamed:@"placefold.jpeg"]];
    
    if ([productsArray count] > indexPath.row*2 + 1) {
        Product *rightProduct = [productsArray objectAtIndex:indexPath.row*2 + 1];
        NSString *rProduct = [NSString stringWithFormat:@"%@_160x160.jpg",rightProduct.pic_url];
        [cell.rightImageView setImageWithURL:[NSURL URLWithString:rProduct] placeholderImage:[UIImage imageNamed:@"placefold.jpeg"]];
    }
    return cell;
}
#pragma StyleOneCellSelectionDelegate
-(void)selectTableViewCell:(StyleOneCell *)cell selectedItemAtIndex:(NSInteger)index
{
    int productIndex;
    if (index == 0) {
        productIndex = cell.rowNum * 2;
    }else{
        productIndex = cell.rowNum * 2 + 1;
    }
    Product *product = [productsArray objectAtIndex:productIndex];
    WebViewController *webViewController = [[WebViewController alloc]init];
    webViewController.productUrlS = product.click_url;
    [self presentModalViewController:webViewController animated:YES];
    [webViewController release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
