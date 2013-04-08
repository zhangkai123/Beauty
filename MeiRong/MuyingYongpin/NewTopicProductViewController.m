//
//  NewTopicProductViewController.m
//  TaoZhuang
//
//  Created by zhang kai on 4/9/13.
//
//
#import <QuartzCore/CALayer.h>
#import "NewTopicProductViewController.h"
#import "PSCollectionView.h"
#import "ProductCell.h"
#import "DataController.h"
#import "Product.h"

@interface NewTopicProductViewController ()<PSCollectionViewDelegate,PSCollectionViewDataSource,UIScrollViewDelegate>

@property(nonatomic,retain) PSCollectionView *collectionView;
@end

@implementation NewTopicProductViewController
@synthesize keyWord ,productsArray;

-(void)dealloc
{
    [productsArray release];
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
    self.collectionView = [[PSCollectionView alloc] initWithFrame:CGRectZero];
    self.collectionView.delegate = self; // This is for UIScrollViewDelegate
    self.collectionView.collectionViewDelegate = self;
    self.collectionView.collectionViewDataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SheetBackground"]];
    self.collectionView.autoresizingMask = ~UIViewAutoresizingNone;
    self.collectionView.numColsPortrait = 2;
    self.collectionView.numColsLandscape = 2;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        
        self.collectionView.frame = CGRectMake(0, 45, 320, 548 - 45);
    }else{
        self.collectionView.frame = CGRectMake(0, 45, 320, 460 - 45);
    }

    [self.view addSubview:self.collectionView];
    
    DataController *dataController = [DataController sharedDataController];
    [dataController featchKeywordProducts:self.keyWord pageNumber:1];
}
-(void)recieveTopicProducts:(NSNotification *)notification
{
    self.productsArray = [notification object];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.collectionView reloadData];
    });
}

- (Class)collectionView:(PSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index {
    return [PSCollectionViewCell class];
}

- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView {
    return [productsArray count];
}

- (UIView *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index {
//    static NSString *CellIdentifier = @"Cell";
	ProductCell *cell = (ProductCell *)[collectionView dequeueReusableViewForClass:[ProductCell class]];
	
	if(cell == nil)
	{
		cell  = [[[ProductCell alloc] initWithFrame:CGRectZero]autorelease];		
	}
    Product *product = [productsArray objectAtIndex:index];
    [cell setImageWithURL:[NSURL URLWithString:product.pic_url] placeholderImage:[UIImage imageNamed:@"smallbPlaceHolder.png"]];
	return cell;
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {
    Product *product = [productsArray objectAtIndex:index];
    return product.imageHeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
