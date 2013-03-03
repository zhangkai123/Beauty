//
//  DataController.m
//  MuyingYongpin
//
//  Created by kai zhang on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataController.h"
#import "SBJson.h"
#import "Product.h"
#import "DDXML.h"
#import "FashionNews.h"
#import "ReachableManager.h"
#import "Utility.h"


#define ServerIp @"http://42.121.112.195"
#define hostIp @"http://10.21.98.93"

@implementation DataController

+(id)sharedDataController
{
    static DataController *dataController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dataController = [[DataController alloc]init];
    });
    return dataController;
}
-(id)init
{
    if (self = [super init]) {
    }
    return self;
}
-(void)showNoNetwork
{
    [[NSNotificationCenter defaultCenter] postNotificationName: kNotReachabilityNotification object: nil];
}
-(void)showAlert:(NSString *)alertMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: nil
                                  message: alertMessage
                                  delegate: nil
                                  cancelButtonTitle:@"ok"
                                  otherButtonTitles:nil,nil];
            [alert show];
            [alert release];
    });
}
-(void)fetachHotProducts:(int)pageN
{
    if (![[ReachableManager sharedReachableManager]reachable]) {
        [self performSelector:@selector(showNoNetwork) withObject:nil afterDelay:1.0];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
//        NSError *error;
//        NSURLResponse *theResponse;
//        NSString *urlString = [NSString stringWithFormat:@"%@/PinPHP_V2.21/fetchProducts.php",ServerIp];
//        NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//        [theRequest setHTTPMethod:@"POST"];
//        NSString *postString = [NSString stringWithFormat:@"catId=415&pageNumber=%d",pageN];  
//        [theRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        NSData *resultData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
//        /* Return Value
//         The downloaded data for the URL request. Returns nil if a connection could not be created or if the download fails.
//         */
//        if (resultData == nil) {
//            
//            // Check for problems
//            if (error != nil) {
//                [self showAlert:[error description]];
//            }else{
//                [self showAlert:@"返回数据为空"];
//            }
//        }
//        else {
//            // Data was received.. continue processing
//            NSMutableArray *pArray = [self parseProductsData:resultData];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"HOT_PRODUCTS_REARDY" object:pArray userInfo:nil];
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        }
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        [params setObject:@"title,pic_url,price,seller_credit_score,click_url" forKey:@"fields"];
        [params setObject:@"50010788" forKey:@"cid"];
        [params setObject:@"taobao.taobaoke.items.get" forKey:@"method"];
//        [params setObject:@"32217399" forKey:@"pid"];
        [params setObject:[NSString stringWithFormat:@"%d",pageN] forKey:@"page_no"];
        [params setObject:@"20" forKey:@"page_size"];
//        [params setObject:@"5goldencrown" forKey:@"start_credit"];
        [params setObject:@"30" forKey:@"start_price"];
        [params setObject:@"2000" forKey:@"end_price"];
        [params setObject:@"commissionNum_desc" forKey:@"sort"];
//        [params setObject:@"true" forKey:@"overseas_item"];
//        [params setObject:@"true" forKey:@"mall_item"];
        [params setObject:@"true" forKey:@"is_mobile"];
        
        NSData *resultData=[Utility getResultData:params];
        NSString *productsString = [[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
        NSLog(@"---%@---\n",productsString);
        [params release];
        NSMutableArray *pArray = [self parseProductsData:resultData];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"HOT_PRODUCTS_REARDY" object:pArray userInfo:nil];
    });
}
-(void)fetachCateProducts:(NSString *)cateName notiName:(NSString *)nName pageNumber:(int)pageN
{
    if (![[ReachableManager sharedReachableManager]reachable]) {
        [self performSelector:@selector(showNoNetwork) withObject:nil afterDelay:1.0];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
//        int catId = [self getNotificationId:cateName];
        int catId = [self getServerNotificationId:cateName];
        
        NSError *error;
        NSURLResponse *theResponse;
//        NSString *urlString = [NSString stringWithFormat:@"%@/~zhangkai/PinPHP_V2.21/fetchProducts.php",hostIp];
        NSString *urlString = [NSString stringWithFormat:@"%@/PinPHP_V2.21/fetchProducts.php",ServerIp];
        NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [theRequest setHTTPMethod:@"POST"];
        NSString *postString = [NSString stringWithFormat:@"catId=%d&pageNumber=%d",catId,pageN];
        [theRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSData *resultData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
        
        /* Return Value
         The downloaded data for the URL request. Returns nil if a connection could not be created or if the download fails.
         */
        if (resultData == nil) {
            
            // Check for problems
            if (error != nil) {
                [self showAlert:[error description]];
            }else{
                [self showAlert:@"返回数据为空"];
            }
        }
        else {
            // Data was received.. continue processing
            NSMutableArray *pArray = [self parseProductsData:resultData];
            [[NSNotificationCenter defaultCenter]postNotificationName:nName object:pArray userInfo:nil];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    });
}
//-(NSMutableArray *)parseProductsData:(NSData *)data
//{
//    NSString *productsString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//
//    NSArray *productArray = [productsString JSONValue];
//    
//    NSLog(@"---%@---\n",productsString);
//    [productsString release];
//    
//    NSMutableArray *pArray = [[NSMutableArray alloc]init];
//    for (int i = 0; i < [productArray count]; i++) {
//        NSDictionary *item = [productArray objectAtIndex:i];
//        
//        Product *product = [[Product alloc]init];
//        product.title = [item objectForKey:@"title"];
//        product.price = [item objectForKey:@"price"];
//        product.likes = [item objectForKey:@"likes"];
//        product.pic_url = [item objectForKey:@"bimg"];
//        product.click_url = [item objectForKey:@"url"];
//        NSLog(@"%@",product.click_url);
//        [pArray addObject:product];
//        [product release];
//    }    
//    return [pArray autorelease];
//}
-(NSMutableArray *)parseProductsData:(NSData *)data
{
    NSString *productsString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *productsDic = [productsString JSONValue];
    //    NSLog(@"---%@---\n",productsString);
    [productsString release];
    NSDictionary *taobaoke_items_get_response = [productsDic objectForKey:@"taobaoke_items_get_response"];
    NSDictionary *taobaoke_items = [taobaoke_items_get_response objectForKey:@"taobaoke_items"];
    
    NSArray *taobaoke_item = [taobaoke_items objectForKey:@"taobaoke_item"];
    
    NSMutableArray *pArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [taobaoke_item count]; i++) {
        
        NSDictionary *item = [taobaoke_item objectAtIndex:i];
        Product *product = [[Product alloc]init];
        product.title = [item objectForKey:@"title"];
        product.price = [item objectForKey:@"price"];
        product.seller_credit_score = [NSString stringWithFormat:@"%@",[item objectForKey:@"seller_credit_score"]];
        product.pic_url = [item objectForKey:@"pic_url"];
        product.click_url = [item objectForKey:@"click_url"];
        NSLog(@"%@",product.click_url);
        [pArray addObject:product];
        [product release];
    }
    return [pArray autorelease];
}


//send the rss request
-(void)featchRssData
{
    if (![[ReachableManager sharedReachableManager]reachable]) {
        [self performSelector:@selector(showNoNetwork) withObject:nil afterDelay:1.0];
    }

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *postURL = @"http://rss.sina.com.cn/eladies/gnspxw.xml";
        NSError *error;
        NSURLResponse *theResponse;
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:postURL]];
        NSData *xmlData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
//        NSString *xmlString = [[NSString alloc]initWithData:xmlData encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",xmlString);
        
        /* Return Value
         The downloaded data for the URL request. Returns nil if a connection could not be created or if the download fails.
         */
        if (xmlData == nil) {
            
            // Check for problems
            if (error != nil) {
                [self showAlert:[error description]];
            }else{
                [self showAlert:@"返回数据为空"];
            }
        }
        else {
            // Data was received.. continue processing
            NSMutableArray *newsArray = [self parseRssData:xmlData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NEWS_READY" object:newsArray userInfo:nil];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    });
}
-(NSMutableArray *)parseRssData:(NSData *)data
{
    NSError *error;
    DDXMLDocument *ddDoc = [[DDXMLDocument alloc] initWithData:data options:0 error:&error];
    NSArray *xmlItems = [ddDoc nodesForXPath:@"//item" error:&error];
    [ddDoc release];
    
    NSMutableArray *newsArray = [[NSMutableArray alloc]init];
    for(DDXMLElement* itemElement in xmlItems)
    {
        FashionNews *fashionNews = [[FashionNews alloc] init];
        
        NSString *title = [[[itemElement elementsForName:@"title"]lastObject]stringValue];
        NSString *puDate = [[[itemElement elementsForName:@"pubDate"]lastObject]stringValue];
        NSString *link = [[[itemElement elementsForName:@"link"]lastObject]stringValue];
        NSString *author = [[[itemElement elementsForName:@"author"]lastObject]stringValue];
        NSString *description = [[[itemElement elementsForName:@"description"]lastObject]stringValue];
        
        fashionNews.title = title;
        fashionNews.pubDate = puDate;
        fashionNews.link = link;
        fashionNews.author = author;
        fashionNews.description = description;
        
        if (![description isEqualToString:@""]) {
            
            [newsArray addObject:fashionNews];
        }
        [fashionNews release];
    }
    return [newsArray autorelease];
}
- (NSString *)stringCleaner:(NSString *)yourString {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:yourString];
    
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        yourString = [yourString stringByReplacingOccurrencesOfString:
                      [NSString stringWithFormat:@"%@>", text]
                                                           withString:@""];
        
    }
    
    return yourString;
    
}

//get categoryId
-(int)getNotificationId:(NSString *)catName
{
    int notificationId;
    if ([catName isEqualToString:@"碧欧泉"]) {
        
        notificationId = 418;
    }else if([catName isEqualToString:@"香奈儿"]){
        
        notificationId = 419;
    }else if([catName isEqualToString:@"倩碧"]){
        
        notificationId = 420;
    }else if([catName isEqualToString:@"雅诗兰黛"]){
        
        notificationId = 421;
    }else if([catName isEqualToString:@"兰蔻"]){
        
        notificationId = 422;
    }else if([catName isEqualToString:@"玫琳凯"]){
        
        notificationId = 423;
    }else if([catName isEqualToString:@"迪奥"]){
        
        notificationId = 424;
    }else if([catName isEqualToString:@"欧莱雅"]){
        
        notificationId = 425;
    }else if([catName isEqualToString:@"相宜本草"]){
        
        notificationId = 426;
    }else if([catName isEqualToString:@"玉兰油"]){
        
        notificationId = 427;
    }else if([catName isEqualToString:@"the face shop"]){
        
        notificationId = 428;
    }else if([catName isEqualToString:@"美宝莲"]){
        
        notificationId = 430;
    }else if([catName isEqualToString:@"skin79"]){
        
        notificationId = 431;
    }else if([catName isEqualToString:@"卡姿兰"]){
        
        notificationId = 432;
    }
    return notificationId;
}
//get categoryId
-(int)getServerNotificationId:(NSString *)catName
{
    int notificationId;
    if ([catName isEqualToString:@"美白"]) {
        
        notificationId = 188;
    }else if([catName isEqualToString:@"保湿"]){
        
        notificationId = 189;
    }else if([catName isEqualToString:@"祛痘"]){
        
        notificationId = 190;
    }else if([catName isEqualToString:@"抗敏"]){
        
        notificationId = 191;
    }else if([catName isEqualToString:@"遮瑕"]){
        
        notificationId = 192;
    }else if([catName isEqualToString:@"祛斑"]){
        
        notificationId = 193;
    }else if([catName isEqualToString:@"控油"]){
        
        notificationId = 194;
    }else if([catName isEqualToString:@"补水"]){
        
        notificationId = 195;
    }else if([catName isEqualToString:@"去黑头"]){
        
        notificationId = 196;
    }else if([catName isEqualToString:@"收毛孔"]){
        
        notificationId = 197;
    }else if([catName isEqualToString:@"去眼袋"]){
        
        notificationId = 198;
    }
    
    else if([catName isEqualToString:@"防晒霜"]){
        
        notificationId = 199;
    }else if([catName isEqualToString:@"喷雾"]){
        
        notificationId = 200;
    }else if([catName isEqualToString:@"卸妆油"]){
        
        notificationId = 201;
    }else if([catName isEqualToString:@"洗面奶"]){
        
        notificationId = 202;
    }else if([catName isEqualToString:@"面膜"]){
        
        notificationId = 203;
    }else if([catName isEqualToString:@"眼霜"]){
        
        notificationId = 204;
    }else if([catName isEqualToString:@"化妆水"]){
        
        notificationId = 205;
    }else if([catName isEqualToString:@"面霜"]){
        
        notificationId = 206;
    }else if([catName isEqualToString:@"隔离霜"]){
        
        notificationId = 207;
    }else if([catName isEqualToString:@"吸油面纸"]){
        
        notificationId = 208;
    }else if([catName isEqualToString:@"药妆"]){
        
        notificationId = 209;
    }
    
    else if([catName isEqualToString:@"香水"]){
        
        notificationId = 210;
    }else if([catName isEqualToString:@"指甲油"]){
        
        notificationId = 211;
    }else if([catName isEqualToString:@"睫毛膏"]){
        
        notificationId = 212;
    }else if([catName isEqualToString:@"BB霜"]){
        
        notificationId = 213;
    }else if([catName isEqualToString:@"粉饼"]){
        
        notificationId = 214;
    }else if([catName isEqualToString:@"蜜粉"]){
        
        notificationId = 215;
    }else if([catName isEqualToString:@"口红"]){
        
        notificationId = 216;
    }else if([catName isEqualToString:@"腮红"]){
        
        notificationId = 217;
    }else if([catName isEqualToString:@"眼影"]){
        
        notificationId = 218;
    }else if([catName isEqualToString:@"眉笔"]){
        
        notificationId = 219;
    }else if([catName isEqualToString:@"唇彩"]){
        
        notificationId = 220;
    }else if([catName isEqualToString:@"眼线膏"]){
        
        notificationId = 221;
    }
    
    else if([catName isEqualToString:@"手工皂"]){
        
        notificationId = 222;
    }else if([catName isEqualToString:@"沐浴露"]){
        
        notificationId = 223;
    }else if([catName isEqualToString:@"美颈霜"]){
        
        notificationId = 224;
    }else if([catName isEqualToString:@"身体乳"]){
        
        notificationId = 225;
    }else if([catName isEqualToString:@"护手霜"]){
        
        notificationId = 226;
    }else if([catName isEqualToString:@"假发"]){
        
        notificationId = 227;
    }else if([catName isEqualToString:@"发蜡"]){
        
        notificationId = 228;
    }else if([catName isEqualToString:@"弹力素"]){
        
        notificationId = 229;
    }else if([catName isEqualToString:@"发膜"]){
        
        notificationId = 230;
    }else if([catName isEqualToString:@"蓬蓬粉"]){
        
        notificationId = 231;
    }else if([catName isEqualToString:@"染发膏"]){
        
        notificationId = 232;
    }
    
    return notificationId;
}

@end
