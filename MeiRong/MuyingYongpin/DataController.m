//
//  DataController.m
//  MuyingYongpin
//
//  Created by kai zhang on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import "DataController.h"
#import "SBJson.h"
#import "DDXML.h"
#import "FashionNews.h"
#import "ReachableManager.h"
#import "Utility.h"
#import "Story.h"

#define ServerIp @"http://42.121.193.105"
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
-(void)featchStories:(int)pageNum
{
    if (![[ReachableManager sharedReachableManager]reachable]) {
        [self performSelector:@selector(showNoNetwork) withObject:nil afterDelay:1.0];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error;
        NSURLResponse *theResponse;
        NSString *urlString = [NSString stringWithFormat:@"%@/PinPHP_V2.21/fetchTopics.php",ServerIp];
        NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [theRequest setHTTPMethod:@"POST"];
        NSString *postString = [NSString stringWithFormat:@"pageNumber=%d",pageNum];
        [theRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSData *resultData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
        
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
            NSMutableArray *pArray = [self parseStoryData:resultData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Story_Ready" object:pArray userInfo:nil];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    });
}
-(NSMutableArray *)parseStoryData:(NSData *)data
{
    NSString *productsString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *storyArray = [productsString JSONValue];
    
    NSLog(@"---%@---\n",productsString);
    [productsString release];
    
    NSMutableArray *pArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [storyArray count]; i++) {
        NSDictionary *item = [storyArray objectAtIndex:i];
        
        NSString *title = [item objectForKey:@"title"];
        NSString *img = [item objectForKey:@"img"];
        NSString *article = [item objectForKey:@"abst"];
        NSString *keyWord = [item objectForKey:@"url"];
        
        Story *story = [[Story alloc]initWithStory:title imagePath:img article:article keyWord:keyWord];
        [pArray addObject:story];
        [story release];
    }
    return [pArray autorelease];
}
-(void)featchTopicProducts:(NSString *)keyWord pageNumber:(int)pageN
{
    if (![[ReachableManager sharedReachableManager]reachable]) {
        [self performSelector:@selector(showNoNetwork) withObject:nil afterDelay:1.0];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error;
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        [params setObject:@"num_iid,title,pic_url,price,seller_credit_score,click_url" forKey:@"fields"];
        [params setObject:@"50010788" forKey:@"cid"];
        [params setObject:@"taobao.taobaoke.items.get" forKey:@"method"];
        [params setObject:[NSString stringWithFormat:@"%d",pageN] forKey:@"page_no"];
        [params setObject:@"20" forKey:@"page_size"];
        [params setObject:@"30" forKey:@"start_price"];
        [params setObject:@"2000" forKey:@"end_price"];
        [params setObject:@"commissionNum_desc" forKey:@"sort"];
        [params setObject:keyWord forKey:@"keyword"];
        [params setObject:@"true" forKey:@"is_mobile"];
        
        NSData *resultData=[Utility getResultData:params];
        [params release];
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
            NSMutableArray *pArray = [self parseStoryProductsData:resultData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"TOPIC_PRODUCT" object:pArray userInfo:nil];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    });
}
-(NSMutableArray *)parseStoryProductsData:(NSData *)data
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
        product.num_id = [NSString stringWithFormat:@"%@",[item objectForKey:@"num_iid"]];
        product.title = [self stringCleaner:[item objectForKey:@"title"]];
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
-(void)fetachCateProducts:(NSString *)cateName notiName:(NSString *)nName pageNumber:(int)pageN
{
    if (![[ReachableManager sharedReachableManager]reachable]) {
        [self performSelector:@selector(showNoNetwork) withObject:nil afterDelay:1.0];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
        int catId = [self getServerNotificationId:cateName];
        
        NSError *error;
        NSURLResponse *theResponse;
        NSString *urlString = [NSString stringWithFormat:@"%@/PinPHP_V2.21/fetchProducts.php",ServerIp];
        NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [theRequest setHTTPMethod:@"POST"];
        NSString *postString = [NSString stringWithFormat:@"catId=%d&pageNumber=%d",catId,pageN];
        [theRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSData *resultData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
        
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
-(NSMutableArray *)parseProductsData:(NSData *)data
{
    NSString *productsString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *productArray = [productsString JSONValue];
    
    NSLog(@"---%@---\n",productsString);
    [productsString release];
    
    NSMutableArray *pArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [productArray count]; i++) {
        NSDictionary *item = [productArray objectAtIndex:i];
        
        Product *product = [[Product alloc]init];
        NSString *item_key = [item objectForKey:@"item_key"];
        NSArray *num_id_array = [item_key componentsSeparatedByString:@"_"];
        if ([num_id_array count] > 0) {
            product.num_id = [num_id_array objectAtIndex:1];
        }
        product.title = [item objectForKey:@"title"];
        product.price = [item objectForKey:@"price"];
        product.seller_credit_score = [item objectForKey:@"likes"];
        product.pic_url = [item objectForKey:@"bimg"];
        product.click_url = [item objectForKey:@"url"];
        NSLog(@"%@",product.click_url);
        [pArray addObject:product];
        [product release];
    }
    return [pArray autorelease];
}

-(void)featchProductDetail:(NSString *)num_id theProduct:(Product *)pro
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"taobao.item.get" forKey:@"method"];
        [params setObject:@"item_img.url,prop_img.url" forKey:@"fields"];
        [params setObject:num_id forKey:@"num_iid"];
        
        NSData *resultData=[Utility getResultData:params];
        [params release];
        [self parseProductDetailData:resultData theProduct:pro];
    });
}
-(void)parseProductDetailData:(NSData *)data theProduct:(Product *)pro
{
    NSString *productsString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *productsDic = [productsString JSONValue];
//        NSLog(@"---%@---\n",productsString);
    [productsString release];
    NSDictionary *items_get_response = [productsDic objectForKey:@"item_get_response"];
    NSDictionary *item = [items_get_response objectForKey:@"item"];
    
    NSDictionary *item_imgs = [item objectForKey:@"item_imgs"];
    NSArray *item_img = [item_imgs objectForKey:@"item_img"];
    
    NSDictionary *prop_imgs = [item objectForKey:@"prop_imgs"];
    NSArray *prop_img = [prop_imgs objectForKey:@"prop_img"];
    
    NSMutableArray *imageDicArray = [[NSMutableArray alloc]init];
    for (NSDictionary *imageDic in item_img) {
        NSString *imageUrlStr = [imageDic objectForKey:@"url"];
        float imageHeight = [self parseImageHeight:imageUrlStr];
        NSDictionary *imageDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",imageHeight],@"imageHeight",imageUrlStr,@"imageUrl", nil];
        [imageDicArray addObject:imageDic];
    }
    for (NSDictionary *imageDic in prop_img) {
        NSString *imageUrlStr = [imageDic objectForKey:@"url"];
        float imageHeight = [self parseImageHeight:imageUrlStr];
        NSDictionary *imageDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",imageHeight],@"imageHeight",imageUrlStr,@"imageUrl", nil];
        [imageDicArray addObject:imageDic];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        pro.imagesArray = imageDicArray;
        [imageDicArray release];
    });
}
-(float)parseImageHeight:(NSString *)urlStr
{
    NSURL *imageUrl = [NSURL URLWithString:urlStr];
    
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)imageUrl, NULL);
    if (imageSourceRef == NULL) {
        return 0;
    }
    CFDictionaryRef props = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
    CFRelease(imageSourceRef);
    NSNumber *width;
    NSNumber *height;
    if (props) {
        width = [(NSNumber *)CFDictionaryGetValue(props, kCGImagePropertyPixelWidth) retain];
        height = [(NSNumber *)CFDictionaryGetValue(props, kCGImagePropertyPixelHeight) retain];
    }
    CFRelease(props);
    float imageHeight = [height intValue] * 320 / [width intValue];
    [width release];
    [height release];
    return imageHeight;
}
-(void)featchVersionNum:(BOOL)automatic
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *postURL = @"http://42.121.193.105/version.txt";
        NSError *error;
        NSURLResponse *theResponse;
//        NSURLRequest *theRequest=[[[NSURLRequest requestWithURL:[NSURL URLWithString:postURL]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0]];
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:postURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
        NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
        /* Return Value
         The downloaded data for the URL request. Returns nil if a connection could not be created or if the download fails.
         */
        if (returnData == nil) {
            
            // Check for problems
            if (error != nil) {
                [self showAlert:[error description]];
            }else{
                [self showAlert:@"返回数据为空"];
            }
        }
        else {
            // Data was received.. continue processing
            
            NSString *returnString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:automatic],@"Automatic",returnString,@"VersionNum", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"VERSION_READY" object:infoDic userInfo:nil];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    });
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
-(int)getServerNotificationId:(NSString *)catName
{
    int notificationId;
    if ([catName isEqualToString:@"热销"]) {
        notificationId = 413;
    }else if ([catName isEqualToString:@"美白"]) {
        
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
