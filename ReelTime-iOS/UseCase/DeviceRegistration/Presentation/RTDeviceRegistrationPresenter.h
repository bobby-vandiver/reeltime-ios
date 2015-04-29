#import <Foundation/Foundation.h>
#import "RTDeviceRegistrationInteractorDelegate.h"

@protocol RTDeviceRegistrationView;
@class RTDeviceRegistrationInteractor;
@class RTDeviceRegistrationWireframe;

@interface RTDeviceRegistrationPresenter : NSObject <RTDeviceRegistrationInteractorDelegate>

- (instancetype)initWithView:(id<RTDeviceRegistrationView>)view
                  interactor:(RTDeviceRegistrationInteractor *)interactor
                   wireframe:(RTDeviceRegistrationWireframe *)wireframe;

- (void)requestedDeviceRegistrationWithClientName:(NSString *)clientName
                                         username:(NSString *)username
                                         password:(NSString *)password;

@end
