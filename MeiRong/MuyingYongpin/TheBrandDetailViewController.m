//
//  TheBrandDetailViewController.m
//  MuyingYongpin
//
//  Created by zhang kai on 10/9/12.
//
//

#import "TheBrandDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "WebViewController.h"
#import "CoreDataController.h"
#import "CollectProduct.h"
#import "ShareSns.h"
#import "DataController.h"
#import "FirstCell.h"
#import "DetailImageCell.h"
#import "SVPullToRefresh.h"

@interface TheBrandDetailViewController()
{
    UITableViewCell *selectedCell;
    UIView *realBackView;
}
@end

@implementation TheBrandDetailViewController
@synthesize product;
@synthesize smallImage;
@synthesize collection;

-(void)dealloc
{
    [theTableView release];
    [product release];
    [smallImage release];
    [realBackView release];
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
-(id)initWithProduct:(Product *)myProduct
{
    if (self = [super init]) {
        
        self.product = myProduct;
        
        [product addObserver:self
                  forKeyPath:@"imagesArray"
                     options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                     context:NULL];
        [self featchDetailData];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createNavBackButton];
        
	// Do any additional setup after loading the view.
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 548) style:UITableViewStylePlain];
    } else {
        // code for 3.5-inch screen
        theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 460) style:UITableViewStylePlain];
    }

    theTableView.backgroundColor = [UIColor clearColor];
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    theTableView.showsVerticalScrollIndicator = NO;
    theTableView.delegate = self;
    theTableView.dataSource = self;
    theTableView.clipsToBounds = NO;
    [self.view addSubview:theTableView];
    
//    __block UITableView *weaktheTalbleView = theTableView;
    [theTableView addInfiniteScrollingWithActionHandler:^{
    
//        [weaktheTalbleView.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
    }];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SheetBackground"]];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 8, 45, 45)];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backButton setTitle:@"back" forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton release];
    
    realBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 460 - 45 - 60, 320, 60)];
    realBackView.backgroundColor = [UIColor blackColor];
    [realBackView setAlpha:0.4];
    [self.view addSubview:realBackView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 15, 280, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setFont:[UIFont systemFontOfSize:12]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.text = product.title;
    [realBackView addSubview:titleLabel];
    [titleLabel release];
    
    UIView *tabView = [[UIView alloc]initWithFrame:CGRectMake(0, 460 - 45, 320, 45)];
    tabView.backgroundColor = [UIColor blackColor];
    [tabView setAlpha:0.6];
    [self.view addSubview:tabView];
    [tabView release];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [theTableView deselectRowAtIndexPath:[theTableView indexPathForSelectedRow] animated:YES];
}
-(void)featchDetailData
{
    if (self.product) {
        DataController *dataController = [DataController sharedDataController];
        [dataController featchProductDetail:product.num_id theProduct:product];
    }
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
    [theTableView setContentOffset:CGPointMake(0, 0)];
    [myImageView removeObserver:self forKeyPath:@"image" context:NULL];
    [product removeObserver:self forKeyPath:@"imagesArray" context:NULL];
    [self dismissModalViewControllerAnimated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= 65) {
        if (![realBackView isDescendantOfView:theTableView]) {
            [realBackView removeFromSuperview];
            realBackView.frame = CGRectMake(0, 480-60, realBackView.frame.size.width, realBackView.frame.size.height);
            [theTableView addSubview:realBackView];
        }
    }
    if (scrollView.contentOffset.y <= 65) {
        if ([realBackView isDescendantOfView:theTableView]) {
            [realBackView removeFromSuperview];
            realBackView.frame = CGRectMake(0, 460 - 45 - 60, 320, 60);
            [self.view addSubview:realBackView];
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
    }else{
     
        return [self.product.imagesArray count];
    }
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 0;
    if (indexPath.section == 0) {
        
        rowHeight = 480;
    }else{
        NSDictionary *imageDic = [self.product.imagesArray objectAtIndex:indexPath.row];
        rowHeight = [[imageDic objectForKey:@"imageHeight"] floatValue];
    }
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theCell = nil;
    if (indexPath.section == 0) {
        FirstCell *firstImageCell = nil;
        if (!theCell) {
            float imageWidth = self.smallImage.size.width * 480 / self.smallImage.size.height;
            firstImageCell = [[[FirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil imageWidth:imageWidth]autorelease];
        }
        [firstImageCell.myImageView setImageWithURL:[NSURL URLWithString:product.pic_url] placeholderImage:self.smallImage];
        theCell = firstImageCell;
    }else{
        DetailImageCell *imageCell = nil;
        if (!theCell) {
            NSDictionary *imageDic = [self.product.imagesArray objectAtIndex:indexPath.row];
            float imageHeight = [[imageDic objectForKey:@"imageHeight"] floatValue];
            imageCell = [[[DetailImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil imageHeight:imageHeight]autorelease];
        }
        NSString *imageUrlStr = [[product.imagesArray objectAtIndex:indexPath.row] objectForKey:@"imageUrl"];
        [imageCell.myImageView setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"bPlaceHolder.png"]];
        theCell = imageCell;
    }
    return theCell;
}
- (void) observeValueForKeyPath:(NSString *)path ofObject:(id) object change:(NSDictionary *) change context:(void *)context
{
    // this method is used for all observations, so you need to make sure
    // you are responding to the right one.
    if (object == myImageView && [path isEqualToString:@"image"])
    {
//        UIImage *newImage = [change objectForKey:NSKeyValueChangeNewKey];
//        UIImage *oldImage = [change objectForKey:NSKeyValueChangeOldKey];
        
    }else if(object == product && [path isEqualToString:@"imagesArray"]){
        
        [theTableView reloadData];
         [theTableView.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
        theTableView.showsInfiniteScrolling = NO;
    }
}

/*
#pragma HotCellSelectionDelegate
-(void)selectTableViewCell:(HotCell *)cell
{
    selectedCell = cell;
    WebViewController *webViewController = [[WebViewController alloc]init];
    webViewController.productUrlS = product.click_url;
    [self presentModalViewController:webViewController animated:YES];
    [webViewController release];
}
-(void)collectProduct:(HotCell *)cell
{
    if (!collection) {
        NSManagedObjectContext *context = [[CoreDataController sharedInstance]masterManagedObjectContext];
        CollectProduct *collectProduct = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"CollectProduct"
                                          inManagedObjectContext:context];
        collectProduct.pic_url = product.pic_url;
        collectProduct.title = product.title;
        collectProduct.price = product.price;
        collectProduct.seller_credit_score = product.seller_credit_score;
        collectProduct.click_url = product.click_url;
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }else{
            product.collect = YES;
            [cell.collectLabel setText:@"已收藏"];
            cell.collectButton.enabled = NO;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"COLLECT_SUCCESS" object:nil userInfo:nil];
        }
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: nil
                              message: @"确定要删除吗？"
                              delegate: self
                              cancelButtonTitle:@"不"
                              otherButtonTitles:@"是的",nil];
        [alert show];
        [alert release];
    }
}
-(void)shareProduct:(HotCell *)cell
{
    ShareSns *shareSns = [[ShareSns alloc]init];
    [shareSns showSnsShareSheet:self.tabBarController.view viewController:self shareImage:cell.myImageView.image shareText:cell.desLable.text];
}
*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		
        NSManagedObjectContext *context = [[CoreDataController sharedInstance]masterManagedObjectContext];
        NSFetchRequest *request= [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CollectProduct" inManagedObjectContext:context];
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"pic_url==%@",product.pic_url];
        [request setEntity:entity];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *array = [context executeFetchRequest:request error:&error];
        
        if ([array count] != 0) {
            
            [context deleteObject:[array objectAtIndex:0]];
        }
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }else{
            NSDictionary* delProduct = [NSDictionary dictionaryWithObject:product forKey:@"deletedProduct"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"COLLECT_SUCCESS" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_COLLECTED" object:nil userInfo:delProduct];
            [self.navigationController popViewControllerAnimated:YES];
        }
	}
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
