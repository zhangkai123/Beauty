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
@synthesize catName;

-(NSString *)getNotificationName
{
    NSString *notificationName;
    if ([self.catName isEqualToString:@"热销"]){
        
        notificationName = @"NOTIFICATION_0";
    }else if ([self.catName isEqualToString:@"美白"]) {
        
        notificationName = @"NOTIFICATION_1";
    }else if([self.catName isEqualToString:@"保湿"]){
        
        notificationName = @"NOTIFICATION_2";
    }else if([self.catName isEqualToString:@"祛痘"]){
        
        notificationName = @"NOTIFICATION_3";
    }else if([self.catName isEqualToString:@"抗敏"]){
        
        notificationName = @"NOTIFICATION_4";
    }else if([self.catName isEqualToString:@"遮瑕"]){
        
        notificationName = @"NOTIFICATION_5";
    }else if([self.catName isEqualToString:@"祛斑"]){
        
        notificationName = @"NOTIFICATION_6";
    }else if([self.catName isEqualToString:@"控油"]){
        
        notificationName = @"NOTIFICATION_7";
    }else if([self.catName isEqualToString:@"补水"]){
        
        notificationName = @"NOTIFICATION_8";
    }else if([self.catName isEqualToString:@"去黑头"]){
        
        notificationName = @"NOTIFICATION_9";
    }else if([self.catName isEqualToString:@"收毛孔"]){
        
        notificationName = @"NOTIFICATION_10";
    }else if([self.catName isEqualToString:@"去眼袋"]){
        
        notificationName = @"NOTIFICATION_11";
    }
    
    else if([self.catName isEqualToString:@"防晒霜"]){
        
        notificationName = @"NOTIFICATION_12";
    }else if([self.catName isEqualToString:@"喷雾"]){
        
        notificationName = @"NOTIFICATION_13";
    }else if([self.catName isEqualToString:@"卸妆油"]){
        
        notificationName = @"NOTIFICATION_14";
    }else if([self.catName isEqualToString:@"洗面奶"]){
        
        notificationName = @"NOTIFICATION_15";
    }else if([self.catName isEqualToString:@"面膜"]){
        
        notificationName = @"NOTIFICATION_16";
    }else if([self.catName isEqualToString:@"眼霜"]){
        
        notificationName = @"NOTIFICATION_17";
    }else if([self.catName isEqualToString:@"化妆水"]){
        
        notificationName = @"NOTIFICATION_18";
    }else if([self.catName isEqualToString:@"面霜"]){
        
        notificationName = @"NOTIFICATION_19";
    }else if([self.catName isEqualToString:@"隔离霜"]){
        
        notificationName = @"NOTIFICATION_20";
    }else if([self.catName isEqualToString:@"吸油面纸"]){
        
        notificationName = @"NOTIFICATION_21";
    }else if([self.catName isEqualToString:@"药妆"]){
        
        notificationName = @"NOTIFICATION_22";
    }
    
    else if([self.catName isEqualToString:@"香水"]){
        
        notificationName = @"NOTIFICATION_23";
    }else if([self.catName isEqualToString:@"指甲油"]){
        
        notificationName = @"NOTIFICATION_24";
    }else if([self.catName isEqualToString:@"睫毛膏"]){
        
        notificationName = @"NOTIFICATION_25";
    }else if([self.catName isEqualToString:@"BB霜"]){
        
        notificationName = @"NOTIFICATION_26";
    }else if([self.catName isEqualToString:@"粉饼"]){
        
        notificationName = @"NOTIFICATION_27";
    }else if([self.catName isEqualToString:@"蜜粉"]){
        
        notificationName = @"NOTIFICATION_28";
    }else if([self.catName isEqualToString:@"口红"]){
        
        notificationName = @"NOTIFICATION_29";
    }else if([self.catName isEqualToString:@"腮红"]){
        
        notificationName = @"NOTIFICATION_30";
    }else if([self.catName isEqualToString:@"眼影"]){
        
        notificationName = @"NOTIFICATION_31";
    }else if([self.catName isEqualToString:@"眉笔"]){
        
        notificationName = @"NOTIFICATION_32";
    }else if([self.catName isEqualToString:@"唇彩"]){
        
        notificationName = @"NOTIFICATION_33";
    }else if([self.catName isEqualToString:@"眼线膏"]){
        
        notificationName = @"NOTIFICATION_34";
    }
    
    else if([self.catName isEqualToString:@"手工皂"]){
        
        notificationName = @"NOTIFICATION_35";
    }else if([self.catName isEqualToString:@"沐浴露"]){
        
        notificationName = @"NOTIFICATION_36";
    }else if([self.catName isEqualToString:@"美颈霜"]){
        
        notificationName = @"NOTIFICATION_37";
    }else if([self.catName isEqualToString:@"身体乳"]){
        
        notificationName = @"NOTIFICATION_38";
    }else if([self.catName isEqualToString:@"护手霜"]){
        
        notificationName = @"NOTIFICATION_39";
    }else if([self.catName isEqualToString:@"假发"]){
        
        notificationName = @"NOTIFICATION_40";
    }else if([self.catName isEqualToString:@"发蜡"]){
        
        notificationName = @"NOTIFICATION_41";
    }else if([self.catName isEqualToString:@"弹力素"]){
        
        notificationName = @"NOTIFICATION_42";
    }else if([self.catName isEqualToString:@"发膜"]){
        
        notificationName = @"NOTIFICATION_43";
    }else if([self.catName isEqualToString:@"蓬蓬粉"]){
        
        notificationName = @"NOTIFICATION_44";
    }else if([self.catName isEqualToString:@"染发膏"]){
        
        notificationName = @"NOTIFICATION_45";
    }
    
    return notificationName;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *notificationName = [self getNotificationName];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveCatProducts:) name:notificationName object:nil];

    DataController *dataController = [DataController sharedDataController];
    [dataController fetachCateProducts:self.catName notiName:notificationName pageNumber:1];

    self.loadingmore = YES;
}
-(void)recieveCatProducts:(NSNotification *)notification
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
//    DataController *dataController = [DataController sharedDataController];
//    [dataController featchKeywordProducts:self.keyWord pageNumber:pageN + 1];
    
    NSString *notificationName = [self getNotificationName];
    DataController *dataController = [DataController sharedDataController];
    [dataController fetachCateProducts:self.catName notiName:notificationName pageNumber:pageN + 1];

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
