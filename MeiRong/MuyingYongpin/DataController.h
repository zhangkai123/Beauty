//
//  DataController.h
//  MuyingYongpin
//
//  Created by kai zhang on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataController : NSObject
{
    NSMutableArray *productsArray;
}
+(id)sharedDataController;
-(void)fetachHotProducts:(int)pageN;
-(void)fetachCateProducts:(NSString *)cateName notiName:(NSString *)nName pageNumber:(int)pageN;
-(void)parseProductsData:(NSData *)data;

-(void)featchRssData;
-(void)parseRssData:(NSData *)data;

@property(nonatomic,strong) NSMutableArray *productsArray;
@end
