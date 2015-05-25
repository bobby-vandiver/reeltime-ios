#import <Foundation/Foundation.h>

#import "RTChangePasswordInteractorDelegate.h"
#import "RTErrorCodeToErrorMessagePresenterDelelgate.h"

@protocol RTChangePasswordView;
@class RTChangePasswordInteractor;
@class RTChangePasswordWireframe;

@interface RTChangePasswordPresenter : NSObject <RTChangePasswordInteractorDelegate, RTErrorCodeToErrorMessagePresenterDelelgate>

- (instancetype)initWithView:(id<RTChangePasswordView>)view
                  interactor:(RTChangePasswordInteractor *)interactor
                   wireframe:(RTChangePasswordWireframe *)wireframe;

- (void)requestedPasswordChangeWithPassword:(NSString *)password
                       confirmationPassword:(NSString *)confirmationPassword;

@end
