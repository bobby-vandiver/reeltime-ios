#import <Foundation/Foundation.h>

@class RTAccountSettingsWireframe;
@class RTLogoutPresenter;

@interface RTAccountSettingsPresenter : NSObject

- (instancetype)initWithWireframe:(RTAccountSettingsWireframe *)wireframe
                  logoutPresenter:(RTLogoutPresenter *)logoutPresenter;

- (void)requestedDisplayNameChange;

- (void)requestedPasswordChange;

- (void)requestedAccountConfirmation;

- (void)requestedDeviceManagement;

- (void)requestedLogout;

@end
