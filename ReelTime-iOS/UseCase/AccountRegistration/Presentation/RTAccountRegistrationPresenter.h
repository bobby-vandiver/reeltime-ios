#import <Foundation/Foundation.h>

#import "RTAccountRegistrationInteractorDelegate.h"
#import "RTLoginInteractorDelegate.h"

@protocol RTAccountRegistrationView;

@class RTAccountRegistrationInteractor;
@class RTAccountRegistrationWireframe;
@class RTAccountRegistrationAutoLoginPresenter;

@interface RTAccountRegistrationPresenter : NSObject <RTAccountRegistrationInteractorDelegate, RTLoginInteractorDelegate>

- (instancetype)initWithView:(id<RTAccountRegistrationView>)view
                  interactor:(RTAccountRegistrationInteractor *)interactor
                   wireframe:(RTAccountRegistrationWireframe *)wireframe;

- (void)requestedAccountRegistrationWithUsername:(NSString *)username
                                        password:(NSString *)password
                            confirmationPassword:(NSString *)confirmationPassword
                                           email:(NSString *)email
                                     displayName:(NSString *)displayName
                                      clientName:(NSString *)clientName;

@end
