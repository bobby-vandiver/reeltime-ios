#import <Foundation/Foundation.h>

@class RTNewsfeed;

@protocol RTNewsfeedInteractorDelegate <NSObject>

- (void)retrievedNewsfeed:(RTNewsfeed *)newsfeed;

- (void)failedToRetrieveNewsfeedWithError:(NSError *)error;

@end
