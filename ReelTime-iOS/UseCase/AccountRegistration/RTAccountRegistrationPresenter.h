#import <Foundation/Foundation.h>

#import "RTAccountRegistrationInteractorDelegate.h"

@protocol RTAccountRegistrationView;
@class RTAccountRegistrationInteractor;
@class RTAccountRegistrationWireframe;

@interface RTAccountRegistrationPresenter : NSObject <RTAccountRegistrationInteractorDelegate>

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
