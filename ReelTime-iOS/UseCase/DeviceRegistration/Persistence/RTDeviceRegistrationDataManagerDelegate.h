#import <Foundation/Foundation.h>

@protocol RTDeviceRegistrationDataManagerDelegate <NSObject>

- (void)deviceRegistrationDataOperationFailedWithErrors:(NSArray *)errors;

@end
