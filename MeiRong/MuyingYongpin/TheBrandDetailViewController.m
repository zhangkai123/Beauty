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
    UILabel *titleLabel;
    UIView *shopView;
    
    UIButton *collectButton;
    float firstCellHeight;
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
    [titleLabel release];
    [shopView release];
    [collectButton release];
    [super dealloc];
}
-(id)initWithNavBar
{
    if (self = [super initWithNavBar]) {
        
    }
    return self;
}
-(void)setProduct:(Product *)myProduct
{
    if (product != myProduct) {
        [product release];
        product = [myProduct retain];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
        
	// Do any additional setup after loading the view.
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 548) style:UITableViewStylePlain];
    } else {
        // code for 3.5-inch screen
        theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 460) style:UITableViewStylePlain];
    }
    firstCellHeight = smallImage.size.height * 320 / smallImage.size.width;

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
            
//    realBackView = [[UIView alloc]initWithFrame:CGRectMake(0, firstCellHeight - 20 - 45 - 60, 320, 60)];
//    realBackView.backgroundColor = [UIColor blackColor];
//    [realBackView setAlpha:0.5];
//    [self.view addSubview:realBackView];
//    
//    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, realBackView.frame.origin.y + 15, 285, 30)];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    [titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [titleLabel setTextColor:[UIColor whiteColor]];
//    titleLabel.text = product.title;
//    [self.view addSubview:titleLabel];
//    
//    shopView = [[UIView alloc]initWithFrame:CGRectMake(320 - 145, firstCellHeight - 20 - 45 - 60 - 20, 145, 40)];
//    shopView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:shopView];
//    
//     UIImageView *shopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 145, 40)];
//    shopImageView.userInteractionEnabled = YES;
//    shopImageView.backgroundColor = [UIColor colorWithRed:1 green: 0.6 blue:0.8 alpha:1];
//    shopImageView.alpha = 0.8;
//    [shopView addSubview:shopImageView];
//    [shopImageView release];
//    
//     UILabel *shopLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 145, 40)];
//    shopLabel.backgroundColor = [UIColor clearColor];
//    [shopLabel setText:[NSString stringWithFormat:@"%@ | 查看详情",product.price]];
//    [shopLabel setTextColor:[UIColor whiteColor]];
//    [shopLabel setTextAlignment:NSTextAlignmentCenter];
//    [shopView addSubview:shopLabel];
//    [shopLabel release];
//    
//    UIButton *shopButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 145, 40)];
//    [shopButton addTarget:self action:@selector(buyProduct) forControlEvents:UIControlEventTouchUpInside];
//    [shopView addSubview:shopButton];
//    [shopButton release];
//    
//    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, firstCellHeight - 20 - 45, 320, 45)];
//    footerView.backgroundColor = [UIColor blackColor];
//    [footerView setAlpha:0.7];
//    [self.view addSubview:footerView];
//    [footerView release];
//    
//    collectButton = [[UIButton alloc]initWithFrame:CGRectMake(70, firstCellHeight - 20 - 45, 45, 45)];
//    [collectButton addTarget:self action:@selector(collectProduct) forControlEvents:UIControlEventTouchUpInside];
//    [collectButton setImage:[UIImage imageNamed:@"ico_footer_like"] forState:UIControlStateNormal];
//    [self.view addSubview:collectButton];
//    if (product.collect) {
//        [collectButton setImage:[UIImage imageNamed:@"ico_footer_like_active"] forState:UIControlStateNormal];
//    }else{
//        [collectButton setImage:[UIImage imageNamed:@"ico_footer_like"] forState:UIControlStateNormal];
//    }
//    self.collection = product.collect;
//
//    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(205, firstCellHeight - 20 - 45, 45, 45)];
//    [shareButton addTarget:self action:@selector(shareProduct) forControlEvents:UIControlEventTouchUpInside];
//    [shareButton setImage:[UIImage imageNamed:@"ico_footer_share"] forState:UIControlStateNormal];
//    [self.view addSubview:shareButton];
//    [shareButton release];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 //   [theTableView deselectRowAtIndexPath:[theTableView indexPathForSelectedRow] animated:YES];
}
//-(void)featchDetailData
//{
//    if (self.product) {
//        DataController *dataController = [DataController sharedDataController];
//        [dataController featchProductDetail:product.num_id theProduct:product];
//    }
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y >= 65) {
//        if (![realBackView isDescendantOfView:theTableView]) {
//            [realBackView removeFromSuperview];
//            [titleLabel removeFromSuperview];
//            realBackView.frame = CGRectMake(0, firstCellHeight - 60, realBackView.frame.size.width, realBackView.frame.size.height);
//            titleLabel.frame = CGRectMake(30, realBackView.frame.origin.y + 15, 280, 30);
//            [theTableView addSubview:realBackView];
//            [theTableView addSubview:titleLabel];
//            [self.view bringSubviewToFront:shopView];
//        }
//    }
//    if (scrollView.contentOffset.y <= 65) {
//        if ([realBackView isDescendantOfView:theTableView]) {
//            [realBackView removeFromSuperview];
//            [titleLabel removeFromSuperview];
//            realBackView.frame = CGRectMake(0, firstCellHeight - 20 - 45 - 60, 320, 60);
//            titleLabel.frame = CGRectMake(30, realBackView.frame.origin.y + 15, 280, 30);
//            [self.view addSubview:realBackView];
//            [self.view addSubview:titleLabel];
//            [self.view bringSubviewToFront:shopView];
//        }
//    }
//}
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
        
        rowHeight = firstCellHeight;
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
            firstImageCell = [[[FirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil imageHeight:firstCellHeight]autorelease];
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
    if (object == myImageView && [path isEqualToString:@"image"])
    {
        
    }else if(object == product && [path isEqualToString:@"imagesArray"]){
        
        [theTableView reloadData];
         [theTableView.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
        theTableView.showsInfiniteScrolling = NO;
    }
}

-(void)buyProduct
{
    WebViewController *webViewController = [[WebViewController alloc]init];
    webViewController.productUrlS = product.click_url;
    [self presentModalViewController:webViewController animated:YES];
    [webViewController release];
}

-(void)collectProduct
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
        collectProduct.num_iid = product.num_id;
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }else{
            product.collect = YES;
            collection = YES;
            [collectButton setImage:[UIImage imageNamed:@"ico_footer_like_active"] forState:UIControlStateNormal];
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
-(void)shareProduct
{
    FirstCell *firstCell = (FirstCell *)[theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    ShareSns *shareSns = [[ShareSns alloc]init];
    [shareSns showSnsShareSheet:self.view viewController:self shareImage:firstCell.myImageView.image shareText:product.title];
}

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
            product.collect = NO;
            collection = NO;
            [collectButton setImage:[UIImage imageNamed:@"ico_footer_like"] forState:UIControlStateNormal];
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
