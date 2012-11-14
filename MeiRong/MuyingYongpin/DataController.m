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

-(void)fetachHotProducts:(int)pageN
{
    if (pageN == 0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//        
//        [params setObject:@"title,pic_url,click_url" forKey:@"fields"];
//        [params setObject:@"50010788" forKey:@"cid"];
//        [params setObject:@"taobao.taobaoke.items.get" forKey:@"method"];
//        [params setObject:@"32217399" forKey:@"pid"];
//        [params setObject:[NSString stringWithFormat:@"%d",pageN] forKey:@"page_no"];
//        [params setObject:@"20" forKey:@"page_size"];
//        [params setObject:@"5goldencrown" forKey:@"start_credit"];
//        [params setObject:@"100" forKey:@"start_price"];
//        [params setObject:@"2000" forKey:@"end_price"];
//        [params setObject:@"commissionNum_desc" forKey:@"sort"];
//        [params setObject:@"true" forKey:@"overseas_item"];
//        [params setObject:@"true" forKey:@"mall_item"];
//        [params setObject:@"true" forKey:@"is_mobile"];
//        
//        NSData *resultData=[Utility getResultData:params];
//        [params release];
//        NSMutableArray *pArray = [self parseProductsData:resultData];
        
        NSError *error;
        NSURLResponse *theResponse;
        NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.105/~zhangkai/PinPHP_V2.21/fetchProducts.php"]];
        [theRequest setHTTPMethod:@"POST"];
        NSString *postString = @"&catId=432";
        [theRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSData *resultData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
        NSMutableArray *pArray = [self parseProductsData:resultData];

        [[NSNotificationCenter defaultCenter]postNotificationName:@"HOT_PRODUCTS_REARDY" object:pArray userInfo:nil];
    });
}
-(void)fetachCateProducts:(NSString *)cateName notiName:(NSString *)nName pageNumber:(int)pageN
{
    if (pageN == 0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        [params setObject:@"title,pic_url,click_url" forKey:@"fields"];
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
        NSMutableArray *pArray = [self parseProductsData:resultData];
        [[NSNotificationCenter defaultCenter]postNotificationName:nName object:pArray userInfo:nil];
    });
}
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
        product.title = [self stringCleaner:product.title];
        product.pic_url = [item objectForKey:@"pic_url"];
        product.click_url = [item objectForKey:@"click_url"];
        //thread not save
        [pArray addObject:product];
        [product release];
    }
    return [pArray autorelease];
}


//send the rss request
-(void)featchRssData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *postURL = @"http://rss.sina.com.cn/eladies/gnspxw.xml";
        NSError *error;
        NSURLResponse *theResponse;
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:postURL]];
        NSData *xmlData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
//        NSString *xmlString = [[NSString alloc]initWithData:xmlData encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",xmlString);
        NSMutableArray *newsArray = [self parseRssData:xmlData];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NEWS_READY" object:newsArray userInfo:nil];
    });
}
-(NSMutableArray *)parseRssData:(NSData *)data
{
    NSError *error;
    DDXMLDocument *ddDoc = [[DDXMLDocument alloc] initWithData:data options:0 error:&error];
    NSArray *xmlItems = [ddDoc nodesForXPath:@"//item" error:&error];
//    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:[xmlItems count]];
    
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
@end
