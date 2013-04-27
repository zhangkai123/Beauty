//
//  BrandViewController.m
//  MuyingYongpin
//
//  Created by kai zhang on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrandViewController.h"
#import "TopicProductViewController.h"
#import "DataController.h"
#import "NewCategoryProductViewController.h"

@interface BrandViewController()
{
    UIView *bgColorView;
    NSMutableArray *headerArray;
    UISearchBar *sBar;//search bar
}
@end

@implementation BrandViewController

//get categoryId
-(int)getServerNotificationId:(NSString *)categoryName
{
    int notificationId;
    if ([categoryName isEqualToString:@"热销"]) {
        notificationId = 413;
    }else if ([categoryName isEqualToString:@"美白"]) {
        
        notificationId = 188;
    }else if([categoryName isEqualToString:@"保湿"]){
        
        notificationId = 189;
    }else if([categoryName isEqualToString:@"祛痘"]){
        
        notificationId = 190;
    }else if([categoryName isEqualToString:@"抗敏"]){
        
        notificationId = 191;
    }else if([categoryName isEqualToString:@"遮瑕"]){
        
        notificationId = 192;
    }else if([categoryName isEqualToString:@"祛斑"]){
        
        notificationId = 193;
    }else if([categoryName isEqualToString:@"控油"]){
        
        notificationId = 194;
    }else if([categoryName isEqualToString:@"补水"]){
        
        notificationId = 195;
    }else if([categoryName isEqualToString:@"去黑头"]){
        
        notificationId = 196;
    }else if([categoryName isEqualToString:@"收毛孔"]){
        
        notificationId = 197;
    }else if([categoryName isEqualToString:@"去眼袋"]){
        
        notificationId = 198;
    }
    
    else if([categoryName isEqualToString:@"防晒霜"]){
        
        notificationId = 199;
    }else if([categoryName isEqualToString:@"喷雾"]){
        
        notificationId = 200;
    }else if([categoryName isEqualToString:@"卸妆油"]){
        
        notificationId = 201;
    }else if([categoryName isEqualToString:@"洗面奶"]){
        
        notificationId = 202;
    }else if([categoryName isEqualToString:@"面膜"]){
        
        notificationId = 203;
    }else if([categoryName isEqualToString:@"眼霜"]){
        
        notificationId = 204;
    }else if([categoryName isEqualToString:@"化妆水"]){
        
        notificationId = 205;
    }else if([categoryName isEqualToString:@"面霜"]){
        
        notificationId = 206;
    }else if([categoryName isEqualToString:@"隔离霜"]){
        
        notificationId = 207;
    }else if([categoryName isEqualToString:@"吸油面纸"]){
        
        notificationId = 208;
    }else if([categoryName isEqualToString:@"药妆"]){
        
        notificationId = 209;
    }
    
    else if([categoryName isEqualToString:@"香水"]){
        
        notificationId = 210;
    }else if([categoryName isEqualToString:@"指甲油"]){
        
        notificationId = 211;
    }else if([categoryName isEqualToString:@"睫毛膏"]){
        
        notificationId = 212;
    }else if([categoryName isEqualToString:@"BB霜"]){
        
        notificationId = 213;
    }else if([categoryName isEqualToString:@"粉饼"]){
        
        notificationId = 214;
    }else if([categoryName isEqualToString:@"蜜粉"]){
        
        notificationId = 215;
    }else if([categoryName isEqualToString:@"口红"]){
        
        notificationId = 216;
    }else if([categoryName isEqualToString:@"腮红"]){
        
        notificationId = 217;
    }else if([categoryName isEqualToString:@"眼影"]){
        
        notificationId = 218;
    }else if([categoryName isEqualToString:@"眉笔"]){
        
        notificationId = 219;
    }else if([categoryName isEqualToString:@"唇彩"]){
        
        notificationId = 220;
    }else if([categoryName isEqualToString:@"眼线膏"]){
        
        notificationId = 221;
    }
    
    else if([categoryName isEqualToString:@"手工皂"]){
        
        notificationId = 222;
    }else if([categoryName isEqualToString:@"沐浴露"]){
        
        notificationId = 223;
    }else if([categoryName isEqualToString:@"美颈霜"]){
        
        notificationId = 224;
    }else if([categoryName isEqualToString:@"身体乳"]){
        
        notificationId = 225;
    }else if([categoryName isEqualToString:@"护手霜"]){
        
        notificationId = 226;
    }else if([categoryName isEqualToString:@"假发"]){
        
        notificationId = 227;
    }else if([categoryName isEqualToString:@"发蜡"]){
        
        notificationId = 228;
    }else if([categoryName isEqualToString:@"弹力素"]){
        
        notificationId = 229;
    }else if([categoryName isEqualToString:@"发膜"]){
        
        notificationId = 230;
    }else if([categoryName isEqualToString:@"蓬蓬粉"]){
        
        notificationId = 231;
    }else if([categoryName isEqualToString:@"染发膏"]){
        
        notificationId = 232;
    }
    
    return notificationId;
}

- (void)didReceiveMemoryWarning
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];

    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
-(void)dealloc
{
    [sBar release];
    [super dealloc];
}
#pragma mark - View lifecycle
-(id) initWithTabBar {
    if ([self initWithNavBar]) {
        //this is the label on the tab button itself
        self.title = @"分类";
        //use whatever image you want and add it to your project
        self.tabBarItem.image = [UIImage imageNamed:@"ico_nav_category"];
        titleLabel.text = @"分类";
        backButton.hidden = YES;
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SheetBackground"]];
    
    //for tableview selected color
    bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:1 green:0.6 blue:0.8 alpha:1.0]];

    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_background"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setOpaque:1.0];
    }
    
    sBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,320,45)];
    sBar.keyboardType = UIKeyboardTypeDefault;
//    sBar.tintColor = [UIColor colorWithRed:1 green: 0.6 blue:0.8 alpha:1];
    sBar.tintColor = [UIColor lightGrayColor];
    sBar.delegate = self;
    
    headerArray = [[NSMutableArray alloc]initWithObjects:@"护肤",@"功效",@"彩妆",@"美体", nil];
    
    dataArray1 = [[NSMutableArray alloc]initWithObjects:@"防晒霜",@"喷雾",@"卸妆油",@"洗面奶",@"面膜",@"眼霜",@"化妆水",@"面霜",@"隔离霜",@"吸油面纸",@"药妆",nil];
    
    dataArray2 = [[NSMutableArray alloc]initWithObjects:@"美白",@"保湿",@"祛痘",@"抗敏",@"遮瑕",@"祛斑",@"控油",@"补水",@"去黑头",@"收毛孔",@"去眼袋", nil];

    dataArray3 = [[NSMutableArray alloc]initWithObjects:@"香水",@"指甲油",@"睫毛膏",@"BB霜",@"粉饼",@"蜜粉",@"口红",@"腮红",@"眼影",@"眉笔",@"唇彩",@"眼线膏",nil];

    dataArray4 = [[NSMutableArray alloc]initWithObjects:@"手工皂",@"沐浴露",@"美颈霜",@"身体乳",@"护手霜",@"假发",@"发蜡",@"弹力素",@"发膜",@"蓬蓬粉",@"染发膏",nil];
//    dataArray1 = [[NSMutableArray alloc]initWithObjects:@"面膜",@"香水",@"唇膏",@"粉底",@"美甲",@"保湿",@"爽肤",@"化妆工具",@"腮红",@"眼线",@"面膜",@"眼霜",@"祛痘",@"美白",@"香水"
//                  ,@"精华",@"药妆",@"缩毛孔",@"防晒",@"手工皂",@"遮瑕",@"化妆棉",@"假睫毛",nil];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, self.navigationController.navigationBar.frame.size.height, 0);
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 548-44-49) style:UITableViewStylePlain];
    } else {
        // code for 3.5-inch screen
        myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 460-44-49) style:UITableViewStylePlain];
    }
    
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.contentInset = insets;
    [self.view addSubview:myTableView];

    [myTableView setTableHeaderView:sBar];
}
#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // only show the status bar's cancel button while in edit mode
    sBar.showsCancelButton = YES;
    sBar.autocorrectionType = UITextAutocorrectionTypeNo;
    // flush the previous search content
//    [tableData removeAllObjects];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    sBar.showsCancelButton = NO;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
//    self.theTableView.allowsSelection = YES;
//    self.theTableView.scrollEnabled = YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    TopicProductViewController *topicProductViewController = [[TopicProductViewController alloc]initWithTabBar];
    topicProductViewController.keyWord = searchBar.text;
//    [self.navigationController pushViewController:topicProductViewController animated:YES];
    [self presentModalViewController:topicProductViewController animated:YES];
    [topicProductViewController release];
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
    NewCategoryProductViewController *newCategoryProductViewController = [[NewCategoryProductViewController alloc]initWithNavBar];
    newCategoryProductViewController.hidesBottomBarWhenPushed = YES;
    newCategoryProductViewController.catName = categoryName;
    newCategoryProductViewController.catId = [NSString stringWithFormat:@"%d",[self getServerNotificationId:categoryName]];
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
