//
//  DataController.m
//  MuyingYongpin
//
//  Created by kai zhang on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataController.h"
#import "Utility.h"
#import "SBJson.h"
#import "Product.h"
#import "DDXML.h"
#import "FashionNews.h"

@implementation DataController
@synthesize productsArray;

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
        productsArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)fetachHotProducts:(int)pageN
{
    if (pageN == 0) {
        return;
    }
    if (productsArray != nil) {
//        [productsArray removeAllObjects];
        [productsArray release];
        productsArray = [[NSMutableArray alloc]init];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        [params setObject:@"num_iid,title,nick,pic_url,price,click_url,commission,commission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume" forKey:@"fields"];
        [params setObject:@"50010788" forKey:@"cid"];
        [params setObject:@"taobao.taobaoke.items.get" forKey:@"method"];
        [params setObject:@"32217399" forKey:@"pid"];
        [params setObject:[NSString stringWithFormat:@"%d",pageN] forKey:@"page_no"];
        [params setObject:@"20" forKey:@"page_size"];
        [params setObject:@"5goldencrown" forKey:@"start_credit"];
        [params setObject:@"100" forKey:@"start_price"];
        [params setObject:@"2000" forKey:@"end_price"];
        [params setObject:@"commissionNum_desc" forKey:@"sort"];
        [params setObject:@"true" forKey:@"overseas_item"];
        [params setObject:@"true" forKey:@"mall_item"];
        [params setObject:@"true" forKey:@"is_mobile"];
        
        NSData *resultData=[Utility getResultData:params];
        [params release];
        [self parseProductsData:resultData];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"HOT_PRODUCTS_REARDY" object:nil userInfo:nil];
    });
}
-(void)fetachCateProducts:(NSString *)cateName notiName:(NSString *)nName pageNumber:(int)pageN
{
    if (pageN == 0) {
        return;
    }
    if (productsArray != nil) {
//        [productsArray removeAllObjects];
        [productsArray release];
        productsArray = [[NSMutableArray alloc]init];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        [params setObject:@"num_iid,title,nick,pic_url,price,click_url,commission,commission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume" forKey:@"fields"];
        [params setObject:@"50010788" forKey:@"cid"];
        [params setObject:@"taobao.taobaoke.items.get" forKey:@"method"];
        [params setObject:@"32217399" forKey:@"pid"];
        [params setObject:[NSString stringWithFormat:@"%d",pageN] forKey:@"page_no"];
        [params setObject:@"20" forKey:@"page_size"];
        [params setObject:@"commissionNum_desc" forKey:@"sort"];
        //    [params setObject:@"true" forKey:@"overseas_item"];
        [params setObject:cateName forKey:@"keyword"];
        [params setObject:@"true" forKey:@"mall_item"];
        [params setObject:@"true" forKey:@"is_mobile"];
        
        NSData *resultData=[Utility getResultData:params];
        [params release];
        [self parseProductsData:resultData];
        [[NSNotificationCenter defaultCenter]postNotificationName:nName object:nil userInfo:nil];
    });
}
-(void)parseProductsData:(NSData *)data
{
    NSString *productsString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *productsDic = [productsString JSONValue];
    NSLog(@"---%@---\n",productsString);
    [productsString release];
    NSDictionary *taobaoke_items_get_response = [productsDic objectForKey:@"taobaoke_items_get_response"];
    NSDictionary *taobaoke_items = [taobaoke_items_get_response objectForKey:@"taobaoke_items"];
    
    NSArray *taobaoke_item = [taobaoke_items objectForKey:@"taobaoke_item"];
        
    for (int i = 0; i < [taobaoke_item count]; i++) {
        
        NSDictionary *item = [taobaoke_item objectAtIndex:i];
        Product *product = [[Product alloc]init];
        product.title = [item objectForKey:@"title"];
        product.title = [self stringCleaner:product.title];
        product.pic_url = [item objectForKey:@"pic_url"];
        product.click_url = [item objectForKey:@"click_url"];
        [productsArray addObject:product];
        [product release];
    }
}
-(void)featchRssData
{
    if (productsArray != nil) {
        //[productsArray removeAllObjects];
        [productsArray release];
        productsArray = [[NSMutableArray alloc]init];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *postURL = @"http://rss.sina.com.cn/eladies/gnspxw.xml";
        NSError *error;
        NSURLResponse *theResponse;
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:postURL]];
        NSData *xmlData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
//        NSString *xmlString = [[NSString alloc]initWithData:xmlData encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",xmlString);
        [self parseRssData:xmlData];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NEWS_READY" object:nil userInfo:nil];
    });
}
-(void)parseRssData:(NSData *)data
{
    NSError *error;
    DDXMLDocument *ddDoc = [[DDXMLDocument alloc] initWithData:data options:0 error:&error];
    NSArray *xmlItems = [ddDoc nodesForXPath:@"//item" error:&error];
//    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:[xmlItems count]];
    
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
            [productsArray addObject:fashionNews];
        }
        [fashionNews release];
    }
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
@end
