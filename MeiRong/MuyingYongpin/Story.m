//
//  Story.m
//  TaoZhuang
//
//  Created by zhang kai on 3/26/13.
//
//

#import "Story.h"

@implementation Story
@synthesize title = _title ,imagePath = _imagePath, article = _article, keyWord = _keyWord;

-(void)dealloc
{
    [_title release];
    [_imagePath release];
    [_article release];
    [_keyWord release];
    [super dealloc];
}

-(id)initWithStory:(NSString *)tit imagePath:(NSString *)imageP article:(NSString *)art keyWord:(NSString *)kWord
{
    if (self = [super init]) {
        
        self.title = tit;
        self.imagePath = imageP;
        self.article = art;
        self.keyWord = kWord;
    }
    return self;
}
-(NSString *)imagePath
{
    NSString *imgPath = [NSString stringWithFormat:@"http://42.121.193.105/PinPHP_V2.21/data/news/%@",_imagePath];
    return imgPath;
}
@end
