#import <Foundation/Foundation.h>
#import "RTDeviceRegistrationDataManagerDelegate.h"

@protocol RTDeviceRegistrationInteractorDelegate;
@class RTDeviceRegistrationDataManager;

@interface RTDeviceRegistrationInteractor : NSObject <RTDeviceRegistrationDataManagerDelegate>

- (instancetype)initWithDelegate:(id<RTDeviceRegistrationInteractorDelegate>)delegate
                     dataManager:(RTDeviceRegistrationDataManager *)dataManager;

- (void)registerDeviceWithClientName:(NSString *)clientName
                            username:(NSString *)username
                            password:(NSString *)password;

@end
