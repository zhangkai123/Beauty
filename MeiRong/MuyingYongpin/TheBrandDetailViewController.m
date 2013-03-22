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

@interface TheBrandDetailViewController()
{
    UITableViewCell *selectedCell;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNavBackButton];
	// Do any additional setup after loading the view.
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 548-44-49) style:UITableViewStylePlain];
    } else {
        // code for 3.5-inch screen
        theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 460-44-49) style:UITableViewStylePlain];
    }

    theTableView.backgroundColor = [UIColor clearColor];
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    theTableView.showsVerticalScrollIndicator = NO;
    theTableView.delegate = self;
    theTableView.dataSource = self;
    theTableView.rowHeight = 390;
    [self.view addSubview:theTableView];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SheetBackground"]];
    
    [product addObserver:self
                  forKeyPath:@"description"
                     options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                     context:NULL];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [theTableView deselectRowAtIndexPath:[theTableView indexPathForSelectedRow] animated:YES];
    if (selectedCell != nil) {
        [(HotCell *)selectedCell diselectCell];
    }
    [self featchDetailData];
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
    [myImageView removeObserver:self forKeyPath:@"image" context:NULL];
    [product removeObserver:self forKeyPath:@"description" context:NULL];
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + [self.product.imagesArray count];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 0;
    if (indexPath.row == 0) {
        rowHeight = 390;
    }else{
        
        NSDictionary *imageDic = [self.product.imagesArray objectAtIndex:indexPath.row - 1];
        rowHeight = [[imageDic objectForKey:@"imageHeight"] floatValue];
    }
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theCell = nil;
    if (indexPath.row == 0) {
        HotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[[HotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
        }
        cell.delegate = self;
        cell.rowNum = indexPath.row;
        [cell.myImageView setImageWithURL:[NSURL URLWithString:product.pic_url] placeholderImage:self.smallImage];
        
        myImageView = cell.myImageView;
        [myImageView addObserver:self
                      forKeyPath:@"image"
                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                         context:NULL];
        
        cell.desLable.text = product.title;
        cell.priceLabel2.text = product.price;
        cell.likeLabel2.text = product.seller_credit_score;
        if (product.collect) {
            [cell.collectLabel setText:@"已收藏"];
            cell.collectButton.enabled = NO;
        }else{
            [cell.collectLabel setText:@"收藏"];
            cell.collectButton.enabled = YES;
        }
        if (collection) {
            [cell.collectLabel setText:@"删除"];
        }
        theCell = cell;
    }else{
//        theCell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
        if (!theCell) {
            theCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease];
        }
        NSString *imageUrlStr = [[product.imagesArray objectAtIndex:indexPath.row - 1] objectForKey:@"imageUrl"];
        [theCell.imageView setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"bPlaceHolder.png"]];
    }
    return theCell;
}
- (void) observeValueForKeyPath:(NSString *)path ofObject:(id) object change:(NSDictionary *) change context:(void *)context
{
    // this method is used for all observations, so you need to make sure
    // you are responding to the right one.
    if (object == myImageView && [path isEqualToString:@"image"])
    {
        UIImage *newImage = [change objectForKey:NSKeyValueChangeNewKey];
        UIImage *oldImage = [change objectForKey:NSKeyValueChangeOldKey];
        
        // oldImage is the image *before* the property changed
        // newImage is the image *after* the property changed
    }else if(object == product && [path isEqualToString:@"description"]){
        
        NSLog(@"---%@---\n",product.description);
        [theTableView reloadData];
    }
}

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
