//
//  CollectViewController.m
//  MuyingYongpin
//
//  Created by kai zhang on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CollectViewController.h"
#import "CoreDataController.h"
#import "CollectProduct.h"
#import "Product.h"
#import "UIImageView+WebCache.h"
#import "TheBrandDetailViewController.h"
#import "SetupViewController.h"

@interface CollectViewController()
{
    NSManagedObjectContext *managedContext;
    UITableViewCell *selectedCell;
}
@end


@implementation CollectViewController
-(void)dealloc
{
    [managedContext release];
    [myTableView release];
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
        self.title = @"我的";
        
        //use whatever image you want and add it to your project
        self.tabBarItem.image = [UIImage imageNamed:@"ico_nav_me"];
        
        // set the long name shown in the navigation bar at the top
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 240, 30)];
//        titleLabel.textColor = [UIColor colorWithRed:1 green: 0.6 blue:0.8 alpha:1];
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        titleLabel.font = [UIFont fontWithName:@"迷你简黛玉" size:25];
        titleLabel.shadowColor   = [[UIColor blackColor]colorWithAlphaComponent: 0.2f];
        titleLabel.shadowOffset  = CGSizeMake(1.0,1.0);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"我的";
        [self.navigationItem setTitleView:titleLabel];
        [titleLabel release];
        
        [self createSetupButton];
    }
    return self;
    
}
-(void)createSetupButton
{
    UIButton *setupButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [setupButton setBackgroundImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    [setupButton addTarget:self action:@selector(goToSetup) forControlEvents:UIControlEventTouchUpInside];
    UIView *rightItem = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    rightItem.backgroundColor = [UIColor clearColor];
    [rightItem addSubview:setupButton];
    [setupButton release];
    UIBarButtonItem * rightbarButton = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    [self navigationItem].rightBarButtonItem = rightbarButton;
    [rightItem release];
    [rightbarButton release];
}
-(void)goToSetup
{
    SetupViewController *setupViewController = [[SetupViewController alloc]init];
    [self.navigationController pushViewController:setupViewController animated:YES];
    [setupViewController release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(collectSuccess) name:@"COLLECT_SUCCESS" object:nil];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SheetBackground"]];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_background"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setOpaque:1.0];
    }
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, self.navigationController.navigationBar.frame.size.height, 0);
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 548-44-49) style:UITableViewStylePlain];
    } else {
        // code for 3.5-inch screen
        myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460-44-49) style:UITableViewStylePlain];
    }
    [myTableView setBackgroundColor:[UIColor clearColor]];
    [myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    myTableView.rowHeight = 190;
    myTableView.dataSource = self;
    myTableView.delegate = self;
//    myTableView.scrollIndicatorInsets = insets;
    myTableView.contentInset = insets;
    [self.view addSubview:myTableView];
    
    dataArray = [[NSMutableArray alloc]init];
    
    managedContext = [[CoreDataController sharedInstance]newManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CollectProduct"
                                              inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [managedContext executeFetchRequest:fetchRequest error:&error];
    [dataArray addObjectsFromArray:fetchedObjects];
    [fetchRequest release];
}
-(void)collectSuccess
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CollectProduct"
                                              inManagedObjectContext:managedContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [managedContext executeFetchRequest:fetchRequest error:&error];
    if (dataArray != nil) {
        [dataArray removeAllObjects];
    }
    [dataArray addObjectsFromArray:fetchedObjects];
    [fetchRequest release];
    [myTableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount;
    int totalProducts = [dataArray count];
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
    cell.delegate = self;
    cell.rowNum = indexPath.row;
    
    CollectProduct *leftProduct = [dataArray objectAtIndex:indexPath.row*2];
    NSString *lProduct = [NSString stringWithFormat:@"%@_160x160.jpg",leftProduct.pic_url];
    [cell.leftImageView setImageWithURL:[NSURL URLWithString:lProduct] placeholderImage:[UIImage imageNamed:@"bPlaceHolder.png"] options:SDWebImageRoundCorner];
    cell.priceLabel2.text = leftProduct.price;
    cell.likeLabel2.text = leftProduct.seller_credit_score;
    
    cell.coverView2.hidden = NO;
    if ([dataArray count] > indexPath.row*2 + 1) {
        CollectProduct *rightProduct = [dataArray objectAtIndex:indexPath.row*2 + 1];
        NSString *rProduct = [NSString stringWithFormat:@"%@_160x160.jpg",rightProduct.pic_url];
        [cell.rightImageView setImageWithURL:[NSURL URLWithString:rProduct] placeholderImage:[UIImage imageNamed:@"bPlaceHolder.png"] options:SDWebImageRoundCorner];
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
    CollectProduct *product = [dataArray objectAtIndex:productIndex];
    Product *myProduct = [[Product alloc]init];
    
    myProduct.pic_url = product.pic_url;
    myProduct.title = product.title;
    myProduct.click_url = product.click_url;
    myProduct.price = product.price;
    myProduct.seller_credit_score = product.seller_credit_score;
    myProduct.collect = YES;
    myProduct.num_id = product.num_iid;
    
    TheBrandDetailViewController *theBrandDetailViewController = [[TheBrandDetailViewController alloc]initWithProduct:myProduct];
    theBrandDetailViewController.collection = YES;
    theBrandDetailViewController.smallImage = smallImage;
    [self presentModalViewController:theBrandDetailViewController animated:YES];
    [theBrandDetailViewController release];
    [myProduct release];
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
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
