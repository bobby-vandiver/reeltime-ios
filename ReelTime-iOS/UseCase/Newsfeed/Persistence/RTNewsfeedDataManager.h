#import <Foundation/Foundation.h>

@class RTClient;
@class RTNewsfeed;

@interface RTNewsfeedDataManager : NSObject

- (instancetype)initWithClient:(RTClient *)client;

- (void)retrieveNewsfeedPage:(NSUInteger)page
                    callback:(void (^)(RTNewsfeed *newsfeed))callback;

@end
