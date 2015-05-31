#import <Foundation/Foundation.h>
#import "RTCallback.h"

@protocol RTDeviceRegistrationDataManagerDelegate;

@class RTAPIClient;
@class RTClientCredentialsStore;

@class RTUserCredentials;
@class RTClientCredentials;

@interface RTDeviceRegistrationDataManager : NSObject

- (instancetype)initWithDelegate:(id<RTDeviceRegistrationDataManagerDelegate>)delegate
                          client:(RTAPIClient *)client
          clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore;

- (void)fetchClientCredentialsForClientName:(NSString *)clientName
                        withUserCredentials:(RTUserCredentials *)userCredentials
                                   callback:(ClientCredentialsCallback)callback;

- (void)storeClientCredentials:(RTClientCredentials *)clientCredentials
                   forUsername:(NSString *)username
                      callback:(NoArgsCallback)callback;

@end
