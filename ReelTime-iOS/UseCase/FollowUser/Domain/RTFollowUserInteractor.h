#import <Foundation/Foundation.h>

@protocol RTFollowUserInteractorDelegate;
@class RTFollowUserDataManager;

@interface RTFollowUserInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTFollowUserInteractorDelegate>)delegate
                     dataManager:(RTFollowUserDataManager *)dataManager;

- (void)followUserWithUsername:(NSString *)username;

@end
