//
//  BrandViewController.m
//  MuyingYongpin
//
//  Created by kai zhang on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrandViewController.h"
#import "TheBrandViewController.h"

@interface BrandViewController()
{
    UIView *bgColorView;
    NSMutableArray *headerArray;
}
@end

@implementation BrandViewController

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
        self.title = @"品牌";
        
        //use whatever image you want and add it to your project
        self.tabBarItem.image = [UIImage imageNamed:@"iconCatalogTab"];
        
        // set the long name shown in the navigation bar at the top
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
//        titleLabel.textColor = [UIColor colorWithRed:1 green: 0.6 blue:0.8 alpha:1];
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        titleLabel.font = [UIFont fontWithName:@"迷你简黛玉" size:25];
        titleLabel.shadowColor   = [[UIColor blackColor]colorWithAlphaComponent: 0.2f];
        titleLabel.shadowOffset  = CGSizeMake(1.0,1.0);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"品牌";
        [self.navigationItem setTitleView:titleLabel];
        [titleLabel release];
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //for tableview selected color
    bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:1 green:0.6 blue:0.8 alpha:1.0]];

    self.view.backgroundColor = [UIColor blueColor];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_background"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setOpaque:1.0];
    }
    headerArray = [[NSMutableArray alloc]initWithObjects:@"功效",@"护肤",@"彩妆",@"美体", nil];

//    dataArray = [[NSMutableArray alloc]initWithObjects:@"碧欧泉",@"香奈儿",@"倩碧",@"雅诗兰黛",@"兰蔻",@"玫琳凯",@"迪奥",@"欧莱雅",@"相宜本草",@"玉兰油",@"the face shop",@"美宝莲",@"skin79",@"卡姿兰", nil];
    
    dataArray1 = [[NSMutableArray alloc]initWithObjects:@"美白",@"保湿",@"祛痘",@"抗敏",@"遮瑕",@"祛斑",@"控油",@"补水",@"去黑头",@"收毛孔",@"去眼袋", nil];

    dataArray2 = [[NSMutableArray alloc]initWithObjects:@"防晒霜",@"喷雾",@"卸妆油",@"洗面奶",@"面膜",@"眼霜",@"化妆水",@"面霜",@"隔离霜",@"吸油面纸",@"药妆",nil];

    dataArray3 = [[NSMutableArray alloc]initWithObjects:@"香水",@"指甲油",@"睫毛膏",@"BB霜",@"粉饼",@"蜜粉",@"口红",@"腮红",@"眼影",@"眉笔",@"唇彩",@"眼线膏",nil];

    dataArray4 = [[NSMutableArray alloc]initWithObjects:@"手工皂",@"沐浴露",@"美颈霜",@"身体乳",@"护手霜",@"假发",@"发蜡",@"弹力素",@"发膜",@"蓬蓬粉",@"染发膏",nil];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, self.navigationController.navigationBar.frame.size.height, 0);
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 460-44-49) style:UITableViewStylePlain];
    //    [productTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.contentInset = insets;
    //    productTableView.rowHeight = 480;
    [self.view addSubview:myTableView];

}
- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDisclosureIndicator;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [headerArray objectAtIndex:section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int row;
    switch (section) {
        case 0:
            row = [dataArray1 count];
            break;
        case 1:
            row = [dataArray2 count];
            break;
        case 2:
            row = [dataArray3 count];
            break;
        case 3:
            row = [dataArray4 count];
            break;

        default:
            break;
    }
    return row;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
        [cell setSelectedBackgroundView:bgColorView];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [dataArray1 objectAtIndex:indexPath.row];
            break;
        case 1:
            cell.textLabel.text = [dataArray2 objectAtIndex:indexPath.row];
            break;
        case 2:
            cell.textLabel.text = [dataArray3 objectAtIndex:indexPath.row];
            break;
        case 3:
            cell.textLabel.text = [dataArray4 objectAtIndex:indexPath.row];
            break;
  
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *categoryName;
    
    switch (indexPath.section) {
        case 0:
            categoryName = [dataArray1 objectAtIndex:indexPath.row];
            break;
        case 1:
            categoryName = [dataArray2 objectAtIndex:indexPath.row];
            break;
        case 2:
            categoryName = [dataArray3 objectAtIndex:indexPath.row];
            break;
        case 3:
            categoryName = [dataArray4 objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    TheBrandViewController *theBrandViewController = [[TheBrandViewController alloc]init];
    theBrandViewController.catName = categoryName;
    [self.navigationController pushViewController:theBrandViewController animated:YES];
    [theBrandViewController release];
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
    [myTableView deselectRowAtIndexPath:[myTableView indexPathForSelectedRow] animated:YES];
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
