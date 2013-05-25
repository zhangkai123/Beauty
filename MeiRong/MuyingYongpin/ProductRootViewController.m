//
//  ProductRootViewController.m
//  TaoZhuang
//
//  Created by zhang kai on 3/28/13.
//
//

#import <QuartzCore/CALayer.h>
#import "ProductRootViewController.h"
#import "Product.h"
#import "UIImageView+WebCache.h"
#import "TheBrandDetailViewController.h"

@interface ProductRootViewController ()
{
    UITableViewCell *selectedCell;
}


@end

@implementation ProductRootViewController
@synthesize titleLabel;

-(void)dealloc
{
    [topBar release];
    [theTalbleView release];
    [productsArray release];
    [titleLabel release];
    [super dealloc];
}

-(id) initWithTabBar {
    if ([self init]) {
        
        // set the long name shown in the navigation bar at the top
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 7, 160, 30)];
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        titleLabel.font = [UIFont fontWithName:@"迷你简黛玉" size:25];
        titleLabel.shadowColor   = [[UIColor blackColor]colorWithAlphaComponent: 0.2f];
        titleLabel.shadowOffset  = CGSizeMake(1.0,1.0);
        titleLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)startActivity{
    
    UIActivityIndicatorView *activityView = [[[[topBar subviews]objectAtIndex:0]subviews]objectAtIndex:0];
    [activityView startAnimating];
}

-(void)stopActivity{
    
    UIActivityIndicatorView *activityView = [[[[topBar subviews]objectAtIndex:0]subviews]objectAtIndex:0];
    [activityView stopAnimating];
}

-(void)createActivity
{
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [activityIndicator stopAnimating];
    [activityIndicator hidesWhenStopped];
    UIView *rightItem = [[UIView alloc]initWithFrame:CGRectMake(290, 7, 30, 20)];
    [rightItem addSubview:activityIndicator];
    [activityIndicator release];
    [topBar addSubview:rightItem];
    [rightItem release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    topBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    topBar.image = [UIImage imageNamed:@"navbar_background"];
    topBar.userInteractionEnabled = YES;
    topBar.layer.shadowColor = [UIColor blackColor].CGColor;
    topBar.layer.shadowOffset = CGSizeMake(0, 1);
    topBar.layer.shadowOpacity = 0.3;
    topBar.layer.shadowRadius = 1.0;
    topBar.clipsToBounds = NO;
    [self.view addSubview:topBar];
    
    [self createActivity];
    [topBar addSubview:titleLabel];
        
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SheetBackground"]];

    // Do any additional setup after loading the view.
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        theTalbleView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, 320, 548-45) style:UITableViewStylePlain];
    } else {
        // code for 3.5-inch screen
        theTalbleView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, 320, 460-45) style:UITableViewStylePlain];
    }
    [theTalbleView setBackgroundColor:[UIColor clearColor]];
    [theTalbleView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    theTalbleView.rowHeight = 190;
    theTalbleView.dataSource = self;
    theTalbleView.delegate = self;
    [self.view addSubview:theTalbleView];
    
    productsArray = [[NSMutableArray alloc]init];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount;
    int totalProducts = [productsArray count];
    if (totalProducts%2 == 1) {
        rowCount = (totalProducts +1)/2;
    }else{
        rowCount = totalProducts/2;
    }
    return rowCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StyleOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[StyleOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
    }
    cell.rowNum = indexPath.row;
    cell.delegate = self;
    Product *leftProduct = [productsArray objectAtIndex:indexPath.row*2];
    //change to big image to see if better performance
    NSString *lProduct = [NSString stringWithFormat:@"%@_160x160.jpg",leftProduct.pic_url];
    [cell.leftImageView setImageWithURL:[NSURL URLWithString:lProduct] placeholderImage:[UIImage imageNamed:@"smallbPlaceHolder.png"]];
//        [cell.leftImageView setImageWithURL:[NSURL URLWithString:lProduct] placeholderImage:[UIImage imageNamed:@"smallbPlaceHolder.png"]];
    cell.priceLabel2.text = leftProduct.price;
    cell.likeLabel2.text = leftProduct.seller_credit_score;
    
    cell.coverView2.hidden = NO;
    if ([productsArray count] > indexPath.row*2 + 1) {
        Product *rightProduct = [productsArray objectAtIndex:indexPath.row*2 + 1];
        NSString *rProduct = [NSString stringWithFormat:@"%@_160x160.jpg",rightProduct.pic_url];
        [cell.rightImageView setImageWithURL:[NSURL URLWithString:rProduct] placeholderImage:[UIImage imageNamed:@"smallbPlaceHolder.png"]];
//                [cell.rightImageView setImageWithURL:[NSURL URLWithString:rProduct] placeholderImage:[UIImage imageNamed:@"smallbPlaceHolder.png"]];
        cell.priceLabelR2.text = rightProduct.price;
        cell.likeLabel2R.text = rightProduct.seller_credit_score;
    }else{
        cell.coverView2.hidden = YES;
    }
    return cell;
}
#pragma StyleOneCellSelectionDelegate
-(void)selectTableViewCell:(StyleOneCell *)cell selectedItemAtIndex:(NSInteger)index
{
    selectedCell = cell;
    int productIndex;
    UIImage *smallImage = nil;
    if (index == 0) {
        productIndex = cell.rowNum * 2;
        smallImage = cell.leftImageView.image;
    }else{
        productIndex = cell.rowNum * 2 + 1;
        smallImage = cell.rightImageView.image;
    }
    Product *product = [productsArray objectAtIndex:productIndex];
    
    TheBrandDetailViewController *theBrandDetailViewController = [[TheBrandDetailViewController alloc]initWithProduct:product];
    theBrandDetailViewController.smallImage = smallImage;
    [self presentModalViewController:theBrandDetailViewController animated:YES];
    [theBrandDetailViewController release];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (selectedCell != nil) {
        [(StyleOneCell *)selectedCell diselectCell];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
