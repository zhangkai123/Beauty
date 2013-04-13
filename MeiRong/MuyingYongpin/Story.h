//
//  Story.h
//  TaoZhuang
//
//  Created by zhang kai on 3/26/13.
//
//

#import <Foundation/Foundation.h>

@interface Story : NSObject

@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *imagePath;
@property(nonatomic,retain) NSString *article;
@property(nonatomic,retain) NSString *keyWord;
@property(nonatomic,retain) NSString *categoryId;

-(id)initWithStory:(NSString *)tit imagePath:(NSString *)imageP article:(NSString *)art keyWord:(NSString *)kWord categoryId:(NSString *)cId;
@end
