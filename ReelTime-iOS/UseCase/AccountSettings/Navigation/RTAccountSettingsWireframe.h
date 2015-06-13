#import <Foundation/Foundation.h>

@class RTChangeDisplayNameWireframe;
@class RTChangePasswordWireframe;
@class RTManageDevicesWireframe;

@interface RTAccountSettingsWireframe : NSObject

- (instancetype)initWithChangeDisplayNameWireframe:(RTChangeDisplayNameWireframe *)changeDisplayNameWireframe
                           changePasswordWireframe:(RTChangePasswordWireframe *)changePasswordWireframe
                            manageDevicesWireframe:(RTManageDevicesWireframe *)manageDevicesWireframe;

- (void)presentChangeDisplayNameInterface;

- (void)presentChangePasswordInterface;

- (void)presentManageDevicesInterface;

@end
