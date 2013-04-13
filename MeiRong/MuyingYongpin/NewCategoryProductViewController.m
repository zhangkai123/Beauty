//
//  NewCategoryProductViewController.m
//  TaoZhuang
//
//  Created by zhang kai on 4/12/13.
//
//

#import "NewCategoryProductViewController.h"
#import "DataController.h"

@interface NewCategoryProductViewController ()

@property(nonatomic,readwrite) BOOL loadingmore;
@end

@implementation NewCategoryProductViewController
@synthesize catName ,catId;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveCatProducts:) name:self.catName object:nil];

    DataController *dataController = [DataController sharedDataController];
    [dataController fetachCateProducts:self.catName cateId:self.catId pageNumber:1];

    self.loadingmore = YES;
}
-(void)recieveCatProducts:(NSNotification *)notification
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
    [dataController fetachCateProducts:self.catName cateId:self.catId pageNumber:pageN + 1];

    currentPage = pageN;
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height + 50 + 10;
    
    if (bottomEdge >= scrollView.contentSize.height )
    {
        [self loadMoreImages];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
