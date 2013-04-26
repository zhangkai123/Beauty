//
//  NewHotProductViewController.m
//  TaoZhuang
//
//  Created by zhang kai on 4/13/13.
//
//

#import "NewHotProductViewController.h"
#import "DataController.h"

@interface NewHotProductViewController ()

@property(nonatomic,readwrite) BOOL loadingmore;
@end

@implementation NewHotProductViewController
@synthesize catName;

-(void)dealloc
{
    [super dealloc];
}
-(id) initWithNavBar {
    if (self = [super initWithNavBar]) {
        // set the long name shown in the navigation bar at the top
        
         self.title = @"热销";
        self.tabBarItem.image = [UIImage imageNamed:@"ico_nav_hot"];
        titleLabel.text = @"热销";
        backButton.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        
        self._collectionView.frame = CGRectMake(0, 0, 320, 548);
    }else{
        self._collectionView.frame = CGRectMake(0, 0, 320, 460);
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveCatProducts:) name:self.catName object:nil];
    
    DataController *dataController = [DataController sharedDataController];
    [dataController fetachCateProducts:self.catName cateId:@"413" pageNumber:1];
    
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
    [dataController fetachCateProducts:self.catName cateId:@"413" pageNumber:pageN + 1];
    
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
