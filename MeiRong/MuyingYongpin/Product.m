//
//  Product.m
//  MuyingYongpin
//
//  Created by kai zhang on 8/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Product.h"

@implementation Product
@synthesize num_id,title,pic_url,price,click_url,seller_credit_score ,collect;
@synthesize description ,imagesArray;
-(void)dealloc
{
    [num_id release];
    [title release];
    [pic_url release];
    [price release];
    [click_url release];
    [seller_credit_score release];
    
    [description release];
    [imagesArray release];
    [super dealloc];
}

@end
