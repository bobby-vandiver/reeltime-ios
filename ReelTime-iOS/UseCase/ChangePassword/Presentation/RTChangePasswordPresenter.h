#import <Foundation/Foundation.h>

#import "RTChangePasswordInteractorDelegate.h"
#import "RTErrorCodeToErrorMessagePresenterDelelgate.h"

@protocol RTChangePasswordView;
@class RTChangePasswordInteractor;

@interface RTChangePasswordPresenter : NSObject <RTChangePasswordInteractorDelegate, RTErrorCodeToErrorMessagePresenterDelelgate>

- (instancetype)initWithView:(id<RTChangePasswordView>)view
                  interactor:(RTChangePasswordInteractor *)interactor;

- (void)requestedPasswordChangeWithPassword:(NSString *)password
                       confirmationPassword:(NSString *)confirmationPassword;

@end
