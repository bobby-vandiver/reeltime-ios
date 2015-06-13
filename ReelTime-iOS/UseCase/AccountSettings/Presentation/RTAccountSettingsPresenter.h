#import <Foundation/Foundation.h>

@class RTAccountSettingsWireframe;

@interface RTAccountSettingsPresenter : NSObject

- (instancetype)initWithWireframe:(RTAccountSettingsWireframe *)wireframe;

- (void)requestedDisplayNameChange;

- (void)requestedPasswordChange;

- (void)requestedDeviceManagement;

@end
