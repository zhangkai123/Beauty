//
//  FashionNews.m
//  MuyingYongpin
//
//  Created by zhang kai on 9/24/12.
//
//

#import "FashionNews.h"

@implementation FashionNews
@synthesize title ,pubDate ,link ,author ,description;

-(void)dealloc
{
    [title release];
    [link release];
    [author release];
    [description release];
    [pubDate release];
    [super dealloc];
}
@end
