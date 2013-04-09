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

@interface NewTopicProductViewController ()<PSCollectionViewDelegate,PSCollectionViewDataSource,UIScrollViewDelegate>
{
    PSCollectionView *_collectionView;
}
@property(nonatomic,retain) PSCollectionView *_collectionView;
@property(nonatomic,readwrite) BOOL loadingmore;
@end

@implementation NewTopicProductViewController
@synthesize _collectionView;
@synthesize keyWord ,productsArray;

-(void)dealloc
{
    [productsArray release];
    [_collectionView release];
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
-(void)goBack
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveTopicProducts:) name:@"TOPIC_PRODUCT" object:nil];
    
    UIImageView *topBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    topBar.image = [UIImage imageNamed:@"navbar_background"];
    topBar.userInteractionEnabled = YES;
    topBar.layer.shadowColor = [UIColor blackColor].CGColor;
    topBar.layer.shadowOffset = CGSizeMake(0, 1);
    topBar.layer.shadowOpacity = 0.3;
    topBar.layer.shadowRadius = 1.0;
    topBar.clipsToBounds = NO;
    [self.view addSubview:topBar];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"btn_header_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:backButton];
    [backButton release];
    [topBar release];

	// Do any additional setup after loading the view.
    _collectionView = [[PSCollectionView alloc] initWithFrame:CGRectZero];
    _collectionView.delegate = self; // This is for UIScrollViewDelegate
    _collectionView.collectionViewDelegate = self;
    _collectionView.collectionViewDataSource = self;
    _collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SheetBackground"]];
    _collectionView.autoresizingMask = ~UIViewAutoresizingNone;
    _collectionView.numColsPortrait = 2;
    _collectionView.numColsLandscape = 2;
    _collectionView.decelerationRate = 0.001;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        
        self._collectionView.frame = CGRectMake(0, 45, 320, 548 - 45);
    }else{
        self._collectionView.frame = CGRectMake(0, 45, 320, 460 - 45);
    }

    [self.view addSubview:self._collectionView];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    footerView.backgroundColor = [UIColor blackColor];
    _collectionView.footerView = footerView;
    
    productsArray = [[NSMutableArray alloc]init];
    DataController *dataController = [DataController sharedDataController];
    [dataController featchKeywordProducts:self.keyWord pageNumber:1];
    
    self.loadingmore = YES;
}
-(void)recieveTopicProducts:(NSNotification *)notification
{
    self.loadingmore = NO;
    NSMutableArray *pArray = [notification object];
    [pArray retain];
    if ([pArray count] == 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [theTalbleView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
//            [theTalbleView.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
//            [self stopActivity];
        });
        [pArray release];
        return;    
    }
//    if (refresh) {
//        [productsArray removeAllObjects];
//    }

    [productsArray addObjectsFromArray:pArray];
    [pArray release];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [theTalbleView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
//        [theTalbleView.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
//        [self stopActivity];
//        if (refresh) {
//            [theTalbleView reloadData];
//        }else{
//            [theTalbleView insertRowsAtIndexPaths:rowsInsertIndexPath withRowAnimation:UITableViewRowAnimationRight];
//            [rowsInsertIndexPath release];
//        }
        [self._collectionView reloadData];
    });
}

- (Class)collectionView:(PSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index {
    return [PSCollectionViewCell class];
}

- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView {
    return [productsArray count];
}

- (UIView *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index {

	ProductCell *cell = (ProductCell *)[collectionView dequeueReusableViewForClass:[ProductCell class]];
	
	if(cell == nil)
	{
		cell  = [[[ProductCell alloc] initWithFrame:CGRectZero]autorelease];		
	}
    Product *product = [productsArray objectAtIndex:index];
    cell.imageHeight = product.imageHeight;
    [cell.myImageView setImageWithURL:[NSURL URLWithString:product.pic_url] placeholderImage:[UIImage imageNamed:@"smallbPlaceHolder.png"]];
	return cell;
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {
    Product *product = [productsArray objectAtIndex:index];
    return product.imageHeight;
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
//        [weaktheTalbleView.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0];
        return;
    }
    DataController *dataController = [DataController sharedDataController];
    [dataController featchKeywordProducts:self.keyWord pageNumber:pageN + 1];
    currentPage = pageN;

}
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height + 50 + 50;
//    
//    if (bottomEdge >= scrollView.contentSize.height )
//    {
//        [self loadMoreImages];
//        //[self performSelector:@selector(reloadData) withObject:self afterDelay:1.0f]; //make a delay to show loading process for a while
//    }
//}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height + 50 + 10;
    
    if (bottomEdge >= scrollView.contentSize.height )
    {
        [self loadMoreImages];
        //[self performSelector:@selector(reloadData) withObject:self afterDelay:1.0f]; //make a delay to show loading process for a while
    }
}
//-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    [scrollView setContentOffset:scrollView.contentOffset animated:YES];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
