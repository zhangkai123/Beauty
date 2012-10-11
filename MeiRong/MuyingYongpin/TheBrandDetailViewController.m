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

@interface TheBrandDetailViewController ()

@end

@implementation TheBrandDetailViewController
@synthesize product;
@synthesize collection;

-(void)dealloc
{
    [theTableView release];
    [product release];
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
	// Do any additional setup after loading the view.
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 460-44-49) style:UITableViewStylePlain];
    theTableView.backgroundColor = [UIColor clearColor];
    //    [productTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    theTableView.delegate = self;
    theTableView.dataSource = self;
    theTableView.rowHeight = 400;
    [self.view addSubview:theTableView];

    self.view.backgroundColor = [UIColor lightGrayColor];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[HotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
    }
    cell.delegate = self;
    cell.rowNum = indexPath.row;
    [cell.theImageView setImageWithURL:[NSURL URLWithString:product.pic_url] placeholderImage:[UIImage imageNamed:@"placefold.jpeg"]];
    cell.desLable.text = product.title;
    if (product.collect) {
        [cell.collectButton setTitle:@"已收藏" forState:UIControlStateNormal];
        cell.collectButton.enabled = NO;
    }else{
        [cell.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
        cell.collectButton.enabled = YES;
    }
    if (collection) {
        [cell.collectButton setTitle:@"删除" forState:UIControlStateNormal];
    }
    return cell;
}
#pragma HotCellSelectionDelegate
-(void)selectTableViewCell:(HotCell *)cell
{
    WebViewController *webViewController = [[WebViewController alloc]init];
    webViewController.productUrlS = product.click_url;
    [self presentModalViewController:webViewController animated:YES];
    [webViewController release];
}
-(void)collectProduct:(HotCell *)cell
{
    NSManagedObjectContext *context = [[CoreDataController sharedInstance]managedObjectContext];
    
    if (!collection) {
        
        CollectProduct *collectProduct = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"CollectProduct"
                                          inManagedObjectContext:context];
        collectProduct.pic_url = product.pic_url;
        collectProduct.num_iid = product.num_iid;
        collectProduct.title = product.title;
        collectProduct.nick = product.nick;
        collectProduct.price = product.price;
        collectProduct.click_url = product.click_url;
        collectProduct.commission = product.commission;
        collectProduct.commission_rate = product.commission_rate;
        collectProduct.commission_num = product.commission_num;
        collectProduct.commission_volume = product.commission_volume;
        collectProduct.shop_click_url = product.shop_click_url;
        collectProduct.seller_credit_score = product.seller_credit_score;
        collectProduct.item_location = product.item_location;
        collectProduct.volume = product.volume;
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }else{
            product.collect = YES;
            [cell.collectButton setTitle:@"已收藏" forState:UIControlStateNormal];
            cell.collectButton.enabled = NO;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"COLLECT_SUCCESS" object:nil userInfo:nil];
        }
    }else{
        
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
            cell.collectButton.enabled = NO;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"COLLECT_SUCCESS" object:nil userInfo:nil];
        }
    }
}
-(void)shareProduct:(HotCell *)cell
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
