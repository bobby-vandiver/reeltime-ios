#import <Foundation/Foundation.h>
#import "RTUnfollowUserInteractorDelegate.h"

@protocol RTUnfollowUserView;
@class RTUnfollowUserInteractor;

@interface RTUnfollowUserPresenter : NSObject <RTUnfollowUserInteractorDelegate>

- (instancetype)initWithView:(id<RTUnfollowUserView>)view
                  interactor:(RTUnfollowUserInteractor *)interactor;

- (void)requestedUserUnfollowingForUsername:(NSString *)username;

@end
