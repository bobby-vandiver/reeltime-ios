#import <Foundation/Foundation.h>

@protocol RTAccountRegistrationView;
@class RTAccountRegistrationInteractor;
@class RTAccountRegistrationWireframe;

@interface RTAccountRegistrationPresenter : NSObject

- (instancetype)initWithView:(id<RTAccountRegistrationView>)view
                  interactor:(RTAccountRegistrationInteractor *)interactor
                   wireframe:(RTAccountRegistrationWireframe *)wireframe;

- (void)requestedAccountRegistrationWithUsername:(NSString *)username
                                        password:(NSString *)password
                            confirmationPassword:(NSString *)confirmationPassword
                                           email:(NSString *)email
                                     displayName:(NSString *)displayName
                                      clientName:(NSString *)clientName;

- (void)registrationSucceeded;

- (void)registrationFailedWithError:(NSError *)error;

@end
