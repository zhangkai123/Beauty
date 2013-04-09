//
//  Utility.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "Utility.h"


@implementation Utility

+(NSString *)createMD5:(NSString *)signString
{
    const char*cStr =[signString UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return[NSString stringWithFormat:
           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
           result[0], result[1], result[2], result[3],
           result[4], result[5], result[6], result[7],
           result[8], result[9], result[10], result[11],
           result[12], result[13], result[14], result[15]
           ];
}

+(NSString *)createSign:(NSMutableDictionary *)params
{
    NSArray *keys=[params allKeys];
    keys=[keys sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *signData=[[NSString alloc] init];
    signData=[signData stringByAppendingFormat:APP_SECRET];
    for(NSString *key in keys)
    {
        signData=[signData stringByAppendingFormat:@"%@%@",key,[params objectForKey:key]];
    }
    signData=[signData stringByAppendingFormat:APP_SECRET];
    return [self createMD5:signData];
}

+(NSString *)createPostURL:(NSMutableDictionary *)params
{
    NSString *postString=@"";
    for(NSString *key in [params allKeys])
    {
        NSString *value=[params objectForKey:key];
        postString=[postString stringByAppendingFormat:@"%@=%@&",key,value];
    }
    if([postString length]>1)
    {
        postString=[postString substringToIndex:[postString length]-1];
    }
    return postString;
}

+(NSString *)getCurrentDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+(NSMutableURLRequest *)getResultData:(NSMutableDictionary *)params
{
    [params setObject:APP_KEY forKey:@"app_key"];
    [params setObject:@"json" forKey:@"format"];
    [params setObject:@"md5" forKey:@"sign_method"];
    [params setObject:[Utility getCurrentDate] forKey:@"timestamp"];
    [params setObject:@"2.0" forKey:@"v"];
    [params setObject:[Utility createSign:params] forKey:@"sign"];
    
    NSString *postURL=[Utility createPostURL:params];
    NSLog(@"%@",postURL);
//    NSError *error;
//    NSURLResponse *theResponse;
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:BASEURL]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[postURL dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    return [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
    return theRequest;
}

@end
