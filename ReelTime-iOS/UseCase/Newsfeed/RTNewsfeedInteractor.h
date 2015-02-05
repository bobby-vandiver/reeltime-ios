#import <Foundation/Foundation.h>

@protocol RTNewsfeedInteractorDelegate;
@class RTNewsfeedDataManager;

@interface RTNewsfeedInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTNewsfeedInteractorDelegate>)delegate
                     dataManager:(RTNewsfeedDataManager *)dataManager;

- (void)newsfeedPage:(NSUInteger)page;

@end
