//
//  Product.h
//  MuyingYongpin
//
//  Created by kai zhang on 8/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

//@property(nonatomic,copy) NSString *num_iid;
@property(nonatomic,copy) NSString * title;
//@property(nonatomic,copy) NSString * nick;
@property(nonatomic,copy) NSString *pic_url;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *likes;
@property(nonatomic,copy) NSString *click_url;
//@property(nonatomic,copy) NSString *commission;
//@property(nonatomic,copy) NSString *commission_rate;
//@property(nonatomic,copy) NSString *commission_num;
//@property(nonatomic,copy) NSString *commission_volume;
//@property(nonatomic,copy) NSString *shop_click_url;
//@property(nonatomic,copy) NSString *seller_credit_score;
//@property(nonatomic,copy) NSString *item_location;
//@property(nonatomic,copy) NSString *volume;
@property(nonatomic,assign) BOOL collect;
@end
