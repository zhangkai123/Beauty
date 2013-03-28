//
//  DataController.h
//  MuyingYongpin
//
//  Created by kai zhang on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface DataController : NSObject


+(id)sharedDataController;
-(void)fetachCateProducts:(NSString *)cateName notiName:(NSString *)nName pageNumber:(int)pageN;
-(void)featchProductDetail:(NSString *)num_id theProduct:(Product *)pro;
-(NSMutableArray *)parseProductsData:(NSData *)data;

-(void)featchRssData;
-(NSMutableArray *)parseRssData:(NSData *)data;

-(void)featchStories:(int)pageNum;
-(void)featchTopicProducts:(NSString *)keyWord pageNumber:(int)pageN;
@end
