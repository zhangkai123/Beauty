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
-(void)fetachCateProducts:(NSString *)cateName cateId:(NSString *)cId pageNumber:(int)pageN;
-(void)featchProductDetail:(NSString *)num_id theProduct:(Product *)pro;
-(NSMutableArray *)parseProductsData:(NSData *)data;

-(void)featchStories:(int)pageNum;
-(void)featchKeywordProducts:(NSString *)keyWord pageNumber:(int)pageN;

-(void)featchVersionNum:(BOOL)automatic;
@end
