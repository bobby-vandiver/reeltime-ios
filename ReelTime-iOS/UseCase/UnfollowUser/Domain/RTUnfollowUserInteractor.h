#import <Foundation/Foundation.h>

@protocol RTUnfollowUserInteractorDelegate;
@class RTUnfollowUserDataManager;

@interface RTUnfollowUserInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTUnfollowUserInteractorDelegate>)delegate
                     dataManager:(RTUnfollowUserDataManager *)dataManager;

- (void)unfollowUserWithUsername:(NSString *)username;

@end
