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
        
        NSError *error;
        NSURLResponse *theResponse;
        NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.107/~zhangkai/PinPHP_V2.21/fetchProducts.php"]];
        [theRequest setHTTPMethod:@"POST"];
        NSString *postString = [NSString stringWithFormat:@"catId=434&pageNumber=%d",pageN];  
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
                
        int catId = [self getNotificationId:cateName];
        
        NSError *error;
        NSURLResponse *theResponse;
        NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.107/~zhangkai/PinPHP_V2.21/fetchProducts.php"]];
        [theRequest setHTTPMethod:@"POST"];
        NSString *postString = [NSString stringWithFormat:@"catId=%d&pageNumber=%d",catId,pageN];
        [theRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSData *resultData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
        NSMutableArray *pArray = [self parseProductsData:resultData];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:nName object:pArray userInfo:nil];
    });
}
-(NSMutableArray *)parseProductsData:(NSData *)data
{
    NSString *productsString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSDictionary *productsDic = [productsString JSONValue];

    NSArray *productArray = [productsString JSONValue];
    
    NSLog(@"---%@---\n",productsString);
    [productsString release];
    
    NSMutableArray *pArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [productArray count]; i++) {
        NSDictionary *item = [productArray objectAtIndex:i];
        
        Product *product = [[Product alloc]init];
        product.title = [item objectForKey:@"title"];
        product.pic_url = [item objectForKey:@"bimg"];
        product.click_url = [item objectForKey:@"url"];
        NSLog(@"%@",product.click_url);
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

@end
