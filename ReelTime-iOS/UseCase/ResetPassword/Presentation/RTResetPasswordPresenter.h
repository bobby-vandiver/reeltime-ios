#import <Foundation/Foundation.h>

#import "RTResetPasswordInteractorDelegate.h"
#import "RTErrorCodeToErrorMessagePresenterDelelgate.h"

@protocol RTResetPasswordView;
@class RTResetPasswordInteractor;
@class RTResetPasswordWireframe;

@interface RTResetPasswordPresenter : NSObject <RTResetPasswordInteractorDelegate, RTErrorCodeToErrorMessagePresenterDelelgate>

- (instancetype)initWithView:(id<RTResetPasswordView>)view
                  interactor:(RTResetPasswordInteractor *)interactor
                   wireframe:(RTResetPasswordWireframe *)wireframe;

- (void)requestedResetPasswordEmailForUsername:(NSString *)username;

- (void)requestedResetPasswordWithCode:(NSString *)code
                              username:(NSString *)username
                              password:(NSString *)password
                  confirmationPassword:(NSString *)confirmationPassword;

- (void)requestedResetPasswordWithCode:(NSString *)code
                              username:(NSString *)username
                              password:(NSString *)password
                  confirmationPassword:(NSString *)confirmationPassword
                            clientName:(NSString *)clientName;

@end
