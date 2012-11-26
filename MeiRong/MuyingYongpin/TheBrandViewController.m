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
#import "SVPullToRefresh.h"
#import "TheBrandDetailViewController.h"
#import "CoreDataController.h"
#import "MBProgressHUD.h"

@interface TheBrandViewController ()
{
    NSManagedObjectContext *context;
    UITableViewCell *selectedCell;
    BOOL finishLoad;
}
-(NSString *)getNotificationName;
@end

@implementation TheBrandViewController
@synthesize catName;
-(void)dealloc
{
    [context release];
    [theTalbleView release];
    [productsArray release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
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
    // set the long name shown in the navigation bar at the top
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320 - 60*2, 30)];
//    titleLabel.textColor = [UIColor colorWithRed:1 green: 0.6 blue:0.8 alpha:1];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    titleLabel.font = [UIFont fontWithName:@"迷你简黛玉" size:25];
    titleLabel.shadowColor   = [[UIColor blackColor]colorWithAlphaComponent: 0.2f];
    titleLabel.shadowOffset  = CGSizeMake(1.0,1.0);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.catName;
    [self.navigationItem setTitleView:titleLabel];
    [titleLabel release];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createNavBackButton];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SheetBackground"]];
            
    NSString *notificationName = [self getNotificationName];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveCatProducts:) name:notificationName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCollected:) name:@"REFRESH_COLLECTED" object:nil];
    
	// Do any additional setup after loading the view.
    theTalbleView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460-44-50) style:UITableViewStylePlain];
    [theTalbleView setBackgroundColor:[UIColor clearColor]];
    [theTalbleView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    theTalbleView.rowHeight = 155;
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
        [dataController fetachCateProducts:weakcatName notiName:notificationName pageNumber:pageN + 1];
        weakCurrentPage = pageN;
    }];
    
    DataController *dataController = [DataController sharedDataController];
    [dataController fetachCateProducts:self.catName notiName:notificationName pageNumber:1];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
-(void)recieveCatProducts:(NSNotification *)notification
{
    finishLoad = YES;
    NSMutableArray *pArray = [notification object];
    [pArray retain];

    if ([pArray count] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [theTalbleView.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        [pArray release];
        return;
    }

    for (int i = 0; i < [pArray count]; i++) {
        Product *product = [pArray objectAtIndex:i];
        
        context = [[CoreDataController sharedInstance]newManagedObjectContext];
        
        NSFetchRequest *request= [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CollectProduct" inManagedObjectContext:context];
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"pic_url==%@",product.pic_url];
        [request setEntity:entity];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        //"context" block in executeFetchRequest function
        NSArray *array = [context executeFetchRequest:request error:&error];
        [request release];
        if ([array count] > 0) {
            product.collect = YES;
        }
    }
    [productsArray addObjectsFromArray:pArray];
    [pArray release];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [theTalbleView.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [theTalbleView reloadData];
    });
}
-(void)goBack
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
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
    [theTalbleView reloadData];
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
    [cell.leftImageView setImageWithURL:[NSURL URLWithString:lProduct] placeholderImage:[UIImage imageNamed:@"BackgroundPattern"]];

    cell.coverView2.hidden = NO;
    if ([productsArray count] > indexPath.row*2 + 1) {
        Product *rightProduct = [productsArray objectAtIndex:indexPath.row*2 + 1];
        NSString *rProduct = [NSString stringWithFormat:@"%@_160x160.jpg",rightProduct.pic_url];
        [cell.rightImageView setImageWithURL:[NSURL URLWithString:rProduct] placeholderImage:[UIImage imageNamed:@"BackgroundPattern"]];
    }else{
//        [cell.rightImageView setImageWithURL:[NSURL URLWithString:nil] placeholderImage:[UIImage imageNamed:@"BackgroundPattern"]];
        cell.coverView2.hidden = YES;
    }
    return cell;
}
#pragma StyleOneCellSelectionDelegate
-(void)selectTableViewCell:(StyleOneCell *)cell selectedItemAtIndex:(NSInteger)index
{
    selectedCell = cell;
    int productIndex;
    if (index == 0) {
        productIndex = cell.rowNum * 2;
    }else{
        productIndex = cell.rowNum * 2 + 1;
    }
    Product *product = [productsArray objectAtIndex:productIndex];
    
    TheBrandDetailViewController *theBrandDetailViewController = [[TheBrandDetailViewController alloc]init];
    theBrandDetailViewController.product = product;
    [self.navigationController pushViewController:theBrandDetailViewController animated:YES];
    [theBrandDetailViewController release];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (selectedCell != nil) {
        [(StyleOneCell *)selectedCell diselectCell];
    }
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
