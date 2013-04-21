//
//  NewProductRootViewController.m
//  TaoZhuang
//
//  Created by zhang kai on 4/12/13.
//
//

#import <QuartzCore/CALayer.h>
#import "NewProductRootViewController.h"
#import "ProductCell.h"
#import "Product.h"
#import "TheBrandDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface NewProductRootViewController ()<PSCollectionViewDelegate,PSCollectionViewDataSource,UIScrollViewDelegate>
{
    
}
@property(nonatomic,readwrite) BOOL loadingmore;

@end

@implementation NewProductRootViewController
@synthesize _collectionView;


-(void)dealloc
{
    [topBar release];
    [backButton release];
    [activityIndicator release];
    [productsArray release];
    [_collectionView release];
    [super dealloc];
}

-(void)goBack
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self dismissModalViewControllerAnimated:YES];
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
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundPaper"]];
    
    topBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    topBar.image = [UIImage imageNamed:@"navbar_background"];
    topBar.userInteractionEnabled = YES;
    topBar.layer.shadowColor = [UIColor blackColor].CGColor;
    topBar.layer.shadowOffset = CGSizeMake(0, 1);
    topBar.layer.shadowOpacity = 0.3;
    topBar.layer.shadowRadius = 1.0;
    topBar.clipsToBounds = NO;
    [self.view addSubview:topBar];
    backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"btn_header_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:backButton];
    
    // Do any additional setup after loading the view.
    _collectionView = [[PSCollectionView alloc] initWithFrame:CGRectZero];
    _collectionView.delegate = self; // This is for UIScrollViewDelegate
    _collectionView.collectionViewDelegate = self;
    _collectionView.collectionViewDataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
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
    footerView.backgroundColor = [UIColor clearColor];
    _collectionView.footerView = footerView;
    [footerView release];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 5, 20, 20)];
    [activityIndicator stopAnimating];
    [activityIndicator hidesWhenStopped];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [footerView addSubview:activityIndicator];
    
    productsArray = [[NSMutableArray alloc]init];
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
    cell.shopName = product.shopName;
    cell.seller_credit_score = product.seller_credit_score;
    cell.price = product.price;
    cell.promotionPrice = product.promotionPrice;
    cell.title = product.title;
    NSString *imageUrlStr = [NSString stringWithFormat:@"%@_160x160.jpg",product.pic_url];
    [cell.myImageView setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"smallbPlaceHolder.png"]];
	return cell;
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {
    Product *product = [productsArray objectAtIndex:index];
    
    CGSize theShopNameSize = [product.shopName sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(148 - 10 - 30, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    CGSize theTitleSize = [product.title sizeWithFont:[UIFont fontWithName:@"Heiti TC" size:12] constrainedToSize:CGSizeMake(148 - 10, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    return product.imageHeight + theTitleSize.height + theShopNameSize.height + 15 + 20 + 20;
}
- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index
{
    Product *product = [productsArray objectAtIndex:index];
    ProductCell *myCell = (ProductCell *)cell;
    
    TheBrandDetailViewController *theBrandDetailViewController = [[TheBrandDetailViewController alloc]initWithProduct:product];
    theBrandDetailViewController.smallImage = myCell.myImageView.image;
    [self presentModalViewController:theBrandDetailViewController animated:YES];
    [theBrandDetailViewController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
