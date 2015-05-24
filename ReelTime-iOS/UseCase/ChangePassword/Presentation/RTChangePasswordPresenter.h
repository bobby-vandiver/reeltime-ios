#import <Foundation/Foundation.h>
#import "RTChangePasswordInteractorDelegate.h"

@protocol RTChangePasswordView;
@class RTChangePasswordInteractor;
@class RTChangePasswordWireframe;

@interface RTChangePasswordPresenter : NSObject <RTChangePasswordInteractorDelegate>

- (instancetype)initWithView:(id<RTChangePasswordView>)view
                  interactor:(RTChangePasswordInteractor *)interactor
                   wireframe:(RTChangePasswordWireframe *)wireframe;

- (void)requestedPasswordChangeWithPassword:(NSString *)password
                       confirmationPassword:(NSString *)confirmationPassword;

@end
