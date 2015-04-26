#import <Foundation/Foundation.h>

@protocol RTDeviceRegistrationInteractorDelegate <NSObject>

- (void)deviceRegistrationSucceeded;

- (void)deviceRegistrationFailedWithErrors:(NSArray *)errors;

@end
