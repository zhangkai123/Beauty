//
//  NewTopicProductViewController.m
//  TaoZhuang
//
//  Created by zhang kai on 4/9/13.
//
//
#import <QuartzCore/CALayer.h>
#import "NewTopicProductViewController.h"
#import "UIImageView+WebCache.h"
#import "PSCollectionView.h"
#import "ProductCell.h"
#import "DataController.h"
#import "Product.h"
#import "TheBrandDetailViewController.h"

@interface NewTopicProductViewController ()
@property(nonatomic,readwrite) BOOL loadingmore;
@end

@implementation NewTopicProductViewController
@synthesize keyWord;

-(void)dealloc
{
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveTopicProducts:) name:self.keyWord object:nil];
        
    productsArray = [[NSMutableArray alloc]init];
    DataController *dataController = [DataController sharedDataController];
    [dataController featchKeywordProducts:self.keyWord pageNumber:1];
    
    self.loadingmore = YES;
}
-(void)recieveTopicProducts:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
     [activityIndicator stopAnimating];    
    self.loadingmore = NO;
    NSMutableArray *pArray = [notification object];
    [pArray retain];
    if ([pArray count] == 0) {
        
        [pArray release];
        return;    
    }
//    if (refresh) {
//        [productsArray removeAllObjects];
//    }

    [productsArray addObjectsFromArray:pArray];
    [pArray release];

        [self._collectionView reloadData];
    });
}

#pragma mark-
#pragma mark- UIScrollViewDelegate
- (void)loadMoreImages
{
    if (self.loadingmore) return;
    self.loadingmore = YES;

    int productN = [productsArray count];
    int pageN;
    if (productN % 20 == 0) {
        pageN = productN / 20;
    }
    else{
        [activityIndicator stopAnimating];
        return;
    }
    [activityIndicator startAnimating];
    DataController *dataController = [DataController sharedDataController];
    [dataController featchKeywordProducts:self.keyWord pageNumber:pageN + 1];
    currentPage = pageN;

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height + 50 + 10;
    
    if (bottomEdge >= scrollView.contentSize.height )
    {
        [self loadMoreImages];
        //[self performSelector:@selector(reloadData) withObject:self afterDelay:1.0f]; //make a delay to show loading process for a while
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
