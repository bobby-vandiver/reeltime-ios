#import <Foundation/Foundation.h>
#import "RTFollowUserInteractorDelegate.h"

@protocol RTFollowUserView;
@class RTFollowUserInteractor;

@interface RTFollowUserPresenter : NSObject <RTFollowUserInteractorDelegate>

- (instancetype)initWithView:(id<RTFollowUserView>)view
                  interactor:(RTFollowUserInteractor *)interactor;

- (void)requestedUserFollowingForUsername:(NSString *)username;

@end
