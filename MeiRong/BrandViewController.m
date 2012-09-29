//
//  BrandViewController.m
//  MuyingYongpin
//
//  Created by kai zhang on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrandViewController.h"
#import "TheBrandViewController.h"

@implementation BrandViewController

- (void)didReceiveMemoryWarning
{
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
        self.navigationItem.title=@"品牌";
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBg"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setOpaque:1.0];
    }
    dataArray = [[NSMutableArray alloc]initWithObjects:@"碧欧泉",@"香奈儿",@"倩碧",@"雅诗兰黛",@"兰蔻",@"玫琳凯",@"迪奥",@"欧莱雅",@"相宜本草",@"玉兰油",@"the face shop",@"美宝莲",@"skin79",@"卡姿兰", nil];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 460-44-49) style:UITableViewStylePlain];
    //    [productTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    //    productTableView.rowHeight = 480;
    [self.view addSubview:myTableView];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
    }
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *categoryName = [dataArray objectAtIndex:indexPath.row];
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
