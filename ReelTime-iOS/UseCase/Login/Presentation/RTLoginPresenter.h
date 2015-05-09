#import <Foundation/Foundation.h>
#import "RTLoginInteractorDelegate.h"

@protocol RTLoginView;
@class RTLoginInteractor;
@class RTLoginWireframe;

@interface RTLoginPresenter : NSObject <RTLoginInteractorDelegate>

- (instancetype)initWithView:(id<RTLoginView>)view
                  interactor:(RTLoginInteractor *)interactor
                   wireframe:(RTLoginWireframe *)wireframe;

- (void)requestedLoginWithUsername:(NSString *)username
                           password:(NSString *)password;

- (void)requestedDeviceRegistration;

- (void)requestedAccountRegistration;

@end
