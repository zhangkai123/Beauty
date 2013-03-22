//
//  Product.h
//  MuyingYongpin
//
//  Created by kai zhang on 8/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property(nonatomic,copy) NSString * num_id;
@property(nonatomic,copy) NSString * title;
@property(nonatomic,copy) NSString *pic_url;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *click_url;
@property(nonatomic,copy) NSString *seller_credit_score;
@property(nonatomic,assign) BOOL collect;

@property(nonatomic,copy) NSString *description;
@property(nonatomic,retain) NSArray *imagesArray;
@end
