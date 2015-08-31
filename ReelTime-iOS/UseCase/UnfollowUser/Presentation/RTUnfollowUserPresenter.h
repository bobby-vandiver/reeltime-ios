#import <Foundation/Foundation.h>

#import "RTUnfollowUserInteractorDelegate.h"
#import "RTErrorCodeToErrorMessagePresenterDelelgate.h"

@protocol RTUnfollowUserView;
@class RTUnfollowUserInteractor;

@interface RTUnfollowUserPresenter : NSObject <RTUnfollowUserInteractorDelegate, RTErrorCodeToErrorMessagePresenterDelelgate>

- (instancetype)initWithView:(id<RTUnfollowUserView>)view
                  interactor:(RTUnfollowUserInteractor *)interactor;

- (void)requestedUserUnfollowingForUsername:(NSString *)username;

@end
