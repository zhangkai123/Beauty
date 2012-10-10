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

@implementation CollectViewController
-(void)dealloc
{
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
        self.title = @"收藏";
        
        //use whatever image you want and add it to your project
        self.tabBarItem.image = [UIImage imageNamed:@"iconFavorTab"];
        
        // set the long name shown in the navigation bar at the top
        self.navigationItem.title=@"我的收藏";
//        UIImage *image = [UIImage imageNamed: @"up_toolbar"];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
//        
//        self.navigationItem.titleView = imageView;
//        
//        [imageView release];
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(collectSuccess) name:@"COLLECT_SUCCESS" object:nil];
    
    self.view.backgroundColor = [UIColor grayColor];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBg"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setOpaque:1.0];
    }
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460-44-50) style:UITableViewStylePlain];
    myTableView.rowHeight = 160;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    
    dataArray = [[NSMutableArray alloc]init];
    
    NSManagedObjectContext *managedContext = [[CoreDataController sharedInstance]managedObjectContext];
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
    NSManagedObjectContext *managedContext = [[CoreDataController sharedInstance]managedObjectContext];
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
    [cell.leftImageView setImageWithURL:[NSURL URLWithString:lProduct] placeholderImage:[UIImage imageNamed:@"placefold.jpeg"]];
    
    if ([dataArray count] > indexPath.row*2 + 1) {
        CollectProduct *rightProduct = [dataArray objectAtIndex:indexPath.row*2 + 1];
        NSString *rProduct = [NSString stringWithFormat:@"%@_160x160.jpg",rightProduct.pic_url];
        [cell.rightImageView setImageWithURL:[NSURL URLWithString:rProduct] placeholderImage:[UIImage imageNamed:@"placefold.jpeg"]];
    }else{
        [cell.rightImageView setImageWithURL:[NSURL URLWithString:nil] placeholderImage:[UIImage imageNamed:nil]];
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
    CollectProduct *product = [dataArray objectAtIndex:productIndex];
    Product *myProduct = [[Product alloc]init];
    
    myProduct.pic_url = product.pic_url;
    myProduct.num_iid = product.num_iid;
    myProduct.title = product.title;
    myProduct.nick = product.nick;
    myProduct.price = product.price;
    myProduct.click_url = product.click_url;
    myProduct.commission = product.commission;
    myProduct.commission_rate = product.commission_rate;
    myProduct.commission_num = product.commission_num;
    myProduct.commission_volume = product.commission_volume;
    myProduct.shop_click_url = product.shop_click_url;
    myProduct.seller_credit_score = product.seller_credit_score;
    myProduct.item_location = product.item_location;
    myProduct.volume = product.volume;
    
    TheBrandDetailViewController *theBrandDetailViewController = [[TheBrandDetailViewController alloc]init];
    theBrandDetailViewController.product = myProduct;
    [self.navigationController pushViewController:theBrandDetailViewController animated:YES];
    [theBrandDetailViewController release];
    [myProduct release];
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
