#import <Foundation/Foundation.h>

@interface RTDeviceRegistrationInteractor : NSObject

- (void)registerDeviceWithDeviceName:(NSString *)deviceName
                            username:(NSString *)username
                            password:(NSString *)password;

@end
