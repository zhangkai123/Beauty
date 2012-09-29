//
//  Product.m
//  MuyingYongpin
//
//  Created by kai zhang on 8/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Product.h"

@implementation Product
@synthesize num_iid,title,nick,pic_url,price,click_url,commission,commission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume;

-(void)dealloc
{
    [num_iid release];
    [title release];
    [nick release];
    [pic_url release];
    [price release];
    [click_url release];
    [commission release];
    [commission_rate release];
    [commission_num release];
    [commission_volume release];
    [shop_click_url release];
    [seller_credit_score release];
    [item_location release];
    [volume release];
    [super dealloc];
}

@end
