#import <Foundation/Foundation.h>

#import "RTFollowUserInteractorDelegate.h"
#import "RTErrorCodeToErrorMessagePresenterDelelgate.h"

@protocol RTFollowUserView;
@class RTFollowUserInteractor;

@interface RTFollowUserPresenter : NSObject <RTFollowUserInteractorDelegate, RTErrorCodeToErrorMessagePresenterDelelgate>

- (instancetype)initWithView:(id<RTFollowUserView>)view
                  interactor:(RTFollowUserInteractor *)interactor;

- (void)requestedUserFollowingForUsername:(NSString *)username;

@end
