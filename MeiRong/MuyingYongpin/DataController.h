//
//  DataController.h
//  MuyingYongpin
//
//  Created by kai zhang on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataController : NSObject


+(id)sharedDataController;
-(void)fetachHotProducts:(int)pageN;
-(void)fetachCateProducts:(NSString *)cateName notiName:(NSString *)nName pageNumber:(int)pageN;
-(NSMutableArray *)parseProductsData:(NSData *)data;

-(void)featchRssData;
-(NSMutableArray *)parseRssData:(NSData *)data;

@end
