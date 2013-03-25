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

@interface TheBrandViewController ()
{
    NSManagedObjectContext *context;
    UITableViewCell *selectedCell;
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

-(id) initWithTabBar {
    if ([self init]) {
        //this is the label on the tab button itself
        self.title = @"热销";
        
        //use whatever image you want and add it to your project
        self.tabBarItem.image = [UIImage imageNamed:@"ico_nav_hot"];
        
        // set the long name shown in the navigation bar at the top
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 220, 30)];
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        titleLabel.font = [UIFont fontWithName:@"迷你简黛玉" size:25];
        titleLabel.shadowColor   = [[UIColor blackColor]colorWithAlphaComponent: 0.2f];
        titleLabel.shadowOffset  = CGSizeMake(1.0,1.0);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"热销";
        [self.navigationItem setTitleView:titleLabel];
        [titleLabel release];
        
//        [self createActivity];
    }
    return self;
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_background"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setOpaque:1.0];
    }
    
    if (![self.catName isEqualToString:@"热销"]) {
     
        [self createNavBackButton];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SheetBackground"]];
    
    [self createActivity];
    
    NSString *notificationName = [self getNotificationName];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveCatProducts:) name:notificationName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCollected:) name:@"REFRESH_COLLECTED" object:nil];
    
	// Do any additional setup after loading the view.
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        theTalbleView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 548-44-50) style:UITableViewStylePlain];
    } else {
        // code for 3.5-inch screen
        theTalbleView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460-44-50) style:UITableViewStylePlain];
    }
    [theTalbleView setBackgroundColor:[UIColor clearColor]];
    [theTalbleView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    theTalbleView.rowHeight = 190;
    theTalbleView.dataSource = self;
    theTalbleView.delegate = self;
    [self.view addSubview:theTalbleView];
    
    productsArray = [[NSMutableArray alloc]init];
    
    __block UITableView *weaktheTalbleView = theTalbleView;
    __block NSMutableArray *weakproductsArray = productsArray;
    __block NSString *weakcatName = self.catName;
    __block NSInteger weakCurrentPage = currentPage;
    __block BOOL *weakRefresh = &refresh;
    __block BOOL *weakFinishLoad = &finishLoad;
    
    //add the pull fresh and add more data
    // setup the pull-to-refresh view
    [theTalbleView addPullToRefreshWithActionHandler:^{
        
        *weakRefresh = YES;
        if (weaktheTalbleView.pullToRefreshView.state == SVPullToRefreshStateLoading)
            NSLog(@"Pull to refresh is loading");
        weakCurrentPage = 0;
        DataController *dataController = [DataController sharedDataController];
        [dataController fetachCateProducts:weakcatName notiName:notificationName pageNumber:1];
    }];
    [theTalbleView addInfiniteScrollingWithActionHandler:^{
        
        *weakRefresh = NO;
        if (!*weakFinishLoad) {
            return;
        }
        *weakFinishLoad = NO;
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
    
    [self startActivity];
}
-(void)recieveCatProducts:(NSNotification *)notification
{
    finishLoad = YES;
    NSMutableArray *pArray = [notification object];
    [pArray retain];

    if ([pArray count] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [theTalbleView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
           [theTalbleView.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
            [self stopActivity];
        });
        [pArray release];
        return;
    }
    if (refresh) {
        [productsArray removeAllObjects];
    }
    
    for (int i = 0; i < [pArray count]; i++) {
        Product *product = [pArray objectAtIndex:i];
        
        if (context == nil) {
            context = [[CoreDataController sharedInstance]newManagedObjectContext];
        }
        
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
    
    int rowCount;
    int totalProducts = [pArray count];
    if (totalProducts%2 == 1) {
        rowCount = (totalProducts +1)/2;
    }else{
        rowCount = totalProducts/2;
    }
    
    int currentCount = [theTalbleView numberOfRowsInSection:0];
    NSMutableArray *rowsInsertIndexPath = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < rowCount; i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:currentCount + i inSection:0];
        [rowsInsertIndexPath addObject:tempIndexPath];
    }
    [productsArray addObjectsFromArray:pArray];
    [pArray release];

    
    dispatch_async(dispatch_get_main_queue(), ^{
        [theTalbleView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
        [theTalbleView.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
        [self stopActivity];
        if (refresh) {
            [theTalbleView reloadData];
        }else{
            [theTalbleView insertRowsAtIndexPaths:rowsInsertIndexPath withRowAnimation:UITableViewRowAnimationRight];
            [rowsInsertIndexPath release];
        }
    });
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
    if ([self.catName isEqualToString:@"热销"]){
        
        notificationName = @"NOTIFICATION_0";
    }else if ([self.catName isEqualToString:@"美白"]) {
        
        notificationName = @"NOTIFICATION_1";
    }else if([self.catName isEqualToString:@"保湿"]){
        
        notificationName = @"NOTIFICATION_2";
    }else if([self.catName isEqualToString:@"祛痘"]){
        
        notificationName = @"NOTIFICATION_3";
    }else if([self.catName isEqualToString:@"抗敏"]){
        
        notificationName = @"NOTIFICATION_4";
    }else if([self.catName isEqualToString:@"遮瑕"]){
        
        notificationName = @"NOTIFICATION_5";
    }else if([self.catName isEqualToString:@"祛斑"]){
        
        notificationName = @"NOTIFICATION_6";
    }else if([self.catName isEqualToString:@"控油"]){
        
        notificationName = @"NOTIFICATION_7";
    }else if([self.catName isEqualToString:@"补水"]){
        
        notificationName = @"NOTIFICATION_8";
    }else if([self.catName isEqualToString:@"去黑头"]){
        
        notificationName = @"NOTIFICATION_9";
    }else if([self.catName isEqualToString:@"收毛孔"]){
        
        notificationName = @"NOTIFICATION_10";
    }else if([self.catName isEqualToString:@"去眼袋"]){
        
        notificationName = @"NOTIFICATION_11";
    }
    
    else if([self.catName isEqualToString:@"防晒霜"]){
        
        notificationName = @"NOTIFICATION_12";
    }else if([self.catName isEqualToString:@"喷雾"]){
        
        notificationName = @"NOTIFICATION_13";
    }else if([self.catName isEqualToString:@"卸妆油"]){
        
        notificationName = @"NOTIFICATION_14";
    }else if([self.catName isEqualToString:@"洗面奶"]){
        
        notificationName = @"NOTIFICATION_15";
    }else if([self.catName isEqualToString:@"面膜"]){
        
        notificationName = @"NOTIFICATION_16";
    }else if([self.catName isEqualToString:@"眼霜"]){
        
        notificationName = @"NOTIFICATION_17";
    }else if([self.catName isEqualToString:@"化妆水"]){
        
        notificationName = @"NOTIFICATION_18";
    }else if([self.catName isEqualToString:@"面霜"]){
        
        notificationName = @"NOTIFICATION_19";
    }else if([self.catName isEqualToString:@"隔离霜"]){
        
        notificationName = @"NOTIFICATION_20";
    }else if([self.catName isEqualToString:@"吸油面纸"]){
        
        notificationName = @"NOTIFICATION_21";
    }else if([self.catName isEqualToString:@"药妆"]){
        
        notificationName = @"NOTIFICATION_22";
    }

    else if([self.catName isEqualToString:@"香水"]){
        
        notificationName = @"NOTIFICATION_23";
    }else if([self.catName isEqualToString:@"指甲油"]){
        
        notificationName = @"NOTIFICATION_24";
    }else if([self.catName isEqualToString:@"睫毛膏"]){
        
        notificationName = @"NOTIFICATION_25";
    }else if([self.catName isEqualToString:@"BB霜"]){
        
        notificationName = @"NOTIFICATION_26";
    }else if([self.catName isEqualToString:@"粉饼"]){
        
        notificationName = @"NOTIFICATION_27";
    }else if([self.catName isEqualToString:@"蜜粉"]){
        
        notificationName = @"NOTIFICATION_28";
    }else if([self.catName isEqualToString:@"口红"]){
        
        notificationName = @"NOTIFICATION_29";
    }else if([self.catName isEqualToString:@"腮红"]){
        
        notificationName = @"NOTIFICATION_30";
    }else if([self.catName isEqualToString:@"眼影"]){
        
        notificationName = @"NOTIFICATION_31";
    }else if([self.catName isEqualToString:@"眉笔"]){
        
        notificationName = @"NOTIFICATION_32";
    }else if([self.catName isEqualToString:@"唇彩"]){
        
        notificationName = @"NOTIFICATION_33";
    }else if([self.catName isEqualToString:@"眼线膏"]){
        
        notificationName = @"NOTIFICATION_34";
    }

    else if([self.catName isEqualToString:@"手工皂"]){
        
        notificationName = @"NOTIFICATION_35";
    }else if([self.catName isEqualToString:@"沐浴露"]){
        
        notificationName = @"NOTIFICATION_36";
    }else if([self.catName isEqualToString:@"美颈霜"]){
        
        notificationName = @"NOTIFICATION_37";
    }else if([self.catName isEqualToString:@"身体乳"]){
        
        notificationName = @"NOTIFICATION_38";
    }else if([self.catName isEqualToString:@"护手霜"]){
        
        notificationName = @"NOTIFICATION_39";
    }else if([self.catName isEqualToString:@"假发"]){
        
        notificationName = @"NOTIFICATION_40";
    }else if([self.catName isEqualToString:@"发蜡"]){
        
        notificationName = @"NOTIFICATION_41";
    }else if([self.catName isEqualToString:@"弹力素"]){
        
        notificationName = @"NOTIFICATION_42";
    }else if([self.catName isEqualToString:@"发膜"]){
        
        notificationName = @"NOTIFICATION_43";
    }else if([self.catName isEqualToString:@"蓬蓬粉"]){
        
        notificationName = @"NOTIFICATION_44";
    }else if([self.catName isEqualToString:@"染发膏"]){
        
        notificationName = @"NOTIFICATION_45";
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
    //change to big image to see if better performance
    NSString *lProduct = [NSString stringWithFormat:@"%@_160x160.jpg",leftProduct.pic_url];
    [cell.leftImageView setImageWithURL:[NSURL URLWithString:lProduct] placeholderImage:[UIImage imageNamed:@"smallbPlaceHolder.png"]  options:SDWebImageRoundCorner];
    cell.priceLabel2.text = leftProduct.price;
    cell.likeLabel2.text = leftProduct.seller_credit_score;

    cell.coverView2.hidden = NO;
    if ([productsArray count] > indexPath.row*2 + 1) {
        Product *rightProduct = [productsArray objectAtIndex:indexPath.row*2 + 1];
        NSString *rProduct = [NSString stringWithFormat:@"%@_160x160.jpg",rightProduct.pic_url];
        [cell.rightImageView setImageWithURL:[NSURL URLWithString:rProduct] placeholderImage:[UIImage imageNamed:@"smallbPlaceHolder.png"]  options:SDWebImageRoundCorner];
        cell.priceLabelR2.text = rightProduct.price;
        cell.likeLabel2R.text = rightProduct.seller_credit_score;
    }else{
        cell.coverView2.hidden = YES;
    }
    return cell;
}
#pragma StyleOneCellSelectionDelegate
-(void)selectTableViewCell:(StyleOneCell *)cell selectedItemAtIndex:(NSInteger)index
{
    selectedCell = cell;
    int productIndex;
    UIImage *smallImage = nil;
    if (index == 0) {
        productIndex = cell.rowNum * 2;
        smallImage = cell.leftImageView.image;
    }else{
        productIndex = cell.rowNum * 2 + 1;
        smallImage = cell.rightImageView.image;
    }
    Product *product = [productsArray objectAtIndex:productIndex];
    
    TheBrandDetailViewController *theBrandDetailViewController = [[TheBrandDetailViewController alloc]initWithProduct:product];
    theBrandDetailViewController.smallImage = smallImage;
    [self presentModalViewController:theBrandDetailViewController animated:YES];
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
