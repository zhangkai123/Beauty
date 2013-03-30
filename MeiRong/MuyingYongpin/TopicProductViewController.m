//
//  TopicProductViewController.m
//  TaoZhuang
//
//  Created by zhang kai on 3/28/13.
//
//

#import "TopicProductViewController.h"
#import "DataController.h"
#import "SVPullToRefresh.h"
#import "CoreDataController.h"

@interface TopicProductViewController ()
{
    NSManagedObjectContext *context;
}
@end

@implementation TopicProductViewController
@synthesize keyWord ,navTitle;

-(void)dealloc
{
    [context release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self createNavBackButton];
    self.titleLabel.text = self.navTitle;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveTopicProducts:) name:@"TOPIC_PRODUCT" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCollected:) name:@"REFRESH_COLLECTED" object:nil];
    
    __block UITableView *weaktheTalbleView = theTalbleView;
    __block NSMutableArray *weakproductsArray = productsArray;
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
        [dataController featchTopicProducts:self.keyWord pageNumber:1];
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
        [dataController featchTopicProducts:self.keyWord pageNumber:pageN + 1];
        weakCurrentPage = pageN;
    }];
    
    DataController *dataController = [DataController sharedDataController];
    [dataController featchTopicProducts:self.keyWord pageNumber:1];
    
    [self startActivity];

}
-(void)recieveTopicProducts:(NSNotification *)notification
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
